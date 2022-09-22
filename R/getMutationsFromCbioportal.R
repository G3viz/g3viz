#' Query cancer genomic mutation data from cBioPortal
#'
#' @description Retrieve and parse mutation data from cBioPortal by the given
#'   cBioPortal cancer study ID and the gene symbol.
#' @param study.id cbioprotal study ID
#' @param gene.symbol HGNC gene symbol.
#' @param output.file if specified, output to a file in \emph{CSV} format.
#'   Default is \code{NA}.
#' @param mutation.type.to.class.df mapping table from mutation type to class.
#'   See \code{\link{mapMutationTypeToMutationClass}} for details. Default
#'   \code{NA}, which indicates to use default mappings.
#' @examples
#' \dontrun{
#' # Usage:
#' # cBioPortalData has officially replaced the defunct cgdsr.
#' # Search online for cgdsrMigration.html if interested.
#' library(cBioPortalData)
#' cbio <- cBioPortal()
#'
#' # list all studies of cBioPortal
#' all.studies <- getStudies(cbio, buildReport = FALSE)
#'
#' # First, select a cancer study that contains mutation data set ("caner_study_id")
#' # then, query genomic mutation data using a HGNC gene symbol,
#' # for example
#' mutation.dat <- getMutationsFromCbioportal("msk_impact_2017", "TP53")
#' mutation.dat <- getMutationsFromCbioportal("all_stjude_2016", "TP53")
#' }
#' @importFrom cBioPortalData cBioPortal molecularProfiles sampleLists getDataByGenes
#'             samplesInSampleLists
#' @importFrom utils write.table
#'
#' @return a data frame with columns
#'   \describe{
#'       \item{Hugo_Symbol}{Hugo gene symbol}
#'       \item{Protein_Change}{Protein change information (cBioportal uses \emph{HGVSp} format)}
#'       \item{Sample_ID}{Sample ID}
#'       \item{Mutation_Type}{mutation type, aka, variant classification.}
#'       \item{Chromosome}{chromosome}
#'       \item{Start_Position}{start position}
#'       \item{End_Position}{end position}
#'       \item{Reference_Allele}{reference allele}
#'       \item{Variant_Allele}{variant allele}
#'       \item{Mutation_Class}{mutation class (e.g., Truncating/Missense/Inframe/Other)}
#'       \item{AA_Position}{amino-acid position of the variant; if the variant is not in
#'       protein-coding region, \code{NA}}
#'       }
#' @export
getMutationsFromCbioportal <- function(study.id,
                                       gene.symbol,
                                       output.file = NA,
                                       mutation.type.to.class.df = NA){

  # ========================
  # server
  cbio <- cBioPortal()

  # ========================
  # get study information
  genetic.profiles <- molecularProfiles(cbio,studyId = study.id)
  message("Found study ", study.id)

  # ========================
  # check if mutation information is available in the study
  profile.col <- "molecularProfileId"
  mutation.idx <- grep(pattern = 'mutations$', x = genetic.profiles$molecularProfileId, fixed = FALSE)
  if(is.integer(mutation.idx) && length(mutation.idx) == 0L){
    stop("Can not find mutation information in ", study.id, " study")
  }
  mutation.profile <- genetic.profiles$molecularProfileId[mutation.idx]
  message("Found mutation data set ", mutation.profile)

  # ========================

  case.list.details <- sampleLists(cbio, study.id)

  mutation.case.list.id <- case.list.details$sampleListId

  mutation.case.list.all <- mutation.case.list.id[grep(pattern = '_sequenced$',x = mutation.case.list.id)]
  num.case <- length(samplesInSampleLists(cbio,mutation.case.list.id)[[mutation.case.list.all]])
  message(num.case, " cases in this study")

  ### Download mutation data on certain gene from study
  df <- getDataByGenes(
        cbio,
        studyId = study.id,
        genes = gene.symbol,
        by = "hugoGeneSymbol",
        molecularProfileIds = mutation.profile
      )[[1]]

  extended.mutation.df <- cbind(rep(gene.symbol,nrow(df)),df)
  colnames(extended.mutation.df) <- c("gene_symbol",colnames(df))
  # =========================
  # parse mutation data columns
  required.colnames <- c("gene_symbol", "proteinChange", "sampleId", "mutationType",
                         "chr", "startPosition", "endPosition",
                         "referenceAllele", "variantAllele")

  mapped.colnames <- c("Hugo_Symbol", "Protein_Change", "Sample_ID", "Mutation_Type",
                       "Chromosome", "Start_Position", "End_Position",
                       "Reference_Allele", "Variant_Allele")

  # check if any columns are missing
  missing.columns <- required.colnames[!required.colnames %in% colnames(extended.mutation.df)]
  if(length(missing.columns) > 0){
    stop("Some columns are missing: ", paste(missing.columns, collapse =", "))
  }

  # rename headers according to cbioportal MutationMapper
  # url: http://www.cbioportal.org/mutation_mapper.jsp
  mutation.df <- extended.mutation.df[, required.colnames]
  colnames(mutation.df) <- mapped.colnames


  # =============================
  # map from mutation type to mutation class
  mutation.df[, "Mutation_Class"] <- mapMutationTypeToMutationClass(mutation.df[, "Mutation_Type"],
                                                                      mutation.type.to.class.df)

  # =============================
  # parse amino acid position
  mutation.df[, "AA_Position"] <- parseProteinChange(mutation.df[, "Protein_Change"],
                                                  mutation.df[, "Mutation_Class"])

  mutation.df <- mutation.df[order(mutation.df[, "AA_Position"],
                                   mutation.df[, "Protein_Change"], decreasing = FALSE), ]

  if(!is.na(output.file)){
    message("Write mutation data to ", output.file)
    write.table(mutation.df, file = output.file, sep = "\t", quote = FALSE, col.names = TRUE, row.names = FALSE)
  }

  mutation.df
}
