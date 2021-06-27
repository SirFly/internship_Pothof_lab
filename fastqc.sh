#!/bin/bash


for dir in ../data/heart/*/*/             #not trimmed

    do
        cd $dir
        echo ${dir}
        fastqc *.fastq -t 7
        cd /media/daria/NetDrive/DariaRepkina/Project/scripts
    done
    
for dir in ../data/liver/*/*/default_trim/   #default trim

    do
        cd $dir
        fastqc *.fastq -t 7
        cd /media/daria/NetDrive/DariaRepkina/Project/scripts
    done
    
    
for dir in ../data/heart/*/*/stringent_trim/  #stringent trim
    do
        cd $dir
        fastqc *.fastq -t 7
        cd /media/daria/NetDrive/DariaRepkina/Project/scripts
    done