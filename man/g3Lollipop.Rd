% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/g3Lollipop.R
\name{g3Lollipop}
\alias{g3Lollipop}
\title{Render g3lollipop diagram for the given mutation data}
\usage{
g3Lollipop(
  mutation.dat,
  gene.symbol,
  uniprot.id = NA,
  gene.symbol.col = "Hugo_Symbol",
  aa.pos.col = "AA_Position",
  protein.change.col = c("Protein_Change", "HGVSp_Short"),
  factor.col = "Mutation_Class",
  plot.options = g3Lollipop.options(),
  save.png.btn = TRUE,
  save.svg.btn = TRUE,
  btn.style = NA,
  output.filename = "output"
)
}
\arguments{
\item{mutation.dat}{Input genomic mutation data frame}

\item{gene.symbol}{HGNC primary gene symbol}

\item{uniprot.id}{UniProt ID, in case that the specified gene symbol links to
multiple UniProt entries (isoforms). For example, \emph{AKAP7} gene has two
isoforms in \href{https://www.uniprot.org/}{UniProt},
\href{https://www.uniprot.org/uniprot/O43687}{O43687} and
\href{https://www.uniprot.org/uniprot/Q9P0M2}{Q9P0M2}.}

\item{gene.symbol.col}{Column name of Hugo gene symbols (e.g., TP53). Default
\emph{Hugo_Symbol}.}

\item{aa.pos.col}{Column name of the parsed amino-acid change position.
Default \emph{AA_Position}.}

\item{protein.change.col}{Column name of protein change information (e.g.,
p.K960R, G658S, L14Sfs*15). Default is a list of \emph{Protein_Change},
\emph{HGVSp_Short}.}

\item{factor.col}{column of classes in the plot legend. IF \code{NA}, use
parsed \emph{Mutation_Class} column, otherwise, use specified.  Default
\code{NA}.}

\item{plot.options}{g3lollipop diagram options in list format. Check
\code{\link{g3Lollipop.options}}}

\item{save.png.btn}{If add \emph{save-as-png} button to the diagram. Default
\code{TRUE}.}

\item{save.svg.btn}{If add \emph{save-as-svg} button to the diagram. Default
\code{TRUE}.}

\item{btn.style}{button style, including browser default button style, and
two built-in styles, \emph{blue} or \emph{gray}. Default \code{NA},
indicating browser default.}

\item{output.filename}{Specify output file name.}
}
\value{
lollipop diagram for the given mutation data. The chart is interactive
  within either Shiny applications or Rmd documents under the bindings.
}
\description{
Render g3lollipop diagram for the given mutation data
}
\examples{

# system mutation data
maf.file <- system.file("extdata", "TCGA.BRCA.varscan.somatic.maf.gz", package = "g3viz")
# read in MAF file
mutation.dat <- readMAF(maf.file)

# use built-in chart theme
chart.options <- g3Lollipop.theme(theme.name = "default",
                                  title.text = "PIK3CA gene (default theme)")
# generate chart
g3Lollipop(mutation.dat,
           gene.symbol = "PIK3CA",
           plot.options = chart.options,
           btn.style = "blue",
           output.filename = "default_theme")

}
