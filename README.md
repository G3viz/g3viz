# <a name="top"></a>G3viz: an R package to interactively visualize genetic mutation data using a lollipop-diagram

  **Date: 2019-04-01**
  
  [![Build Status](https://travis-ci.org/G3viz/g3viz.svg?branch=master)](https://travis-ci.org/G3viz/g3viz)
  [![CRAN_version](http://www.r-pkg.org/badges/version/g3viz)](https://cran.r-project.org/package=g3viz)
  [![CRAN_monthly_download](https://cranlogs.r-pkg.org/badges/g3viz)](https://cran.r-project.org/package=g3viz)

## Check [introduction](https://g3viz.github.io/g3viz/)
## Check [demos](https://g3viz.github.io/g3viz/chart_themes.html)

## Introduction

Intuitively and effectively visualizing genetic mutation data can help researchers to better understand genomic data and validate findings.  `G3viz` is an R package which provides an easy-to-use lollipop-diagram tool.  It enables users to interactively visualize detailed translational effect of genetic mutations in RStudio or a web browser, without having to know any HTML5/JavaScript technologies.

The features of `g3viz` include

- Interactive (zoom & pan, tooltip, brush selection tool, and interactive legend)
- Highlight and label positional mutations
- 8 ready-to-use chart themes
- Highly customizable with over 50 chart options and over 35 color schemes
- Save charts in PNG or high-quality SVG format
- Built-in function to retrieve protein domain information and resolve gene isoforms
- Built-in function to map genetic mutation type (a.k.a, variant classification) to mutation class

## Install `g3viz`

Install from R repository
```r
# install package
install.packages("g3viz", repos = "http://cran.us.r-project.org")
```
or install development version from github
```r
# Check if "devtools" installed
if("devtools" %in% rownames(installed.packages()) == FALSE){ 
  install.packages("devtools")
}

# install from github
devtools::install_github("g3viz/g3viz")
```

