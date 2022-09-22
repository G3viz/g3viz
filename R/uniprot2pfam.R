#' From UniProt ID to Pfam-A domain composition
#'
#' @description Map from UniProt ID to Pfam-A domain composition.
#' @param uniprot.id UniProt ID
#' @return a data frame with columns
#' \itemize{
#' \item \emph{uniprot} --- UniProt ID
#' \item \emph{length} --- protein length
#' \item \emph{hmm.acc} --- accession number of Pfam HMM model, e.g., PF08563
#' \item \emph{hmm.name} --- Pfam name, e.g., P53_TAD
#' \item \emph{start} --- Pfam domain start position
#' \item \emph{end} --- Pfam domain end position
#' \item \emph{type} --- Pfam type, including domain/motif/family
#' }
#'
#' @examples
#' uniprot2pfam("Q5VWM5")  # PRAMEF9; PRAMEF15
#' uniprot2pfam("P04637")
#'
#' @importFrom utils data
#'
#' @export
uniprot2pfam <- function(uniprot.id){
  # Q5VWM5: PRAMEF9; PRAMEF15
  # O60224: SSX4; SSX4B
  if(missing(uniprot.id)){
    stop("Missing uniprot.id: need to specify a UniPort ID (HUMAN)")
  }

  #hgnc2pfam.file <- system.file('data', 'hgnc2pfam.RDS', package = 'g3viz')
  #hgnc2pfam.file = "data/hgnc2pfam.RDS"
  #hgnc2pfam.df <- readRDS(file = hgnc2pfam.file)

  #data("hgnc2pfam.df", package = "g3viz")

  uniprot.df <- unique(
    hgnc2pfam.df[hgnc2pfam.df$uniprot == uniprot.id,
                 c("uniprot", "length", "hmm.acc", "hmm.name", "start", "end", "type")]
  )

#  uniprot.df <- unique(
#    subset(hgnc2pfam.df,
#           uniprot == uniprot.id,
#           select = c("uniprot", "length", "hmm.acc", "hmm.name", "start", "end", "type")))

  # sort by domain position
  uniprot.df <- uniprot.df[with(uniprot.df, order(start, end)),]

  uniprot.df
}
