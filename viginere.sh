#!/bin/bash
# Viginère Cipher Script
# By Anomitee
# For more information, visit http://git.io/k0aGvw

op="+"  # Set default operation to addition (this is used to encode a message)


# "Tests"

while getopts edk: flags    # Get options
do
  case $flags in
  e)  continue=1;;          # Skips prompting for encoding/decoding. Handy if not piping your message in
  d)  continue=1; op="-";;  # Makes the operation subtraction (used to decode). Skips encode/decode prompt
  k)  key=$(echo "$OPTARG" | tr A-Z a-z | sed s/[^a-z]//g); option=1;;  # Argument is taken as key.
  esac                      # "option" will be used to determine if -k was used and for "error" messages
done

read -t 0 < /dev/stdin  # Check something has been piped.
if [[ "$?" = 0 ]]       # If so,
then
  continue=1            # Set "continue" to 1
  pipe=1                # Set "pipe" to 1
  if [[ -z "$key" ]]
  then
    echo "-k flag with an argument containing at least 1 letter required when piping."  # "Error" message if piping
    echo "Visit http://git.io/k0aGvw for more usage information"                        # Link to wiki on GitHub
    exit 1              # Exit the script with an exit code of 1
  fi
fi


# Determine if performing a cipher or reversing one

while [[ "$continue" != 1 ]]  # Loop whilst "continue" is not 1
do
  echo "Are you encoding or decoding?"    # Prompt if encoding or decoding
  echo "Enter 0 to encode, 1 to decode"   # Prompt with required inputs
  read -n 1 reverse                       # Read user input after 1 character is entered
  echo
  if [[ "$reverse" = 1 ]] # If 1 was entered (yes):
  then
    continue=1            # Set "continue" to 1 (breaking the loop)
    op="-"                # Set the operation performed as subtraction (decode)
  fi
  if [[ "$reverse" = 0 ]] # If 0 was entered (no):
  then
    continue=1            # Break the loop by setting continue to 1
    op="+"                # Set the operation performed as addition (encode)
  fi
  if [[ "$continue" != 1 ]]     # Check if "continue" is still 0 (if 1 or 0 was not entered)
  then
    echo "Please enter 1 or 0"  # Prompt with possible inputs if "continue" is not 1
  fi
done


# Obtain message

if [[ "$pipe" = 1 ]]                                          # If piping
then
  read plaintext < /dev/stdin                                 # accept the piped input as the plaintext
else
  echo Enter message                                          # Prompt to enter message
  echo Case will be ignored.                                  # Prompt with restrictions
  echo Anything other than letters and space will be removed
  read plaintext                                              # Read user input as the message
fi
plaintext=$(echo "$plaintext" | tr A-Z a-z | sed s/[^a-z]//g) # Change letters to lowercase, remove all else


# Obtain the key

while test -z "$key"                                # If "key" is still empty
do
  if [[ "$option" = 1 ]]                            # If "option" is 1 (i.e. if -k was used)
  then
    echo "-k argument must have at least 1 letter"
    echo "You will now be prompted for a key"
  fi
  echo Enter key                                    # Prompt to enter the key
  echo Same restrictions apply as the message.      # Prompt with restrictions being the same as message
  read key                                          # Read user input as the key
  key=$(echo "$key" | tr A-Z a-z | sed s/[^a-z]//g) # As with message, change letters to lowercase, remove all else
  if [[ -z "$key" ]]                                # Check if key contains at least 1 character
  then
    echo "You must enter at least 1 letter as the key"
  fi
done

length=${#key}  # Obtain the length of the sanitized key
step=0          # Set the "step" of the key to 0.


# Encode/decode message using key

while test -n "$plaintext"                    # Loop whilst the length of "plaintext" is non-zero
do
  char=${plaintext:0:1}                       # Set "char" as the first character of "plaintext"
  loop=25                                     # Set/reset "loop" to 25
  for letter in {z..a}                        # Loop through all the letters backwards (from z to a)
  do                                          # For each letter looped through
    char=$(echo $char | sed s/$letter/$loop/) # Replace that letter (if it exists) with the current value of "loop"
    loop=$((loop-1))                          # Decrease "loop" by 1
  done                                        # This replaces each letter with its numerical equivalent

  loop=25               # Reset loop to 25
  shift=${key:$step:1}  # Take the character from "key" determined by "step" (0 = 1st, 1 = 2nd etc)
  for letter in {z..a}  # Once again, convert the letter to its number. This is the shift (for the cipher)
  do
    shift=$(echo $shift | sed s/$letter/$loop/)
    loop=$((loop-1))
  done
  # Increase "step" by one, and mod the length of the key, so it loops around
  step=$(($(($step+1))%$length))

  # Calculate the numerical equivalent of the encoded/decoded character
  code=$(($char$op$shift))  # Perform the operation "op" between "char" and "shift"
  if [[ $code -lt 0 ]]      # If result is less than 0
  then
    code=$((code+26))       # add 26 so it loops around from 0 to 25 (a to z)
  fi
  if [[ $code -gt 25 ]]     # If the result is greater than 25
  then
    code=$((code-26))       # subtract 26.
  fi

  # Convert the resulting number to it's equivalent letter
  loop=25
  for letter in {z..a}
  do
    code=$(echo $code | sed s/$loop/$letter/)
    loop=$((loop-1))
  done

  # Set the encoded/decoded message as the pre-existing "message" followed by the character "code"
  message=$message$code
  # Remover the first character from "plaintext"
  plaintext=${plaintext:1}
done

# Display encoded/decoded message
echo $message
