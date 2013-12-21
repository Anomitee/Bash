#!/bin/bash
# String scrambler
# Scrambles a string
# By Anomitee

# Function for easy copy-pasting into other scripts
scramble() {
  opt=0
  while getopts n flag; do
    case $flag in
    n)  opt=1; end="\n";;
    esac
  done
  if [[ "$#" -gt "$((1+opt))" ]]; then
    printf "More than 1 argument detected.\n"
    printf "Quote spaces if you want all arguments to be read as 1\n"
    printf "Otherwise, scramble each string separately"
  fi
  string=$((1+opt))                             # Obtain string to scramble
  while [[ -n "$string" ]]; do                  # Whilst the string is still of non-zero length
    length=${#string}                           # get the lenght of the string
    char=${string:$((RANDOM%$length)):1}        # Get a random character from the string
    buffer=$buffer$char                         # Save it to a "buffer" variable
    string=$(printf "$string" | sed s/$char//)  # Delete it from the string
  done
  string=$buffer      # Replace the string with its scrambled version
  printf "$string$n"  # Print string (no newline for more flexibility)
}

scramble $1
