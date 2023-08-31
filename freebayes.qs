#!/bin/bash
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu=32768
#SBATCH --partition=week
#SBATCH --time=120:00

module load freebayes/1.3.5-GCC-10.2.0

## path_to_reference
REF=
## set the file base name. Use the same base name across variant callers if you are using more than one.
fileBaseName=" "
## set the ploidy; usually 2 for nuclear and 1 for mitochondrial data
ploidy=1
## set the path to the directory where your bam files are (no final /)
dir=
## set the genome used; this will be in the output filename (e.g., nOv4, mt)
genome=" "
## This should have the chromosome(s) variant calling is going to be done on and the positions to be called. e.g. " -r OVOC_MITOCHONDRIAL:1-13744"
# If you have more than one, each chromosome should be proceeded by -r
chrom=" "

echo "calling variants freebayes"
ls $dir/*unique.bam > bamlist
freebayes -f $REF -L bamlist $chrom -= -p $ploidy > $fileBaseName\.$genome\.fb.vcf
