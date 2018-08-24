#' G3Lollipop diagram for mutation data
#'
#' @description Generate G3Lollipop chart from the given mutation data.
#'
#' @param mutation.dat Mutation data frame.
#' @param gene.symbol HGNC gene symbol.
#' @param uniprot.id UniProt ID, in case that gene symbol maps to multiple UniProt entries.
#'
#' @param gene.symbol.col Column name of Hugo gene symbols (e.g., TP53). Default \emph{Hugo_Symbol}.
#' @param aa.pos.col Column name of the parsed amino-acid change position. Default \emph{AA_Position}.
#' @param protein.change.col Column name of protein change information (e.g., p.K960R, G658S, L14Sfs*15).
#'   Default is a list of \emph{Protein_Change}, \emph{HGVSp_Short}.
#' @param factor.col column of classes in the plot legend. IF \code{NA}, use parsed \emph{Mutation_Class} column,
#'   otherwise, use specified.  Default \code{NA}.
#' @param plot.options options of lollipop plot in list format
#'
#' @examples
#' \dontrun{
#' # Example 1: visualize mutation data from cBioPortal
#' #   note: internet access required, may use more than 10 seconds
#' mutation.dat <- getMutationsFromCbioportal("msk_impact_2017", "TP53")
#' # lollipop diagram with default options
#' g3Lollipop(mutation.dat, gene.symbol = "TP53")
#' }
#' # Example 2: visualize mutation data from MAF file
#' # load MAF file
#' maf.file <- system.file("extdata", "TCGA.BRCA.varscan.somatic.maf.gz", package = "g3viz")
#' mutation.dat <- readMAF(maf.file)
#'
#' # lollipop diagram, classified by "Variant_Classification"
#' # plot options: add chart title
#' plot.options <- g3Lollipop.options(
#'                      chart.margin = list(left = 40, right = 40, top = 30, bottom = 25),
#'                      title.text = "PIK3CA (TCGA-BRCA)",
#'                      title.font = "normal 20px Sans",
#'                      title.color = "steelblue",
#'                      title.alignment = "middle",
#'                      title.dy = "0.3em")
#' g3Lollipop(mutation.dat,
#'            gene.symbol = "PIK3CA",
#'            factor.col = "Variant_Classification",
#'            plot.options = plot.options)
#'
#' # Example 3: visualize mutation data in CSV or TSV formatted file
#' # load data
#' mutation.csv <- system.file("extdata", "ccle.csv", package = "g3viz")
#'
#' # customized column names
#' mutation.dat <- readMAF(mutation.csv,
#'                         gene.symbol.col = "Hugo_Symbol",
#'                         variant.class.col = "Variant_Classification",
#'                         protein.change.col = "amino_acid_change",
#'                         sep = ",")  # separator of csv file
#'
#' # plot options: try to mimic MutationMapper (http://www.cbioportal.org/mutation_mapper.jsp)
#' #               change color scheme of mutation track and domain annotation track
#' plot.options <- g3Lollipop.options(chart.width = 1600,
#'                                    chart.type = "circle",
#'                                    lollipop.track.background = "transparent",
#'                                    lollipop.pop.max.size = 4,
#'                                    lollipop.pop.min.size = 4,
#'                                    lollipop.pop.info.limit = 4.1, # same pop size
#'                                    y.axis.label = "# Mutations",
#'                                    lollipop.line.color = "grey",
#'                                    lollipop.line.width = 0.5,
#'                                    lollipop.circle.color = "black",
#'                                    lollipop.circle.width = 0.5,
#'                                    lollipop.color.scheme = "bottlerocket2",
#'                                    anno.bar.margin = list(top = 5, bottom = 5),
#'                                    domain.color.scheme = "darjeeling2",
#'                                    domain.text.font = "normal 8px Arial",
#'                                    domain.text.color = "white")
#'
#' g3Lollipop(mutation.dat,
#'            gene.symbol = "APC",
#'            protein.change.col = "amino_acid_change",
#'            plot.options = plot.options)
#'
#' @importFrom jsonlite toJSON
#'
#' @export
g3Lollipop <- function(mutation.dat,
                       # gene symbol or uniprot.id
                       gene.symbol, uniprot.id = NA,
                       # mutation data format
                       gene.symbol.col = "Hugo_Symbol",
                       aa.pos.col = "AA_Position", # x-axis
                       protein.change.col = c("Protein_Change", "HGVSp_Short"), # y-axis, detailed information, required for tooltip information
                       factor.col = "Mutation_Class",  # legend factor
                       plot.options = list()
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

  if(is.null(plot.options$legendTitle) && !is.na(factor.col)){
    plot.options$legendTitle <- factor.col
  }

  # check if all required columns exists in mutation.dat
  required.col <- c(gene.symbol.col, aa.pos.col)
  missing.columns <- required.col[!required.col %in% colnames(mutation.dat)]
  if(length(missing.columns) > 0){
    message(mutation.dat, " contains columns: ", paste(colnames(mutation.dat), collapse = ", "))
    stop("Some columns are missing in mutation data: ", paste(missing.columns, collapse = ", "))
  }

  # get mutation data for the given gene
  snv.data.df <- mutation.dat[mutation.dat[, gene.symbol.col] == gene.symbol
                              & !is.na(mutation.dat[, aa.pos.col]), ]
  snv.data.json <- toJSON(snv.data.df, pretty = FALSE, auto_unbox = TRUE)

  # get protein domain information
  domain.data.json <- hgnc2pfam(gene.symbol, uniprot.id)

  # read in data
  snv.data.format <- list(
    x = aa.pos.col,
    y = protein.change.col,
    factor = factor.col
  )

  snv.data.format.json <- toJSON(snv.data.format, pretty = FALSE, auto_unbox = TRUE)

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

  plot.options.json <- toJSON(plot.options, pretty = FALSE, auto_unbox = TRUE)

  x <- list(
    domainData = domain.data.json,
    domainDataFormat = domain.data.format.json,
    snvData = snv.data.json,
    snvDataFormat = snv.data.format.json,
    plotSettings = plot.options.json
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
#' Output and render functions for using g3-lollipop within Shiny
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
#' @name g3Lollipop-shiny
#'
#' @importFrom htmlwidgets shinyWidgetOutput
#'
#' @export
g3LollipopOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'g3Lollipop', width, height, package = 'g3viz')
}

#' @rdname g3Lollipop-shiny
#' @importFrom htmlwidgets shinyRenderWidget
#' @export
renderG3Lollipop <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, g3LollipopOutput, env, quoted = TRUE)
}
