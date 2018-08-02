#' Read MAF file
#'
#' @description Read MAF file.
#' For MAF format specification, check \url{https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/}.
#'
#' @param maf.file MAF file name.  Gunzipped input file allowed, with ".gz" file extension.
#' @param gene.symbol.col Column name of Hugo gene symbols (e.g., TP53). Default \emph{Hugo_Symbol}.
#' @param variant.class.col Column name of variant class information
#' (e.g., \emph{Missense_Mutation}, \emph{Nonsense_Mutation}). Default is a list of \emph{Variant_Classification} and \emph{Mutation_Class}.
#' @param protein.change.col Column name of protein change information (e.g., p.K960R, G658S, L14Sfs*15).
#' Default \emph{Protein_Change}.
#' @param mutation.class.col Column name of the parsed mutation class. Default \emph{Mutation_Class}.
#' @param aachange.pos.col Column name of the parsed amino-acid change position. Default \emph{AA_Position}.
#' @param mutation.type.to.class.df mapping table from mutation type to class.
#' \code{\link{getDefaultMutationMappingTable}} for details.
#' Default \code{NULL}, indicating to use \code{\link{getDefaultMutationMappingTable}}.
#' @return A data frame
#' @export
readMAF <- function(maf.file,
                    gene.symbol.col = "Hugo_Symbol",
                    variant.class.col = c("Variant_Classification", "Mutation_Class"),
                    protein.change.col = "Protein_Change",
                    mutation.class.col = "Mutation_Class",
                    aa.pos.col = "AA_Position",
                    mutation.type.to.class.df = NULL) {
  if(missing(maf.file)){
    stop("maf.file is missing")
  }

  # ===============================
  # TODO:
  # - check "Mutation_Status" as "Somatic"
  # ===============================
  # read data in
  if(grepl(pattern = 'gz$', maf.file)){
    suppressWarnings(
      maf.df <- read.table(gzfile(description = maf.file), header = TRUE, sep = "\t", quote = "")
    )
  } else {
    maf.df <- read.table(header = TRUE, sep = "\t", quote = "")
  }

  # =============================
  # Change column names to camel format
  #maf.df <- formatCamelCase(maf.df)

  # =============================
  # check if all required columns exist
  variant.class.col <- guessMAFColumnName(maf.df, variant.class.col)
  if(is.na(variant.class.col)){
    stop("Can not find variant_class column in mutation data.")
  }

  maf.required.col <- c(gene.symbol.col, protein.change.col)
  missing.columns <- maf.required.col[!maf.required.col %in% colnames(maf.df)]
  if(length(missing.columns) > 0){
    message(maf.file, " contains columns: ", paste(colnames(maf.df), collapse = ", "))
    stop("Some columns are missing in MAF file: ", paste(missing.columns, collapse = ", "))
  }

  # ============================
  # parse Mutation_Class
  maf.df[, mutation.class.col] <- mapMutationTypeToMutationClass(maf.df[, variant.class.col],
                                                                 mutation.type.to.class.df)

  # ============================
  # parse amino-acid position
  maf.df[, aa.pos.col] <- parseProteinChange(maf.df[, protein.change.col],
                                             maf.df[, mutation.class.col])

  # ============================
  # sort according to
  maf.df <- maf.df[order(maf.df[, aa.pos.col], maf.df[, gene.symbol.col], maf.df[, protein.change.col], decreasing = FALSE), ]

  maf.df
}
