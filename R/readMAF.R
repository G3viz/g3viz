#'Read MAF file
#'
#'Read mutation information from MAF file. For MAF format specification, see
#'\url{https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/}.
#'
#'@param maf.file MAF file name.  Gnuzipped input file allowed, with ".gz" file
#'  extension.
#'@param gene.symbol.col Column name of Hugo gene symbols (e.g., TP53). Default
#'  \emph{Hugo_Symbol}.
#'@param variant.class.col Column name for variant class information (e.g.,
#'  \emph{Missense_Mutation}, \emph{Nonsense_Mutation}). Default is the first
#'  match of \emph{Variant_Classification} or \emph{Mutation_Type}.
#'@param protein.change.col Column name for protein change information (e.g.,
#'  p.K960R, G658S, L14Sfs*15). Default is the first match of
#'  \emph{Protein_Change} or \emph{HGVSp_Short}.
#'@param if.parse.aa.pos if parse amino-acid position of mutations. Default is
#'  \code{TRUE}.
#'@param if.parse.mutation.class if parse mutation class from mutation type
#'  (variant classification) information. Default is \code{TRUE}.
#'@param mutation.class.col Column name of the parsed mutation class. Default
#'  \emph{Mutation_Class}.
#'@param aa.pos.col Column name of the parsed amino-acid change position.
#'  Default \emph{AA_Position}.
#'@param mutation.type.to.class.df mapping table from mutation type to class.
#'  \code{\link{mapMutationTypeToMutationClass}} for details. Default \code{NA},
#'  which indicates to use default mappoings.
#'@param sep separator of columns. Default \code{sep = "\\t"}.
#'@param quote the set of quoting characters. To disable quoting altogether,
#'  use \code{quote = ""}.  Default \code{quote = ""}.
#'@param ... additional parameters pass to \code{\link[utils]{read.table}}.
#'
#'@importFrom utils write.table read.table
#'
#'@return a data frame containing MAF information, plus optional columns of the
#'  parsed \emph{Mutation_Class} and \emph{Protein_Position}.
#'
#'@export
readMAF <- function(maf.file,
                    gene.symbol.col = "Hugo_Symbol",
                    variant.class.col = c("Variant_Classification", "Mutation_Type"),
                    protein.change.col = c("Protein_Change", "HGVSp_Short"),
                    if.parse.aa.pos = TRUE,
                    if.parse.mutation.class = TRUE,
                    mutation.class.col = "Mutation_Class",
                    aa.pos.col = "AA_Position",
                    mutation.type.to.class.df = NA,
                    sep = "\t",
                    quote = "",
                    ...) {
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
      maf.df <- read.table(gzfile(description = maf.file), header = TRUE, sep = sep, quote = quote, ...)
    )
  } else {
    maf.df <- read.table(maf.file, header = TRUE, sep = sep, quote = quote, ...)
  }

  # =============================
  # check if all required columns exist
  variant.class.col <- guessMAFColumnName(maf.df, variant.class.col)
  if(is.na(variant.class.col)){
    stop("Can not find Variant_Class column.")
  }

  protein.change.col <- guessMAFColumnName(maf.df, protein.change.col)
  if(is.na(protein.change.col)){
    stop("Can not find Protein_Change column.")
  }

  maf.required.col <- c(gene.symbol.col)
  missing.columns <- maf.required.col[!maf.required.col %in% colnames(maf.df)]
  if(length(missing.columns) > 0){
    message(maf.file, " contains columns: ", paste(colnames(maf.df), collapse = ", "))
    stop("Some columns are missing in MAF file: ", paste(missing.columns, collapse = ", "))
  }

  # ============================
  # parse Mutation_Class
  if(if.parse.mutation.class){
    maf.df[, mutation.class.col] <- mapMutationTypeToMutationClass(maf.df[, variant.class.col],
                                                                   mutation.type.to.class.df)
  }

  # ============================
  # parse amino-acid position
  if(if.parse.aa.pos){
    maf.df[, aa.pos.col] <- parseProteinChange(maf.df[, protein.change.col],
                                               maf.df[, mutation.class.col])

    # sort according to amino-acid position
    maf.df <- maf.df[order(maf.df[, aa.pos.col], maf.df[, gene.symbol.col], maf.df[, protein.change.col], decreasing = FALSE), ]
  }

  maf.df
}
