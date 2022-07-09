#!/bin/bash
for name in $(find /media/data_analysis/Store3/StangFastQ_cat -name '*1.fastq.gz');  
do  kraken2 --db /dev/shm/NT_db --threads 15 --gzip-compressed --confidence 0.6 --paired --memory-mapping "${name}" "${name%_*}_2.fastq.gz" --output "${name%%_.*}cf06.NT_40output"  --report "${name%%_.*}cf06.NT_40report" 
done

