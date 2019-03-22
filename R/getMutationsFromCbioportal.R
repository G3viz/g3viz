#' Query cancer genomic mutation data from cBioPortal
#'
#' @description Retrieve and parse mutation data from cBioPortal
#' by the given cBioPortal cancer study ID and the gene symbol.
#' @param study.id cbioprotal study ID
#' @param gene.symbol HGNC gene symbol.
#' @param output.file if specified, output to a file in \emph{CSV} format. Default is \code{NA}.
#' @param mutation.type.to.class.df mapping table from mutation type to class.
#' @param cgds.url the URL for the public CGDS server, refer to
#' @param test.cbioportal test CGDS connection
#' See \code{\link{mapMutationTypeToMutationClass}} for details.
#' Default \code{NA}, which indicates to use default mappings.
#' @examples
#' \dontrun{
#' # Note: internet access required.  May need more than 10 seconds.
#' # list all studies of cBioPortal
#' library(cgdsr)
#' cgds <- CGDS("http://www.cbioportal.org/")
#' # test if connection is OK (warning: sometimes it may fail)
#' test(cgds)
#' all.studies <- getCancerStudies(cgds)
#'
#' # pick a "caner_study_id" (contain a mutation data set)
#' # pick a primary HGNC gene symbol to query
#' mutation.dat <- getMutationsFromCbioportal("msk_impact_2017", "TP53")
#' mutation.dat <- getMutationsFromCbioportal("all_stjude_2016", "TP53")
#' }
#' @importFrom cgdsr CGDS getGeneticProfiles getCaseLists getMutationData
#' @importFrom utils write.table
#'
#' @return a data frame with columns
#' \describe{
#' \item{Hugo_Symbol}{Hugo gene symbol}
#' \item{Protein_Change}{Protein change information (cBioprotal uses \emph{HGVSp} format)}
#' \item{Sample_ID}{Sample ID}
#' \item{Mutation_Type}{mutation type, aka, variant classification.}
#' \item{Chromosome}{chromosome}
#' \item{Start_Position}{start position}
#' \item{End_Position}{end position}
#' \item{Reference_Allele}{reference allele}
#' \item{Variant_Allele}{variant allele}
#' \item{Mutation_Class}{mutation class (e.g., Truncating/Missense/Inframe/Other)}
#' \item{AA_Position}{amino-acid position of the variant; if the variant is not in protein-coding region, \code{NA}}
#' }
#' @export
getMutationsFromCbioportal <- function(study.id,
                                       gene.symbol,
                                       output.file = NA,
                                       mutation.type.to.class.df = NA,
                                       cbioportal.url = "http://www.cbioportal.org/",
                                       test.cbioportal = FALSE){
  # =============================
  # define mutation columns
  aa.pos.col <- "AA_Position"
  mutation.class.col <- "Mutation_Class"

  # ========================
  # cgds server
  cgds <- CGDS("http://www.cbioportal.org/public-portal/")

  # ========================
  # get study information
  genetic.profiles <- getGeneticProfiles(cgds, study.id)
  message("Found study ", study.id)

  # ========================
  # check if mutation informaiton is available in the study
  profile.col <- "genetic_profile_id"
  mutation.idx <- grep(pattern = 'mutations$', x = genetic.profiles[, profile.col], fixed = FALSE)
  if(is.integer(mutation.idx) && length(mutation.idx) == 0L){
    stop("Can not find mutation information in ", study.id, " study")
  }
  mutation.profile <- genetic.profiles[mutation.idx, profile.col]
  message("Found mutation data set ", mutation.profile)

  # ========================
  # get case list
  case.list.details <- getCaseLists(cgds, study.id)[mutation.idx, ]
  mutation.case.list.id <- case.list.details$case_list_id
  num.case <- length(strsplit(case.list.details$case_ids, " ")[[1]])
  message(num.case, " cases in this study")

  extended.mutation.df <- getMutationData(cgds, mutation.case.list.id, mutation.profile, gene.symbol)
  # =========================
  # parse mutation data columns
  required.colnames <- c("gene_symbol", "amino_acid_change", "case_id", "mutation_type",
                         "chr", "start_position", "end_position",
                         "reference_allele", "variant_allele")

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
  mutation.df[, mutation.class.col] <- mapMutationTypeToMutationClass(mutation.df[, "Mutation_Type"],
                                                                      mutation.type.to.class.df)

  # =============================
  # parse amino acid position
  mutation.df[, aa.pos.col] <- parseProteinChange(mutation.df[, "Protein_Change"],
                                                  mutation.df[, mutation.class.col])

  mutation.df <- mutation.df[order(mutation.df[, aa.pos.col],
                                   mutation.df[, "Protein_Change"], decreasing = FALSE), ]

  if(!is.na(output.file)){
    message("Write mutation data to ", output.file)
    write.table(mutation.df, file = output.file, sep = "\t", quote = FALSE, col.names = TRUE, row.names = FALSE)
  }

  mutation.df
}
