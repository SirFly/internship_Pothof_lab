#!/bin/bash

FLEXBAR='/media/daria/NetDrive/DariaRepkina/Project/tools/flexbar-3.4.0-linux/flexbar' 
suffix="_1.fastq"

#stringent version 

for file in ../data/brain/male/3m/default_trim/*_1.fastq
    do 
        echo ${file}

		file_no_suffix=${file/%$suffix}

		echo "${file_no_suffix}"
        
        $FLEXBAR --reads ${file_no_suffix}_1.fastq \
            --reads2 ${file_no_suffix}_2.fastq --target ${file_no_suffix}_stringent \
            -qt 34 -n 8 -q WIN -qf sanger --min-read-length 90 --adapter-preset Nextera -ap ON

#default  (but instead of -qt 20 I put -qt 34) 

        $FLEXBAR --reads ${file_no_suffix}_1.fastq \
            --reads2 ${file_no_suffix}_2.fastq --target ${file_no_suffix}_default \
            -q TAIL -qt 34 -qf sanger -n 8 --adapter-preset Nextera -ap ON
     
    done
 
#mv ../data/brain/*/*/*stringent* ../data/brain/*/*/stringent_trim/
#mv ../data/brain/*/*/*default* ../data/brain/*/*/default_trim/