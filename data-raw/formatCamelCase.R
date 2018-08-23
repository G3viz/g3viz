#' format a give string to camel case (e.g., from \emph{abc_efg} to \emph{Abc_Efg})
#' @param x input string
#' @param sep separator. Default \emph{_}.
#'
#' @return the string in camel format
#'
#' @export
formatCamelCase <- function(x, sep = "_"){
  stopifnot(is.character(x))

  s <- strsplit(x, sep)[[1]]
  t <- paste(toupper(substring(s, 1,1)), substring(s, 2), sep = "", collapse = sep)

  t
}
