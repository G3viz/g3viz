#' Map from mutation type (aka, variant classification) to mutation class
#'
#' @description Map from mutation type (aka, variant classification) to mutation class.
#' Default mappings are as follows,
#' \itemize{
#'   \item Missense
#'   \itemize{
#'     \item \emph{Missense_Mutation} --- a point mutation in which a single nucleotide change results in a codon that codes for a different amino acid
#'           See \url{https://en.wikipedia.org/wiki/Missense_mutation}.
#'   }
#'   \item Inframe
#'   \itemize{
#'     \item \emph{In_Frame_Del} --- a deletion that keeps the sequence in frame
#'     \item \emph{In_Frame_Ins} --- an insertion that keeps the sequence in frame
#'     \item \emph{Silent} --- variant is in coding region of the chosen transcript, but protein structure is identical (i.e., a synonymous mutation)
#'     \item \emph{Targeted_Region} --- targeted region
#'   }
#'   \item Truncating
#'     \itemize{
#'       \item \emph{Frame_Shift} --- a variant caused by indels of a number of nucleotides in a DNA sequence that is not divisible by three.
#'             See \url{https://en.wikipedia.org/wiki/Frameshift_mutation}.
#'       \item \emph{Frame_Shift_Ins} --- a variant caused by insertion that moves the coding sequence out of frame.
#'             See \url{https://en.wikipedia.org/wiki/Frameshift_mutation}.
#'       \item \emph{Frame_Shift_Del} --- a variant caused by deletion that moves the coding sequence out of frame.
#'             See \url{https://en.wikipedia.org/wiki/Frameshift_mutation}.
#'       \item \emph{Nonsense_Mutation} --- a premature stop codon that is created by the variant.
#'             See \url{https://en.wikipedia.org/wiki/Nonsense_mutation}.
#'       \item \emph{Nonstop_Mutation} --- a variant that removes stop codon.
#'       \item \emph{Splice_Site} --- a variant that is within two bases of a splice site.
#'       \item \emph{Splice_Region} --- a variant that is within splice region.
#'  }
#'  \item Other
#'  \itemize{
#'     \item \emph{5'UTR} --- a variant that is on the 5'UTR for the chosen transcript.
#'     \item \emph{3'UTR} --- a variant that is on the 3'UTR for the chosen transcript.
#'     \item \emph{5'Flank} --- a variant that is upstream of the chosen transcript (generally within 3kb).
#'     \item \emph{3'Flank} --- a variant that is downstream of the chosen transcript (generally within 3kb).
#'     \item \emph{Fusion} --- a gene fusion.
#'     \item \emph{IGR} --- an intergenic region. Does not overlap any transcript.
#'     \item \emph{Intron} --- a variant that lies between exons within the bounds of the chosen transcript.
#'     \item \emph{Translation_Start_Site} --- a variant that is in translation start site.
#'     \item \emph{De_novo_Start_InFrame} --- a novel start codon that is created by the given variant using the chosen transcript.
#'           However, it is in frame relative to the coded protein.
#'     \item \emph{De_novo_Start_OutOfFrame} --- a novel start codon that is created by the given variant using the chosen transcript.
#'           However, it is out of frame relative to the coded protein.
#'     \item \emph{Start_Codon_SNP} --- a point mutation that overlaps the start codon.
#'     \item \emph{Start_Codon_Ins} --- an insertion that overlaps the start codon.
#'     \item \emph{Start_Codon_Del} --- a deletion that overlaps the start codon.
#'     \item \emph{RNA} --- a variant that lies on one of the RNA transcripts.
#'     \item \emph{lincRNA} --- a variant that lies on one of the lincRNAs.
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
    #mutation.table.df <- NULL
    #data("mutation.table.df", package = "g3viz")
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
