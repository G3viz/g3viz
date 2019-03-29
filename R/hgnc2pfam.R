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
hgnc2pfam <- function(hgnc.symbol,
                      guess = TRUE,
                      uniprot.id = NA,
                      output.format = "json"){
  # if hgnc.symbol is missing
  if(missing(hgnc.symbol)){
    stop("Missing hgnc.symbol: need to specify a HUGO symbol.")
  }

  hgnc.symbol <- toupper(hgnc.symbol)

  # check output.format
  output.format <- tolower(output.format)
  if(!output.format %in% c("json", "list")){
    stop("Output.format should be either json or list.")
  }

  # get UniProt ids
  uniprot.df <- hgnc2uniprot(hgnc.symbol)

  if(nrow(uniprot.df) > 1){
    msg <- paste(capture.output(print.data.frame(uniprot.df, row.names = FALSE)), collapse = "\n")
    message(hgnc.symbol, " maps to multiple UniProt entries: ", "\n", msg)
  }

  if(!is.na(uniprot.id)){
    if(uniprot.id %in% uniprot.df$uniprot){
      message("Choose ", uniprot.id)
      uniprot.df <- uniprot.df[uniprot.df$uniprot == uniprot.id, ]
      #uniprot.df <- subset(uniprot.df, uniprot == uniprot.id)
    } else {
      stop(uniprot.id, " is not mapped to ", hgnc.symbol)
    }
  }

  if(nrow(uniprot.df) == 1){
    pfam.df <- uniprot2pfam(uniprot.df[1, "uniprot"])
  } else if(nrow(uniprot.df) ==  0){
    stop(hgnc.symbol, " has no uniprot mappings (wrong name or non-protein-coding gene).")
  } else {
    if(guess == TRUE){
      max.idx <- which(uniprot.df$length == max(uniprot.df$length))[1]
      uniprot.df <- uniprot.df[max.idx, ]
      pfam.df <- uniprot2pfam(uniprot.df[1, "uniprot"])

      warning("Pick: ", uniprot.df[1, "uniprot"])
    } else {
      pfam.df <- NA
    }
  }

  if(is.data.frame(pfam.df)){
    pfam.df <- pfam.df[, c("hmm.acc", "hmm.name", "start", "end", "type")]
    pfam.df <- pfam.df[!is.na(pfam.df[,"hmm.acc"]), ]
  }
  # remove empty entries

  output.list <- as.list(uniprot.df)
  output.list$pfam <- pfam.df

  if(output.format == "json"){
    toJSON(output.list, pretty = FALSE, auto_unbox = TRUE)
  } else {
    output.list
  }
}
