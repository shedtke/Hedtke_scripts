#!/bin/bash
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu=32768
#SBATCH --partition=week
#SBATCH --time=120:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=

module load SAMtools/1.15.1-GCC-11.2.0 
module load GATK/4.2.5.0-GCCcore-11.2.0-Java-11

## The list of identifiers for your samples from your bam files go here.
ID=" "

## reference path
REF=
## the directory where your bam files are
DIR=/data/group/grantlab/scratch/shedtke/WGAvsRR

## This should indicate anything that comes between the id and unique.bam; it's usually an indication of what genome the id was mapped to
info=nOv4.mtOv.wOv

## This is the genome or chromosome for variant calling. e.g. nOv4 or mt
genome=

## Set the ploidy; usually 2 for nuclear and 1 for mitochondrial data.
ploidy=

## set the chromosomes being called here. If you have more than one, separate them by -L (.e.g, L OVOC.OM1a_TELO_TELO -L OVOC.OM2_TELO_TELO)
chrom=

for i in $ID
do

echo "$i"

samtools index $i.$prefix.unique.bam
gatk HaplotypeCaller -R $REF -I $i.$info.unique.bam -O $i.$genome.gatk.vcf.gz -ERC GVCF -ploidy $ploidy $chrom

done