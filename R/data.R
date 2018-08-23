#' Default mapping table between mutation type (aka, variant classification) to mutation class
#'
#' A dataset containing the mapping table between genomic mutation type (aka, variant classification) to mutation class
#'
#' @format A data frame with three columns, \emph{Mutation_Type}, \emph{Mutation_Class}, and \emph{Short_Name}.
"mutation.table.df"

#' Mapping table between gene.symbol, uniprot.id, and pfam
#'
#' A dataset containing the mapping table between Hugo symbol, UniProt ID, and Pfam ACC.
#'
#' @format A data frame with columns of symbol, uniprot, length, start, end, hmm.acc, hmm.name, type
#' @source Pfam (v31.0) and UniProt
"hgnc2pfam.df"






