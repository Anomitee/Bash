#!/bin/bash
# Enigma Machine-like cipher
# By Anomitee

# Define rotors and reflectors

rot1=eostygurkxmnfbwcijdzqhavlp
rot2=prkyftjicxbnzdavhsegloqwum
rot1=laiguqwvmbnrtfdkzejycospxh
refl=yiwrnazltxkohpqufmdsegjcbv

for r in rot{1..3} refl; do
  if [[ "$((${#r}%2))" == 1 ]]; then
    printf "$r has an odd number of characters."
    printf "Please edit the script and fix this."
    exit 1
  fi
  step$r=0
done


# Functions and variables

cipher() {
  step=step$1
  mid=$((${#1}/2))
  printf "$2" | tr "${1:${!step}}${1::${!step}}" "${1:$mid}${1::$mid}"
}

turn() {
  step=$((step+1))
  
