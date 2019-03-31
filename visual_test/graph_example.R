library(g3viz)

# get mutation data of msk_impact_2017 study from cBioPortal
maf.file <- system.file("extdata", "TCGA.BRCA.varscan.somatic.maf.gz", package = "g3viz")
mutation.dat <- readMAF(maf.file)

# lollipop diagram with default options

plot.options =
  g3Lollipop.theme(theme.name = "nature",
                   title.text = "nature theme title",
                   y.axis.label = "y-label",
                   legend.title = "legend-title")

plot.options$chartType


g3Lollipop(mutation.dat,
           plot.options =
             g3Lollipop.theme(theme.name = "default",
                              title.text = "default theme title",
                              y.axis.label = "y-label",
                              legend.title = "legend-title"),
           gene.symbol = "TP53")

g3Lollipop(mutation.dat,
           plot.options =
             g3Lollipop.theme(theme.name = "blue",
                              title.text = "blue theme title",
                              y.axis.label = "y-label",
                              legend.title = "legend-title"),
           gene.symbol = "TP53")

g3Lollipop(mutation.dat,
           plot.options =
             g3Lollipop.theme(theme.name = "simple",
                              title.text = "simple theme title",
                              y.axis.label = "y-label",
                              legend.title = "legend-title"),
           gene.symbol = "TP53")

g3Lollipop(mutation.dat,
           plot.options =
             g3Lollipop.theme(theme.name = "cbioportal",
                              title.text = "cbioportal theme title",
                              y.axis.label = "y-label",
                              legend.title = "legend-title"),
           gene.symbol = "TP53")

g3Lollipop(mutation.dat,
           plot.options =
             g3Lollipop.theme(theme.name = "nature",
                              title.text = "nature theme title",
                              y.axis.label = "y-label",
                              legend.title = "legend-title"),
           gene.symbol = "TP53")


g3Lollipop(mutation.dat,
           plot.options =
             g3Lollipop.theme(theme.name = "ggplot2",
                              title.text = "ggplot2 theme title",
                              y.axis.label = "y-label",
                              legend.title = "legend-title"),
           gene.symbol = "TP53")


# demo chart

mutation.dat <- getMutationsFromCbioportal("msk_impact_2017", "TP53")

g3Lollipop(mutation.dat,
           plot.options =
             g3Lollipop.theme(theme.name = "nature",
                              title.text = "nature theme title",
                              y.axis.label = "y-label",
                              legend.title = "legend-title"),
           gene.symbol = "TP53")
