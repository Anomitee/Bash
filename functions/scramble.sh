#!/bin/bash
# String scrambler
# Scrambles a string based on the $RANDOM variable
# By Anomitee

# Function for easy copy-pasting into other scripts
scramble() {
  string=$1                           # Obtain string to scramble
  while [[ -n "$string" ]]; do                  # Whilst the string is still of non-zero length
    length=${#string}                           # get the length of the string
    char=${string:$((RANDOM%$length)):1}        # Get a random character from the string
    buffer=$buffer$char                         # Save it to a "buffer" variable
    string=$(printf "$string" | sed s/$char//)  # Delete it from the string
  done
  string=$buffer      # Replace the string with its scrambled version
  printf "$string"    # Print string (no newline for more flexibility)
}

scramble $1
