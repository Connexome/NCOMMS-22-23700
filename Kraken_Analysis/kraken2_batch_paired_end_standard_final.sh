#!/bin/bash
for name in $(find /{path_to_data_folder}/-name '*1.fastq.gz');  
do  kraken2 --db /{path_to_Standard_db}/Standard_db --threads 15 --gzip-compressed --confidence 0.6 --paired --memory-mapping "${name}" "${name%_*}_2.fastq.gz" --output "${name%%_.*}cf06.output" --report "${name%%_.*}cf06.report" 
done

