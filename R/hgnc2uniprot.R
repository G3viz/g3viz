#' Mapping from Hugo symbol to UniProt IDs
#'
#' @description Mapping from Hugo Symbol to UniProt ID using internal mapping table.
#' Return a data frame with columns \emph{symbol} (Hugo symbol), \emph{uniprot} (UniProt ID),
#' and \emph{length} (protein length).
#'
#' @param hgnc.symbol primary HUGO symbol
#'
#' @return a data frame with columns \emph{symbol} (Hugo symbol), \emph{uniprot} (UniProt ID),
#' and \emph{length} (protein length).
#'
#' @examples
#' # maps to single UniProt entry
#' hgnc2uniprot("TP53")
#'
#' # maps to multiple UniProt entries
#' hgnc2uniprot("GNAS")
#' hgnc2uniprot("AKAP7")
#'
#' @importFrom utils data
#'
#' @export
hgnc2uniprot <- function(hgnc.symbol){
  # HLA-B: 174
  # HLA-A: 35
  # HLA-C: 14
  # GNAS: 4
  # AKAP7: 2
  if(missing(hgnc.symbol)){
    stop("Missing hgnc.symbol: need to specify a HUGO symbol.")
  }

  #hgnc2pfam.file <- system.file('data', 'hgnc2pfam.RDS', package = 'g3viz')
  #hgnc2pfam.file = "data/hgnc2pfam.RDS"
  #hgnc2pfam.df <- readRDS(file = hgnc2pfam.file)

  #data("hgnc2pfam.df", package = "g3viz")

  uniprot.df <- unique(
    hgnc2pfam.df[hgnc2pfam.df$symbol == hgnc.symbol, c("symbol", "uniprot", "length")]
  )
#  uniprot.df <- unique(subset(hgnc2pfam.df, symbol == hgnc.symbol, select = c("symbol", "uniprot", "length")))

  uniprot.df
}
