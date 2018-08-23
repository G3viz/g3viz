#' Map from mutation type (aka, variant classification) to mutation class
#'
#' @description Map from mutation type (aka, variant classification) to mutation class.
#' Default mappings are as follows,
#' \itemize{
#'   \item Missense
#'   \itemize{
#'     \item \emph{Missense_Mutation} --- the point mutation alters the protein structure by one amino acid.
#'           See \url{https://en.wikipedia.org/wiki/Missense_mutation}.
#'   }
#'   \item Inframe
#'   \itemize{
#'     \item \emph{In_Frame_Del} --- deletion that keeps the sequence in frame
#'     \item \emph{In_Frame_Ins} --- insertion that keeps the sequence in frame
#'     \item \emph{Silent} --- variant is in coding region of the chosen transcript, but protein structure is identical (i.e., a synonymous mutation)
#'     \item \emph{Targeted_Region} --- targeted region
#'   }
#'   \item Truncating
#'     \itemize{
#'       \item \emph{Frame_Shift_Ins} --- insertion that moves the coding sequence out of frame.
#'             See \url{https://en.wikipedia.org/wiki/Frameshift_mutation}.
#'       \item \emph{Frame_Shift_Del} --- deletion that moves the coding sequence out of frame.
#'             See \url{https://en.wikipedia.org/wiki/Frameshift_mutation}.
#'       \item \emph{Nonsense_Mutation} --- a premature stop codon is created by the variant.
#'             See \url{https://en.wikipedia.org/wiki/Nonsense_mutation}.
#'       \item \emph{Nonstop_Mutation} --- variant removes stop codon.
#'       \item \emph{Splice_Site} --- the variant is within two bases of a splice site.
#'       \item \emph{Splice_Region} --- the variant is within splice region.
#'  }
#'  \item Other
#'  \itemize{
#'     \item \emph{5'UTR} --- variant is on the 5'UTR for the chosen transcript
#'     \item \emph{3'UTR} --- variant is on the 3'UTR for the chosen transcript
#'     \item \emph{5'Flank} --- the variant is upstream of the chosen transcript (within 3kb)
#'     \item \emph{3'Flank} --- the variant is downstream of the chosen transcript (within 3kb)
#'     \item \emph{Fusion} --- gene fusion
#'     \item \emph{IGR} --- intergenic region. Does not overlap any transcript.
#'     \item \emph{Intron} --- variant lies between exons within the bounds of the chosen transcript.
#'     \item \emph{Translation_Start_Site} --- variant in translation start site.
#'     \item \emph{De_novo_Start_InFrame} --- New start codon is created by the given variant using the chosen transcript.
#'           However, it is in frame relative to the coded protein.
#'     \item \emph{De_novo_Start_OutOfFrame} --- New start codon is created by the given variant using the chosen transcript.
#'           However, it is out of frame relative to the coded protein.
#'     \item \emph{Start_Codon_SNP} --- point mutation that overlaps the start codon.
#'     \item \emph{Start_Codon_Ins} --- insertion that overlaps the start codon.
#'     \item \emph{Start_Codon_Del} --- selection that overlaps the start codon.
#'     \item \emph{RNA} --- variant lies on one of the RNA transcripts.
#'     \item \emph{lincRNA} --- variant lies on one of the lincRNAs.
#'     \item \emph{Unknown} --- Unknown
#'   }
#' }
#'
#' @param mutation.type.vec a vector of mutation type information
#' @param mutation.type.to.class.df A mapping table from mutation type (header \emph{Mutation_Type})
#'   to mutation class (header \emph{Mutation_Class}).
#'   Default \code{NA}, which indicates to use default mappings.
#'
#' @return a vector of mapped mutation class information
#'
#' @importFrom utils data
#' @export
mapMutationTypeToMutationClass <- function(mutation.type.vec,
                                           mutation.type.to.class.df = NA){
  # ============================
  # read variant_type to variant_class mapping
  if(is.na(mutation.type.to.class.df)){
    data(mutation.table.df)
    Map.df <- mutation.table.df
  } else {
    Map.df <- mutation.type.to.class.df
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


