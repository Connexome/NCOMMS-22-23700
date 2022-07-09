#!/bin/bash
for name in $(find /{path_to_kraken2_results}/ -name '*.report');  
do  bracken -i "${name}" -d /{path_to_Standard_db}/Standard_db -t 10 -r 150 -l S -o "${name%%_.*}.outputbracken" -w "${name%%_.*}.reportbracken"
done

