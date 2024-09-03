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
#' \donttest{
#' # Usage:
#' }
#' @importFrom httr2 request req_perform resp_status resp_body_string
#' @importFrom org.Hs.eg.db org.Hs.eg.db
#' @importFrom AnnotationDbi mapIds
#' @importFrom jsonlite fromJSON
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
  # cbioportal server
  base.url = "https://www.cbioportal.org/api/"

  # ========================
  # library(httr2)
  # library(AnnotationDbi)
  # library(org.Hs.eg.db)

  # study.id = "msk_impact_2017"
  # gene.symbol = "TP53"

  # ========================
  tryCatch({
    # step 1:
    # get entrez gene id
    entrez.id <- suppressMessages(mapIds(
      org.Hs.eg.db,
      keys = gene.symbol,
      column = "ENTREZID",
      keytype = "SYMBOL",
      multiVals = "first"
    ))

    if (!is.na(entrez.id)) {
      message(paste0("The Entrez Gene ID for ", gene.symbol, " is: ", entrez.id))
    } else {
      stop(paste0("[Error] No Entrez Gene ID found for ", gene.symbol))
    }

    entrez.id = as.character(entrez.id)

    # step2:
    # check if mutation information is available in the study
    response <- request(paste0(base.url, "studies/", study.id, "/molecular-profiles")) |>
      req_perform()
    status_code <- resp_status(response)

    if(status_code != 200){
      stop("Can not find Mutation data for this study: ", study.id)
    }

    res_dataset_df <- response |>
      resp_body_string() |>
      fromJSON()

    if(!"MAF" %in% res_dataset_df$datatype){
      stop("Failed to retrieve data from cBioPortal. Status_cod = ", status_code)
    }

    # check if mutation dataset exists for this study
    maf_col_idx = which(res_dataset_df$datatype == "MAF")
    maf_study_name = res_dataset_df[maf_col_idx, "molecularProfileId"]
    message("Found mutation dataset for ", study.id, ": ", maf_study_name)

    all.sample.name = paste0(study.id, "_all")

    # get mutation data
    mutation_cmd = paste0(
      base.url, "molecular-profiles/", maf_study_name, "/mutations?sampleListId=",
      all.sample.name, "&entrezGeneId=", entrez.id)

    response2 <- request(mutation_cmd) |> httr2::req_perform()
    status_code2 <- resp_status(response2)

    if(status_code2 != 200){
      stop("[Error] can not query mutation data from cBioportal API for the study: ", study.id)
    }

    # ---------------------------
    mutation.df <- response2 |>
      resp_body_string() |>
      fromJSON()

    mutation.df$geneSymbol <- gene.symbol
    required.colnames <- c("geneSymbol", "proteinChange", "sampleId", "mutationType",
                           "chr", "proteinPosStart", "proteinPosEnd",
                           "referenceAllele", "variantAllele")

    mapped.colnames <- c("Hugo_Symbol", "Protein_Change", "Sample_ID", "Mutation_Type",
                         "Chromosome", "Start_Position", "End_Position",
                         "Reference_Allele", "Variant_Allele")

    # check if any columns are missing
    if(!all(required.colnames %in% colnames(mutation.df))){
      missing.columns <- all(required.colnames %in% colnames(mutation.df))
      stop("[Error] Some columns are missing: ", paste(missing.columns, collapse =", "))
    }

    # rename headers according to cbioportal MutationMapper
    # url: http://www.cbioportal.org/mutation_mapper.jsp
    mutation.df <- mutation.df[, required.colnames]
    colnames(mutation.df) <- mapped.colnames

    # =============================
    # map from mutation type to mutation class
    mutation.df[, "Mutation_Class"] <- mapMutationTypeToMutationClass(
      mutation.df[, "Mutation_Type"],
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

    return(mutation.df)
  }, warning = function(w){
    stop("[Warning] ", w)
  }, error = function(e){
    stop("[Error] ", e)
  }, finally = {
  })
}
