library(pegas)
library(adegenet)
library(viridis)
 
## insert filenames
phyfile<-" " ## if you have a phylip file
vcffile<-" " ## if you have a vcf
popfile<-" " ## spreadsheet with two columns that have the ID of each sample and the sampling location/host, in the same order as in your data

numcats<-10 # the number of categories of things; e.g., 10 hosts or 10 sample sites
ploidy<-1 # usually 2 for nuclear and 1 for mitochondrial or endosymbiont
 
## pick one of the following color schemes; or define as desired
mycol<-rainbow(numcats)
mycol<-viridis(numcats)
mycol<-magma(numcats)
 
# getting data into R; two examples
# phylip formatted file

as.genind(read.dna(phyfile,format="sequential"),ploidy=ploidy)->mydata.gi

# vcf

read.vcf(vcffile,from=1,to=500000)->mydata.vcf
loci2genind(oct2022.vcf,ploidy=ploidy)->mydata.gi


# Prep the data
read.table(popfile)->mydata.tab
mydata.pop<-as.factor(mydata.tab$V2) ## this assumes column two has your location data
mydata.X<-tab(mydata.gi,NA.method="mean")

## PCA plot
mydata.pca<-dudi.pca(oct2022.X,center=TRUE,scale=FALSE,nf=200,scannf=FALSE)
summary(mydata.pca)
s.class(mydata.pca$li,fac=oct2022.pop,col=transp(mycol,.6),clab=0,pch=19,grid=0,cpoint=1.25)

## Discriminant analysis of principal components
mydata.xval<-xvalDapc(mydata.X,grp=mydata.pop,n.pca.max=300,training.set=.9,result="groupMean",center=TRUE,scale=FALSE,n.pca=NULL,n.rep=100,xval.plot=TRUE)
summary(mydata.xval$DAPC)

## A scatterplot of the DAPC results
scatter(mydata.xval$DAPC,scree.da=FALSE,legend=1,pch=19,cstar=1,clab=0,cex=1.25,cellipse=1,col=transp(mycol,0.6))

## Figure that shows the posterior probability of assignment for each individual.
compoplot(mydata.xval$DAPC,col=mycol,show.lab=TRUE,posi="bottomright")

## Figure that shows the overall proportion of samples assigned to their collection site/host
myass<-summary(mydata.xval$DAPC)$assign.per.pop*100
barplot(myass,xlab="% correct assignment",horiz=TRUE,las=1,col=mycol,xlim=c(0,100))

## hacks for specifying shapes or colors
# example using shape
# make a new vector for the shape/color that has the same length as your number of samples
pop.shape<-vector(length=121)

## use grep to search your list of samples (ssuresist) for a population name (D0) and set it to shape 24
pop.shape[grep('D0',ssuresist)] <-24

## set D80 to shape 19
pop.shape[grep('D80',ssuresist)] <-19

## example using color
# my list for my samples was called gharesp
ghacol<-gharesp
## I then searched my list of samples for the word "poor" and set the color to #440154FF
ghacol[grep('poor',gharesp)]<-"#440154FF"
## here I looked for the word "medium" and set the color to red
ghacol[grep('medium',gharesp)]<-"red"
