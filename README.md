# G3Viz: interactively visualize genomic data

Easily and effectively visualizing genomic data can help researchers to better understand their data. 
G3Viz is an [R](https://www.r-project.org/) package, which aims to provide a suite of easy-to-use visualization tools to enable users to interactively visualize genomic data in a web browser, without having to know any HTML5/JavaScript technologies. 

## Install
```r
# Install devtools
install.package("devtools")

# load devtools
library(devtools)

# install g3viz from github
devtools::install_github("g3js/g3viz")

```

## Examples

### Example 1: visualize mutation data from [cBioPortal](http://www.cbioportal.org/)

Retrieve genomic mutation data of [msk\_impact\_2017](https://www.ncbi.nlm.nih.gov/pubmed/28481359) study for the gene _TP53_ from [cBioPortal](http://www.cbioportal.org/).

```r
library(g3viz)

# get mutation data of msk_impact_2017 study from cBioPortal
mutation.dat <- getMutationsFromCbioportal("msk_impact_2017", "TP53")

# lollipop diagram with default options
g3Lollipop(mutation.dat, gene.symbol = "TP53")
```
>
> [Live example](https://bl.ocks.org/phoeguo/raw/583a12e04c6b9d7ca1825cdbdc62f531/)
>
> <img src="./inst/extdata/MSK_IMPACT_2017_TP53.png" width="600px">
>

### Example 2: visualize mutation data from [MAF](https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/)

Load data from [MAF](https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/) file, classified the mutation data by detailed _Variant\_Classification_ information (i.e., _Frame\_Shift\_Del_, _Split\_Site_).  In this example, the MAF data was downloaded directly from [TCGA-BRCA](https://portal.gdc.cancer.gov/projects/TCGA-BRCA) project GDC Data Portal.

```r
library(g3viz)

# load and read MAF file
maf.file <- system.file("extdata", "TCGA.BRCA.varscan.somatic.maf.gz", package = "g3viz")
mutation.dat <- readMAF(maf.file)

# lollipop diagram, classified by "Variant_Classification"
# plot options: add chart title
plot.options <- g3Lollipop.options(chart.margin = list(left = 40, right = 40, top = 30, bottom = 25),
                                   title.text = "PIK3CA (TCGA-BRCA)", title.font = "normal 20px Sans",
                                   title.color = "steelblue", title.alignment = "middle", title.dy = "0.3em")
g3Lollipop(mutation.dat,
           gene.symbol = "PIK3CA",
           factor.col = "Variant_Classification",
           plot.options = plot.options)
```
>
> [Live example](https://bl.ocks.org/phoeguo/raw/302a0ff5729f6aa773c33d4bfd3061c4/)
>
> <img src="./inst/extdata/TCGA_BRCA_PIK3CA.png" width="600px">
>

### Example 3: visualize mutation data in _CSV_ or _TSV_ format

Load user-defined file in _CSV_ or _TSV_ format.

```r
library(g3viz)

# load and read data
mutation.csv <- system.file("extdata", "ccle.csv", package = "g3viz")

# customized column names
mutation.dat <- readMAF(mutation.csv,
                        gene.symbol.col = "Hugo_Symbol",
                        variant.class.col = "Variant_Classification",
                        protein.change.col = "amino_acid_change",
                        sep = ",")  # separator of csv file

# plot options: try to mimic MutationMapper (http://www.cbioportal.org/mutation_mapper.jsp)
#               change color scheme of mutation track and domain annotation track
plot.options <- g3Lollipop.options(chart.width = 1600,
                                   chart.type = "circle",
                                   lollipop.track.background = "transparent",
                                   lollipop.pop.max.size = 4,
                                   lollipop.pop.min.size = 4,
                                   lollipop.pop.info.limit = 4.1, # same pop size
                                   y.axis.label = "# Mutations",
                                   lollipop.line.color = "grey",
                                   lollipop.line.width = 0.5,
                                   lollipop.circle.color = "black",
                                   lollipop.circle.width = 0.5,
                                   lollipop.color.scheme = "bottlerocket2",
                                   anno.bar.margin = list(top = 5, bottom = 5),
                                   domain.color.scheme = "darjeeling2",
                                   domain.text.font = "normal 8px Arial",
                                   domain.text.color = "white"
                                   )

g3Lollipop(mutation.dat,
           gene.symbol = "APC",
           gene.symbol.col = gene.symbol.colname,
           protein.change.col = protein.change.colname,
           plot.options = plot.options)
```
>
> [Live example](https://bl.ocks.org/phoeguo/raw/60f804c6683de30650e36ee912304754/)
>
> <img src="./inst/extdata/CCLE_APC.png" width="900px">
>

## Usage

1. Read data

Genomic mutation data (_e.g._, [aggregated somatic mutations](https://docs.gdc.cancer.gov/Encyclopedia/pages/Aggregated_Somatic_Mutation/)) can be loaded from

* [MAF](https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/) file, for example,

```r
maf.file <- system.file("extdata", "TCGA.BRCA.varscan.somatic.maf.gz", package = "g3viz")
mutation.dat <- readMAF(maf.file)
```

* directly from [cBioPortal]<a href="https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/">MAF</a> (internet access required), for example,

```r
# get mutation data of msk_impact_2017 study from cBioPortal
mutation.dat <- getMutationsFromCbioportal("msk_impact_2017", "TP53")
```

* _CSV_ or _TSV_ file

```r
# load and read data
mutation.csv <- system.file("extdata", "ccle.csv", package = "g3viz")

mutation.dat <- readMAF(mutation.csv,
                        gene.symbol.col = "Hugo_Symbol",
                        variant.class.col = "Variant_Classification",
                        protein.change.col = "amino_acid_change",
                        sep = ",")  # separator of csv file
```

2. Set chart options

Chart options can be specified using `g3Lollipop.options()` function (_e.g._, `g3Lollipop.options(chart.type = "circle", lollipop.track.background = "transparent")`.  Use `?g3viz::g3Lollipop.options` to check these options.
These options are listed in the following table. 

Option name             | Description
----------------------- | --------------------------------------
* Chart options         |
chart.width             | chart width in pixel.  Default `800`.
chart.type              | pop type, _pie_ or _circle_.  Default `pie`.
chart.margin            | specify chart margin in _list_ format.  Default `list(left = 40, right = 20, top = 15, bottom = 25)`.
chart.background        | chart background.  Default `transparent`.
transition.time         | chart animation transition time in millisecond.  Default `600`.
y.axis.label            | Y-axis label text.  Default `mutations`.
axis.label.font         | css font style shorthand (font-style font-variant font-weight font-size/line-height font-family).  Default `normal 12px Arial`.
axis.label.color        | axis label text color.  Default `#4f4f4f`.
axis.label.alignment    | axis label text alignment (start/end/middle). Default `middle`
axis.label.dy           | text adjustment of axis label text.  Default `-2em`.







