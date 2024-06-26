% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/TCGAbiolinks.R
\docType{data}
\name{geneInfoHT}
\alias{geneInfoHT}
\title{geneInfoHT for normalization of HTseq data}
\format{
A data frame with 23486 rows and 2 variables
}
\description{
Code to generate the data in examples
}
\examples{
\dontrun{
library(EDASeq)
library(biomaRt)
#get ensembl gene IDs for hg38
ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
biomart_getID <- getBM(attributes = c("ensembl_gene_id"), mart = ensembl)
#get gene length and GC content for all IDs

step <- 500
geneInfoHT <- plyr::adply(seq(1,length(biomart_getID$ensembl_gene_id),step),.margins = 1,.fun = function(x){
    begin <- x
   end <- x + step
    if(end > length(biomart_getID$ensembl_gene_id)) end <- length(biomart_getID$ensembl_gene_id)
    file <- paste0("geneInfoHT_from_",begin,"_to_",end,".rda")
    if(!file.exists(file)){
        df <- getGeneLengthAndGCContent(biomart_getID$ensembl_gene_id[begin:end] , org="hsa", mode = c("biomart"))
        save(df,file = file)
    } else {
        df <- get(load(file))
    }
    df
},.progress = "time")
saveRDS(getdata, file = "getGLGC_download.RDS")a
save(getdata, file = "getGLGC_download.rda")
#Save output as data frame with correct header names
geneInfoHT <- data.frame(
    geneLength = getdata[,1] ,
    gcContent = getdata[,2]
)
#Save final table
save(geneInfoHT, file = "data/geneInfoHT.rda")
}
}
\keyword{internal}
