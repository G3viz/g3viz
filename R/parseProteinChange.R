#' Extract \emph{amino_acid_position} from \emph{Protein_Change}
#
#' @description Parse \emph{amino_acid_position} according to HGVSp_short format. \cr
#'  For example, \emph{p.Q16Rfs*28}, amino-acid position is 16.
#'   See \url{http://varnomen.hgvs.org/recommendations/protein/} or \url{https://www.hgvs.org/mutnomen/recs-prot.html}. \cr
#'
#' @param protein.change.vec a vector of strings with protein change information, usually in HGVSp_short format.
#' @param mutation.class.vec a vector of strings with mutation class (or so-called variant classification) information.
#'
#' @return a vector of parsed amino-acid position
#' @importFrom stringr str_extract_all
#' @export
parseProteinChange <- function(protein.change.vec, mutation.class.vec) {
  if(length(protein.change.vec) != length(mutation.class.vec)){
    stop("Length of Protein_Change is not equal to the length of Mutation_Class")
  }

  protein.change.vec <- as.character(protein.change.vec)
  mutation.class.vec <- as.character(mutation.class.vec)

  # parse amino acid position
  aa.pos.vec <- as.numeric(rep(NA, length(protein.change.vec)))

  for(idx in 1:length(protein.change.vec)){
    d.pc <- protein.change.vec[idx]
    d.mc <- mutation.class.vec[idx]

    if(!(is.na(d.mc) || d.mc == "Other" || d.mc == "")){
      # extract the first numeric value
      aa.pos.vec[idx] <- as.numeric(str_extract_all(d.pc, "[0-9]+")[[1]])[1]
    }
    # cat(d.pc, " ==> ", aa.pos.vec[idx], "\n")
  }

  aa.pos.vec
}
