#!/bin/bash
for name in $(find /{path_to_kraken2_results}/ -name '*.NT_40report');  
do  bracken -i "${name}" -d /{path_to_NT_DB}/NT_db -t 20 -r 150 -l S -o "${name%%_.*}.NT_40outputbracken" -w "${name%%_.*}.NT_40reportbracken"
done

