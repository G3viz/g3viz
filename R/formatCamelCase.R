#' change to camel case
#' @export
formatCamelCase <- function(in.df){
  stopifnot(is.data.frame(in.df))

  firstLetterCap <- function(x, sep = "_") {
    s <- strsplit(x, sep)[[1]]
    paste(toupper(substring(s, 1,1)), substring(s, 2), sep = "", collapse = sep)
  }

  col.names <- colnames(in.df)
  col.new.names <- sapply(col.names, firstLetterCap)
  colnames(in.df) <- col.new.names

  in.df
}
