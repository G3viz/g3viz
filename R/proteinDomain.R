#' Map from Hugo symbol to Pfam domains
#'
#' @description Mapping from Hugo symbol to Pfam-A domain composition.
#' If the given Hugo symbol has multiple UniProt ID mappings,
#' and \code{guess == TRUE},
#' the longest UniProt protein is selected. Return is either a list of a JSON.
#' @examples
#' # general usage
#' hgnc2pfam("TP53")
#' hgnc2pfam("TP53", output.format = "json")
#' hgnc2pfam("TP53", output.format = "list")
#' hgnc2pfam("TP53", output.format = "json", uniprot.id = "P04637") # OK
#'
#' # for gene mapping to multiple UniProt enties
#' hgnc2pfam("GNAS", guess = TRUE)
#' hgnc2pfam("GNAS", guess = FALSE)
#' hgnc2pfam("GNAS", output.format = "list")
#' hgnc2pfam("GNAS", output.format = "list", uniprot.id = "P84996")
#' \dontrun{
#' hgnc2pfam("GNAS", output.format = "list", uniprot.id = "P84997") # not exists, returns FALSE
#' }
#'
#' hgnc2pfam("PRAMEF9", output.format = "list") # no Pfam mappings
#'
#' @param hgnc.symbol primary Hugo symbol
#' @param output.format output format: JSON or list
#' @param uniprot.id UniProt ID, in case that gene symbol maps to multiple UniProt entries.
#' @param guess if the given Hugo symbol links to multiple UniProt IDs,
#' choose the longest one (\code{guess == TRUE});
#' otherwise \code{NA} (\code{guess == FALSE}).  Default \code{TRUE}.
#' @return A list or a JSON with attributes:
#'     \emph{symbol}, \emph{uniprot}, \emph{length}, and a list of \emph{Pfam} entries, including
#'     \emph{hmm.acc}, \emph{hmm.name}, \emph{start}, \emph{end}, and \emph{type}.
#'
#' @importFrom utils capture.output
#' @importFrom jsonlite toJSON
#' @export
proteinDomain <- function(protein.length,
                          domain.df,
                          domain.name.col = "Name",
                          domain.start.col = "Start",
                          domain.end.col = "End"){

  if(is.na(protein.length)){
    stop("Please provide the length of protein")
  }

  if(!domain.name.col %in% colnames(domain.df)){
    stop("domain.name.col ", domain.name.col, " not exists")
  }
  if(!domain.start.col %in% colnames(domain.df)){
    stop("domain.start.col ", domain.start.col, " not exists")
  }
  if(!domain.end.col %in% colnames(domain.df)){
    stop("domain.end.col ", domain.end.col, " not exists")
  }

  #--
  protein.length <- 393
  domain.fn = "data-raw/TP53_P04637_interpro.csv"
  domain.df = read.csv(domain.fn)
  domain.name.col = "Name"
  domain.start.col = "Start"
  domain.end.col = "End"
  #--

  domain.list <- list(
    length = protein.length,
    details = domain.list
  )

  # domain data format
  domain.default.format <- list(
    length = "length",
    details = list(
      start = "start",
      end = "end",
      name = "name"
    )
  )

}
