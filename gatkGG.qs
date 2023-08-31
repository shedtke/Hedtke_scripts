#!/bin/bash
#SBATCH --cpus-per-task 2
#SBATCH --mem-per-cpu=16384
#SBATCH --partition=week
#SBATCH --time=72:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=

module load GATK/4.2.5.0-GCCcore-11.2.0-Java-11

## path to reference file
REF=
## this should be the same genome & fileBaseName used in gatk HaplotypeCaller or freebayes.
genome=" "
fileBaseName=" "
## set the ploidy. Typically nuclear is 2 and mitochondrial is 1.
ploidy=1
## set the directory where the variant call files from GATK HaplotypeCaller are
## note that you need to make sure only those vcf.gz files that you want to call variants on are in the directory
dir=

## This is the command to combine the output of HaplotypeCaller

list $dir/*vcf.gz > gatklist.txt

gatk CombineGVCFs -O $fileBaseName\.$genome\.HC.vcf.gz -R $REF --variant gatklist.txt

## this is the command to call genotypes

gatk IndexFeatureFile -I $fileBaseName\.$genome\.HC.vcf.gz -O $fileBaseName\.$genome.HC.vcf.tbi
gatk GenotypeGVCFs -R $REF -V $fileBaseName\.$genome\.HC.vcf.gz -O $fileBaseName.$genome\.GG.vcf.gz -ploidy $ploidy --use-new-qual-calculator

