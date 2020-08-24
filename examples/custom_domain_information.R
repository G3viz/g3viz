library(g3viz)

#maf.file <- system.file("extdata", "TCGA.BRCA.varscan.somatic.maf.gz", package = "g3viz")
#mutation.dat <- readMAF(maf.file)


domain.fn <- "data-raw/TP53_P04637_interpro.csv"
domain.df <- read.csv(domain.fn)

Start.col = "Start"
End.col = "End"
Domain.ID = "Name"

all(c(Start.col, End.col, Domain.ID) %in% colnames(domain.df))

hgnc2pfam("TP53", output.format = "list")

library(biomaRt)

# select human ensembl
ensembl = useMart("ensembl",dataset="hsapiens_gene_ensembl")

#
