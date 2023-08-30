library(pegas)
library(adegenet)
library(vcfR)

## load data: phylip format
datafile.phy<-"" ## add the path to your phylip-formatted file
codonfile.phy<-"" ## add the path to a phylip-formatted file that only has the coding regions (CDs)
read.dna(datafile.phy)->data.dna
read.dna(codonfile.phy)->codons.dna


## load data: vcf
datafile.vcf<-"C:\\Users\\shann\\Documents\\Work\\Dirofilaria\\Nov2021.mtDi.isec.rmi.msg95.recode.vcf" ## add the path to your vcf file
read.vcfR(datafile.vcf)->data.vcf
vcfR2DNAbin(data.vcf)->data.dna


par(mfrow=c(2,1))
snpposi.plot(data.dna,codon=FALSE)
snpposi.test(data.dna,codon=FALSE)

snpposi.plot(codons.dna,codon=TRUE)
snpposi.test(codons.dna,codon=TRUE)
