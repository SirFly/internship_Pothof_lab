#!/bin/bash
cd ../


RNA_REF_GTF='./ref_genome/mm39/Mus_musculus.GRCm39.103_with_chr.gtf'
RNA_REF_GTF_REFSEQ='./ref_genome/mm39/RefSeq/mm39_mouse_Refseq.gtf'
RNA_REF_GTF_REFSEQ_SELF='./ref_genome/mm39/RefSeq/mm39_mouse_Refseq_longest_transcript.gtf'


suffix="_markdup.bam"

for file in ./data/brain/male/3m/default_trim/*_1.fastq


	do
		echo ${file}

		file_no_suffix=${file/%$suffix}

		echo "${file_no_suffix}"
        
        echo "hisat"

		hisat2 -p 7 --rg-id=$file_no_suffix --rg LB:${file_no_suffix} --rg PL:ILLUMINA -x ../../JiangChang/reference/reference/mm39/mm39 --dta \
			-1 ${file} -2 ${file_no_suffix}_2.fastq -S ${file_no_suffix}.sam #default is unstranded (as in the paper)

        echo "samtools"

		samtools sort -@ 8 -n -o ${file_no_suffix}.bam ${file_no_suffix}.sam

		rm ${file_no_suffix}.sam
        
        samtools fixmate -@ 8 -m ${file_no_suffix}.bam ${file_no_suffix}_fixmate.bam
        samtools sort -@ 8 -o ${file_no_suffix}_positionsort.bam ${file_no_suffix}_fixmate.bam
        samtools markdup -@ 8 ${file_no_suffix}_positionsort.bam ${file_no_suffix}_markdup.bam
        
        samtools index -@ 8 ${file_no_suffix}_markdup.bam

		bam_stat.py -i ${file_no_suffix}_markdup.bam |& tee ${file_no_suffix}_markdup_stats

		htseq-count --format bam --order pos --stranded=no --type exon --idattr gene_name ${file_no_suffix}_markdup.bam $RNA_REF_GTF > ${file_no_suffix}.tsv
        
        htseq-count --format bam --order pos --stranded=no --type transcript --idattr gene_id ${file_no_suffix}_markdup.bam $RNA_REF_GTF_REFSEQ_SELF > ${file_no_suffix}_Refseq_longest_tr.tsv


	done