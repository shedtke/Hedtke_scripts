library(vcfR)

## load vcf
## put your vcf name here
vcffile<-"//wsl.localhost/Ubuntu/home/shedtke/data_backup/testmsg.recode.vcf"

read.vcfR(vcffile)->mydata.vcfR
OM1.chrom <- create.chromR(name="OVOC.OM1a_TELO_TELO_559638", vcf=mydata.vcfR, verbose=FALSE)

## if you want to further filter the data
OM1.chrom <- masker(OM1.chrom, min_DP=50,max_DP=1000)
OM1.chrom <- proc.chromR(OM1.chrom)

## get the depth
OM1.dp <- extract.gt(OM1.chrom, element="DP", as.numeric=TRUE)

## plot all the variants
heatmap.bp(OM1.dp,clabels = TRUE,rlabels = FALSE)

## plot a smaller range
## note that the range is defined by the SNPs, not chromosome position
heatmap.bp(OM1.dp[1:500,],clabels = TRUE,rlabels = FALSE)