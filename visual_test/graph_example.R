library(g3viz)

# get mutation data of msk_impact_2017 study from cBioPortal
maf.file <- system.file("extdata", "TCGA.BRCA.varscan.somatic.maf.gz", package = "g3viz")
mutation.dat <- readMAF(maf.file)

# lollipop diagram with default options

# ===
plot.options =
  g3Lollipop.theme(theme.name = "nature",
                   title.text = "nature theme title",
                   y.axis.label = "y-label",
                   legend.title = "legend-title")

g3Lollipop(mutation.dat,
           plot.options = plot.options,
           gene.symbol = "TP53")

# ===

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

# query data from cBioPortal
mutation.dat <- getMutationsFromCbioportal("msk_impact_2017", "TP53")

# draw g3lollipop with built-in theme
g3Lollipop(mutation.dat,
           plot.options = g3Lollipop.theme(
                              theme.name = "nature2",
                              title.text = "TP53 gene mutation (MSK-IMPACT study)",
                              y.axis.label = "# of TP53 mutations",
                              legend.title = "Mutation Class"),
           gene.symbol = "TP53",
           btn.style = "blue")
