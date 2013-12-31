#!/bin/bash
# Enigma Machine-like cipher
# By Anomitee


# Define rotors, cipher sequence, patchcords
# Do not edit manually unless you know what you're doing
# Either run the script with the "-i" flag, or carefully read the comments

# Rotors in the form 'rot#' where # is at least 1 digit
# Do not repeat characters
rot1='eostygurkxmnfbwcijdzqhavlp'
rot2='prkyftjicxbnzdavhsegloqwum'
rot3='laiguqwvmbnrtfdkzejycospxh'
rot4='yiwrnazltxkohpqufmdsegjcbv'

# Cipher sequence - the order that the message is passed throught the rotors
# Use the number after "rot" to indicate the rotors and separate using spaces.
cseq='1 2 3 4 3 2 1'

# Patchcords - use pairs of characters with no repetition
patc='afeyib'


# Perform checks and obtain information (e.g. string lengths, midpoints etc.)

rotn=`for r in "$cseq"; do echo $r; done | awk '!x[$0]++'` # Numbers of rotors used

# Check that the rotors to be used actually exist
for r in $rotn; do
  rot=rot$r
  if [[ -z "${!rot}" ]]; then
    printf "$rot is not defined"
    printf "Fix this by running with the -i flag edit the script (if you know how)"
    exit 80
  fi
done

# Function to check for repeated characters in rotors
rotorcheck() {
  for n in "$@"; do
    rot="rot$n"
    rep=`printf "${!rot}" | sed -n '/\(.\).*\1/p'`
    if [[ -n "$rep" ]]
    then
      printf "$rot has repeated characters."
      printf "Run the script with the -i flag to change it or edit it manually."
      exit 80
    fi
  done
}

rotorcheck  # Check the rotors to be used for repetition

patchcheck() {
  rep=`printf "$patc" | sed -n '/\(.\).*\1/p'`
  if [[ -n "$rep" ]]
  then
    printf "patc has repeated characters."
    printf "Run the script with the -i flag to change it or edit it manually."
    exit 80
  fi
}

patchcheck  # Check patchcords

