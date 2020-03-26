#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for i in {1..2}
do
  YAKE_IP="51.143.173.180" bash $DIR/run.bash 1>/dev/null 
done