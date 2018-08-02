#' Guess column name for MAF file
#'
#' @param maf.df MAF data frame
#' @param alt.column.names a vector of alternative column names
#'
#' @return if hit one alternative column name, return the name; otherwise, return \code{NA}
#'
#' @export
guessMAFColumnName <- function(maf.df, alt.column.names){
  idx <- which(alt.column.names %in% colnames(maf.df))

  if(length(idx) == 1){
    return(alt.column.names[idx])
  } else {
    return(NA)
  }
}
