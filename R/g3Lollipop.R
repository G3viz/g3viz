#' Render g3lollipop diagram for the given mutation data
#'
#' @description Render g3lollipop diagram for the given mutation data
#'
#' @param mutation.dat Input genomic mutation data frame
#' @param gene.symbol HGNC primary gene symbol
#' @param uniprot.id UniProt ID, in case that the specified gene symbol links to
#'   multiple UniProt entries (isoforms). For example, \emph{AKAP7} gene has two
#'   isoforms in \href{https://www.uniprot.org/}{UniProt},
#'   \href{https://www.uniprot.org/uniprot/O43687}{O43687} and
#'   \href{https://www.uniprot.org/uniprot/Q9P0M2}{Q9P0M2}.
#' @param gene.symbol.col Column name of Hugo gene symbols (e.g., TP53). Default
#'   \emph{Hugo_Symbol}.
#' @param aa.pos.col Column name of the parsed amino-acid change position.
#'   Default \emph{AA_Position}.
#' @param protein.change.col Column name of protein change information (e.g.,
#'   p.K960R, G658S, L14Sfs*15). Default is a list of \emph{Protein_Change},
#'   \emph{HGVSp_Short}.
#' @param factor.col column of classes in the plot legend. IF \code{NA}, use
#'   parsed \emph{Mutation_Class} column, otherwise, use specified.  Default
#'   \code{NA}.
#' @param plot.options g3lollipop diagram options in list format. Check
#'   \code{\link{g3Lollipop.options}}
#' @param save.png.btn If add \emph{save-as-png} button to the diagram. Default
#'   \code{TRUE}.
#' @param save.svg.btn If add \emph{save-as-svg} button to the diagram. Default
#'   \code{TRUE}.
#' @param btn.style button style, including browser default button style, and
#'   two built-in styles, \emph{blue} or \emph{gray}. Default \code{NA},
#'   indicating browser default.
#' @param output.filename Specify output file name.
#' @return lollipop diagram for the given mutation data. The chart is interactive
#'   within either Shiny applications or Rmd documents under the bindings.
#'
#' @examples
#'
#' # system mutation data
#' maf.file <- system.file("extdata", "TCGA.BRCA.varscan.somatic.maf.gz", package = "g3viz")
#' # read in MAF file
#' mutation.dat <- readMAF(maf.file)
#'
#' # use built-in chart theme
#' chart.options <- g3Lollipop.theme(theme.name = "default",
#'                                   title.text = "PIK3CA gene (default theme)")
#' # generate chart
#' g3Lollipop(mutation.dat,
#'            gene.symbol = "PIK3CA",
#'            plot.options = chart.options,
#'            btn.style = "blue",
#'            output.filename = "default_theme")
#'
#' @importFrom jsonlite toJSON
#'
#' @export
g3Lollipop <- function(mutation.dat,
                       # gene symbol or uniprot.id
                       gene.symbol, uniprot.id = NA,
                       # mutation data format
                       gene.symbol.col = "Hugo_Symbol",
                       # x-axis
                       aa.pos.col = "AA_Position",
                       # y-axis, detailed information, required for tooltip information
                       protein.change.col = c("Protein_Change", "HGVSp_Short"),
                       # legend factor
                       factor.col = "Mutation_Class",
                       plot.options = g3Lollipop.options(),
                       save.png.btn = TRUE,
                       save.svg.btn = TRUE,
                       btn.style = NA,
                       output.filename = "output"
                       ){
  stopifnot(is.data.frame(mutation.dat))

  # check gene symbol
  if(is.na(gene.symbol)){
    stop("Please provide a gene symbol")
  }

  # check data columns
  protein.change.col <- guessMAFColumnName(mutation.dat, protein.change.col)
  if(is.na(protein.change.col)){
    stop("Can not find protein_change column.")
  }

  factor.col <- guessMAFColumnName(mutation.dat, factor.col)
  message("Factor is set to ", factor.col)

  if(plot.options$legend && (is.na(plot.options$legendTitle) || is.null(plot.options$legendTitle)) && !is.na(factor.col)){
    plot.options$legendTitle <- factor.col
    message("legend title is set to ", factor.col)
  }

  # check if all required columns exists in mutation.dat
  required.col <- c(gene.symbol.col, aa.pos.col)
  missing.columns <- required.col[!required.col %in% colnames(mutation.dat)]
  if(length(missing.columns) > 0){
    message(mutation.dat, " contains columns: ", paste(colnames(mutation.dat), collapse = ", "))
    stop("Some columns are missing in mutation data: ", paste(missing.columns, collapse = ", "))
  }

  # =======================================
  # version 1.2.0
  # (1) custom domain information
  #     Require: domain
  # (2) custom domain information format
  #     Require
  # get protein domain information
  domain.data.json <- hgnc2pfam(hgnc.symbol = gene.symbol,
                                uniprot.id = uniprot.id)

  # domain data format
  domain.data.format <- list(
    length = "length",
    domainType = "pfam",
    details = list(
      start = "start",
      end = "end",
      name = "hmm.name"
    )
  )
  domain.data.format.json <- toJSON(domain.data.format, pretty = FALSE, auto_unbox = TRUE)
  # =======================================

  # get mutation data for the given gene
  snv.data.df <- mutation.dat[mutation.dat[, gene.symbol.col] == gene.symbol
                              & !is.na(mutation.dat[, aa.pos.col]), ]
  snv.data.json <- toJSON(snv.data.df, pretty = FALSE, auto_unbox = TRUE)

  # read in data
  snv.data.format <- list(
    x = aa.pos.col,
    y = protein.change.col,
    factor = factor.col
  )

  snv.data.format.json <- toJSON(snv.data.format, pretty = FALSE, auto_unbox = TRUE)

  plot.options.json <- toJSON(plot.options, pretty = FALSE, auto_unbox = TRUE)

  x <- list(
    domainData = domain.data.json,
    domainDataFormat = domain.data.format.json,
    snvData = snv.data.json,
    snvDataFormat = snv.data.format.json,
    plotSettings = plot.options.json,
    pngButton = save.png.btn,
    svgButton = save.svg.btn,
    btnStyle = btn.style,
    outputFN = output.filename
  )

  htmlwidgets::createWidget(
    name = "g3Lollipop",
    x,
    package = "g3viz"
  )

#  plot.settings.json
}

#' Shiny bindings for g3Lollipop
#'
#' Output and render functions for using g3viz lollipop diagram within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a g3-lollipop
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @return No value returned. It is the binding which enables interactive functions
#'   within Shiny applications and Rmd documents.
#' @name g3Lollipop-shiny
#'
#' @importFrom htmlwidgets shinyWidgetOutput
#'
#' @export
g3LollipopOutput <- function(outputId, width = '100%', height = '520px'){
  shinyWidgetOutput(outputId, 'g3Lollipop', width, height, package = 'g3viz')
}

#' @rdname g3Lollipop-shiny
#' @importFrom htmlwidgets shinyRenderWidget
#' @export
renderG3Lollipop <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, g3LollipopOutput, env, quoted = TRUE)
}
