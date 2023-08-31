#!/bin/bash
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu=32768
#SBATCH --partition=week
#SBATCH --time=120:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=

module load GATK
module load SAMtools
module load BWA

## This should be the full path to your reference file.
REF=

## the following variable should have the same as the ref, but ends in .dict rather than .fa or .fna or .fasta
DICT=

bwa index $REF

gatk CreateSequenceDictionary R=$REF O=$DICT

samtools faidx $REF