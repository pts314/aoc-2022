#!/bin/bash
set -euo pipefail
SCRIPT_DIR=$(realpath "$(dirname "$0")")

if [[ $# < 1 ]]; then
  echo "Please provide a day number."
  echo "usage: $0 DAY"
  exit 1
fi

silent=0
if [[ $# > 1 ]]; then
  silent=1
fi

if [[ ! "$1" =~ ^(0[1-9]|1[0-9]|2[0-5])$ ]]; then
  echo "Argument '$1' is not a valid day."
  exit 1
fi

if [[ ! -d $SCRIPT_DIR/day$1 ]]; then
  mkdir $SCRIPT_DIR/day$1
fi

if [[ ! -f $SCRIPT_DIR/day$1/solution.ipynb ]]; then
  cp base/solution.ipynb $SCRIPT_DIR/day$1/solution.ipynb 
fi

if [[ ! -f $SCRIPT_DIR/day$1/example.txt ]]; then
  touch $SCRIPT_DIR/day$1/example.txt
fi

if [[ -z "${AOC_SESSION-""}" ]]; then
  echo "No session token set in \$AOC_SESSION."
  exit 1
fi

if [[ $silent > 0 ]]; then
  exit 0
fi

URL="https://adventofcode.com/2022/day/$(("10#$1" + 0))/input"
curl "$URL" --cookie "session=$AOC_SESSION" -s | tee "$SCRIPT_DIR/day$1/input.txt"
