# G3viz: interactively visualize genomic data in a web-browser

G3viz is an [R](https://www.r-project.org/) package for interactively visualizing complex genomic data in a web browser, without knowing any HTML/Javascript technologies. 

## Introduction

Effectively visualizing genomic data can greatly help researchers to understand their genomic data.  The aim of this `g3viz` library is to provide a suite of web-based visualization tools that enables researchers to easily generate and interactively visualize their genomic data using a web browser, without knowing web related technologies (HTML5, Javascript, etc).

## Installation
```r
# Install devtools
install.package("devtools")

# load devtools
library(devtools)

# install g3viz from github
devtools::install_github("g3js/g3viz")

```

## Examples

#### Example 1.

Retrieve genomic mutation data of [msk\_impact\_2017](https://www.ncbi.nlm.nih.gov/pubmed/28481359) study for the gene _TP53_ from [cBioPortal](http://www.cbioportal.org/).

```r
library(g3viz)

# get mutation data of msk_impact_2017 study from cBioPortal
mutation.dat <- getMutationsFromCbioportal("msk_impact_2017", "TP53")

# lollipop diagram with default options
g3Lollipop(mutation.dat, gene.symbol = "TP53")
```

Lollipop plot:

<img src="./inst/demo/MSK_IMPACT_2017_TP53.png" width="700px" style="padding-left:100px">


#### Example 2.

Load data from [MAF](https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/) file, classified the mutation data by detailed _Variant\_Classification_ information (i.e., _Frame\_Shift\_Del_, _Split\_Site_). The test data was downloaded directly from [TCGA-BRCA](https://portal.gdc.cancer.gov/projects/TCGA-BRCA) project GDC Data Portal.

```r
library(g3viz)

# load and read MAF file
maf.file <- system.file("extdata", "TCGA.BRCA.varscan.somatic.maf.gz", package = "g3viz")
mutation.dat <- readMAF(maf.file)

# lollipop diagram, classified by "Variant_Classification"
# plot option: add title
g3Lollipop(mutation.dat,
           gene.symbol = "PIK3CA",
           factor.col = "Variant_Classification", # legend: use "Variant_Classfication" column
           chart.margin = list(left = 40, right = 40, top = 30, bottom = 25),
           title.text = "PIK3CA (TCGA-BRCA)", title.font = "normal 20px Sans",
           title.color = "steelblue", title.alignment = "middle", title.dy = "0.3em")
```
Lollipop plot:

<img src="./inst/demo/TCGA-BRCA-PIK3CA.png" width="700px" style="padding-left:100px">

