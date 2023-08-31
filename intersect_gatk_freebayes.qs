#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --partition=week
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=65536
#SBATCH --mail-type=all
#SBATCH --mail-user=

module load BCFtools/1.14-GCC-11.2.0
module load vcflib/1.0.2-GCC-10.2.0
module load VCFtools/0.1.16-GCC-11.2.0
module load GATK

## this script takes variant calls from GATK and freebayes, does a quality filtering step, and then finds the intersect between the two

## reference genome
REF=

##basename for files produced
filebasename=" "
## an identifier for the genome called (e.g., "nOv4", "mt")
genome=" "
## the minimum read depth per site required for a variant call to be retained
minDP=
minQ=30
minGQ=10

ISEC_DIR=$filebasename\.$genome\.isec

echo "filtering gatk for quality"
gatk VariantFiltration -V $filebasename\.$genome\.GG.vcf.gz -O $filebasename\.$genome\.qual.GG.vcf.gz -filter "QD < 2.0" --filter-name "QD2" -filter "QUAL < 30.0" --filter-name "QUAL30" -filter "SOR > 3.0" --filter-name "SOR3" -filter "FS > 60.0" --filter-name "FS60" -filter "MQ < 40.0" --filter-name "MQ40" -filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8"
vcftools --gzvcf $filebasename\.$genome\.qual.GG.vcf.gz --minDP $minDP --recode --out $filebasename\.$genome\.qual.GG --non-ref-ac-any 1

echo "filtering freebayes for quality"
vcftools --vcf $filebasename\.$genome\.fb.vcf --minDP $minDP --minQ $minQ --minGQ $minGQ --recode --out $filebasename\.$genome\.qual.fb --non-ref-ac-any 1

echo "normalizing vcf fb"
bgzip $filebasename\.$genome\.qual.fb.recode.vcf
tabix $filebasename\.$genome\.qual.fb.recode.vcf.gz
bcftools norm -f $REF -o $filebasename\.$genome\.norm.fb.vcf $filebasename\.$genome\.qual.fb.recode.vcf.gz

echo "allelic primitive vcf fb"
bgzip $filebasename\.$genome\.norm.fb.vcf
tabix $filebasename\.$genome\.norm.fb.vcf.gz
vcfallelicprimitives -k -g $filebasename\.$genome\.norm.fb.vcf.gz > $filebasename\.$genome\.ap.fb.vcf
bgzip $filebasename\.$genome\.ap.fb.vcf
bcftools index $filebasename\.$genome\.ap.fb.vcf.gz

bgzip $filebasename\.$genome\.qual.GG.recode.vcf
bcftools index $filebasename\.$genome\.qual.GG.recode.vcf.gz

echo "intersection of freebayes and gatk variant calling"
bcftools isec -p $filebasenameSEC_DIR -O z $filebasename\.$genome\.ap.fb.vcf.gz $filebasename\.$genome\.qual.GG.recode.vcf.gz

echo "analysis complete"
