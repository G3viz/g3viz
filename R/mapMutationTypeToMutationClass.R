#' Map from mutation type to mutation class
#'
#' @description Map from mutation type to mutation class. Refer to \code{\link{getDefaultMutationMappingTable}}
#' for more details.
#'
#' @param mutation.type.vec a vector of mutation type information
#' @param mutation.tytpe.to.class.df Data frame mapping from mutation tytpe (header \emph{Mutation_Type})
#' to mutation class (header \emph{Mutation_Class}).
#' Default is \code{\link{getDefaultMutationMappingTable}}.
#' @return a vector of mapped mutation class information
#' @export
mapMutationTypeToMutationClass <- function(mutation.type.vec, mutation.type.to.class.df = NULL){
  # ============================
  # read variant_type to variant_class mapping
  if(is.null(mutation.type.to.class.df)){
    Map.df <- getDefaultMutationMappingTable()
  } else {
    Map.df = mutation.type.to.class.df
  }
  mutation.type.vec <- as.character(mutation.type.vec)

  # annotate "Mutation_Class": Truncating / Missense / Inframe / Other
  unkwnon.vc <- unique(mutation.type.vec[!mutation.type.vec %in% Map.df[, "Mutation_Type"]])
  if(length(unkwnon.vc) > 0){
    warning("Unknown variant classification: ", paste(unkwnon.vc, collapse =", "))
  }

  # Parse "Mutation_Class" information.  Default "Other"
  mutation.class.vec <- rep(NA, length(mutation.type.vec))
  mutation.class.vec <- Map.df[match(mutation.type.vec, Map.df$Mutation_Type), "Mutation_Class"]
  mutation.class.vec
}


