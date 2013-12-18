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
  if [[ "$((lrot$r%2))" == 1 ]]; then
    printf "$rot has an odd number of characters.\n"
    printf "Please edit the script and fix this.\n"
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
  for n in $(seq $numr -1 1); do
    total=lrot$((seq -s '*lrot' $n -1 1))
    if [[ "$step" -ge "$total" ]]
    then
      step=$((step-total))
      let length=lrot$n
      let steprot$n=$(($((steprot$n+1))%lrot$n))
    fi
  done
}

read -t 0
if [[ "$?" == 0 ]]
then
  read message
else
  printf "Type message.\n"
  read message
  printf "\n"
fi

while [[ -n "$message" ]]; do
  char=${message::1}
  for c in rot{1..3} refl rot{3..1}; do
    char=$(cipher $c "$char")
  done
  printf "$char"
  message=${message:1}
done

printf "\n"
