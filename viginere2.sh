#!/bin/bash
# Rewritten Viginère Cipher Script
# By Anomitee


# Define default variables and functions

# Convert all letters to lowercase, remove everything else.
function clean {
  echo "$1" | tr A-Z a-z | sed s/[^a-z]//g
}

# Print an error message
function error {
  echo "-k flag with an argument containing at least 1 letter required when piping."
  echo "Try 'viginere2.sh -h' for usage information"
}

# Print usage information
function helpinfo {
  echo "Usage: 'viginere2.sh [OPTION]'"
  echo "  or: 'viginere2.sh [OPTION] -k KEY' if piping into stdin"
  echo "Perform or reverse a viginere cipher"
  echo
  echo "  -h      Display this help"
  echo "  -e      Skip the encode/decode prompt and automatically encode"
  echo "  -d      Skip the encode/decode prompt and automatically decode"
  echo "  -k KEY  Use KEY as the key. Required if piping into stdin"
  exit 0
}

# Set default operation as encoding
op="+"

# Character sets of alphabet and "betagam"
alphabet=abcdefghijklmnopqrstuvwxyz
betagam=bcdefghijklmnopqrstuvwxyz


# Get options and test for piping into stdin

while getopts edhk: flags    # Get options
do
  case $flags in
  e)  continue=1;;          # Skips prompting for encoding/decoding.
  d)  continue=1; op="-";;  # Makes the operation subtraction (used to decode). Skips encode/decode prompt
  h)  helpinfo;;
  k)  key=$(clean "$OPTARG"); option=1;; # Argument is taken as key.
  esac                      # "option" will be used to determine if -k was used and for "error" messages
done

read -t 0 < /dev/stdin  # Check something has been piped.
if [[ "$?" = 0 ]]       # If so,
then
  continue=1            # Set "continue" to 1
  pipe=1                # Set "pipe" to 1
  if [[ -z "$key" ]]    # Check if cleaned up key contains at least 1 letter
  then
    error
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
  echo "Enter message"                                        # Prompt to enter message
  echo "Case will be ignored."                                # Prompt with restrictions
  echo "Anything other than letters and space will be removed"
  read plaintext                                              # Read user input as the message
fi
plaintext=$(clean "$plaintext")                               # Clean the plaintext


# Obtain the key

while test -z "$key"                                # If "key" is still empty
do
  if [[ "$option" = 1 ]]                            # If "option" is 1 (i.e. if -k was used)
  then
    echo "-k argument must have at least 1 letter"
    echo "You will now be prompted for a key"
  fi
  echo Enter key                                # Prompt to enter the key
  echo Same restrictions apply as the message.  # Prompt with restrictions being the same as message
  read key                                      # Read user input as the key
  key=$(clean key)                              # Clean the key
  if [[ -z "$key" ]]                            # Check if key contains at least 1 character
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
  shift=${key:$step:1}
  code=$(echo -n $(($(expr index $betagam $char)$op$(expr index $betagam $shift))))
  step=$(($(($step+1))%$length))
  if [[ $code -lt 0 ]]      # If result is less than 0
  then
    code=$((code+26))       # add 26 so it loops around from 0 to 25 (a to z)
  fi
  if [[ $code -gt 25 ]]     # If the result is greater than 25
  then
    code=$((code-26))       # subtract 26.
  fi
  echo -n ${alphabet:$code:1}
  plaintext=${plaintext:1}
done

echo
