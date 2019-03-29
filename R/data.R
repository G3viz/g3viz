#' Default mapping table between mutation type (aka, variant classification) to mutation class
#'
#' A dataset containing the mapping table between genomic mutation type (aka, variant classification) to mutation class.
#' See \code{\link{mapMutationTypeToMutationClass}} for details.
#'
#' @format A data frame with three columns:
#' \describe{
#'   \item{Mutation_Type}{Mutation type, aka, variant classification}
#'   \item{Mutation_Class}{mutation class}
#'   \item{Short_Name}{short name of mutation type}
#' }
#' @examples
#' mutation.table.df
"mutation.table.df"

#' Mapping table between gene.symbol, uniprot.id, and pfam
#'
#' A dataset containing the mapping table between Hugo symbol, UniProt ID, and
#' Pfam ACC.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{symbol}{Gene symbol}
#'   \item{uniprot}{UniProt ID}
#'   \item{length}{protein length}
#'   \item{start}{starting position of Pfam domain}
#'   \item{end}{ending position of Pfam domain}
#'   \item{hmm.acc}{Pfam accession number}
#'   \item{hmm.name}{Pfam name}
#'   \item{type}{Pfam type, i.e., domain/family/motif/repeat/disordered/coiled-coil}
#' }
#' @examples
#' hgnc2pfam.df
#' @source Pfam (v31.0) and UniProt
"hgnc2pfam.df"

