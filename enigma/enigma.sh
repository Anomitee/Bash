#!/bin/bash
# Enigma Machine-like cipher
# By Anomitee

# Define rotors and reflectors

rot1=eostygurkxmnfbwcijdzqhavlp
rot2=prkyftjicxbnzdavhsegloqwum
rot3=laiguqwvmbnrtfdkzejycospxh
refl=yiwrnazltxkohpqufmdsegjcbv
numr=3

for r in $(seq $numr); do
  rot=rot$r
  let l$rot=$(expr length ${!rot})
  if [[ "$(($l$r%2))" == 1 ]]; then
    printf "$rot has an odd number of characters."
    printf "Please edit the script and fix this."
    exit 1
  fi
  let step$rot=0
done


# Functions and variables

cipher() {
  shift=step$1
  rot=${!1}
  mid=$((${#rot}/2))
  printf "$2" | tr "${rot:${!shift}}${rot::${!shift}}" "${rot:$mid}${rot::$mid}"
}

turn() {
  step=$((step+1))
  for n in $(seq $numr -1 1)
    total=$((lrot`seq -s *lrot $n -1 1`))
    if [[ "$step" -ge "$total" ]]
    then
      step=$((step-total))
      let length=lrot$n
      let steprot$n=$(($((steprot$n+1))%lrot$n))
    fi
  done
}
