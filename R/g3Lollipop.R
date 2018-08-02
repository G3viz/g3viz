#' Plot Lollipop diagram plot for mutation data.
#'
#' @description
#'
#' @param mutation.dat Mutation data frame.
#' @param gene.symbol HGNC gene symbol.
#' @param uniprot.id UniProt ID, in case that gene symbol maps to multiple UniProt entries.
#' @param gene.symbol.col Column name of Hugo gene symbols (e.g., TP53). Default \emph{Hugo_Symbol}.
#' @param variant.class.col Column name of variant class information
#' (e.g., \emph{Missense_Mutation}, \emph{Nonsense_Mutation}). Default is a list of \emph{Variant_Classification} and \emph{Mutation_Class}.
#' @param protein.change.col Column name of protein change information (e.g., p.K960R, G658S, L14Sfs*15).
#' Default is a list of \emph{Protein_Change}, \emph{HGVSp_Short}.
#' @param mutation.class.col Column name of the parsed mutation class. Default \emph{Mutation_Class}.
#' @param aachange.pos.col Column name of the parsed amino-acid change position. Default \emph{AA_Position}.
#' @param factor.col column of classes in the plot legend. IF \code{NA}, use parsed \emph{Mutation_Class} column,
#' otherwise, use specified.  Default \code{NA}.
#'
#' @param chart.with chart width. Default 800.
#' @param chart.type \emph{pie} or \emph{circle}. Default \emph{pie}.
#' @param chart.margin chart margin in \emph{list}. Default \code{list(left = 40, right = 20, top = 15, bottom = 25)}.
#' @param chart.background chart background. Default \emph{transparent}.
#' @param transition.time chart animation transition time in millisecond.  Default 600.
#'
#' @param y.axis.label Y-axis label text. Default \emph{mutations}.
#' @param axis.label.font css font style shorthand
#' (\emph{font-style font-variant font-weight font-size/line-height font-family}).
#' Default \emph{"normal 12px Arial"}.
#' @param axis.label.color axis label text color. Default \emph{#4f4f4f}.
#' @param axis.label.alignment axis label text alignment (start/end/middle).  Default \emph{middle}.
#' @param axis.label.dy text adjustment of axis label text.  Default \emph{-2em}.
#'
#' @param legend.margin legend margin in \emph{list}.  Default \code{list(left = 10, right = 0, top = 5, bottom = 5)}.
#' @param legend.interactive legend interactive mode.  Default \code{TRUE}.
#' @param legend.title legend title. If \code{NA}, use \emph{factor.col}.  Default is \code{NA}.
#'
#' @param lollipop.track.height height of lollipop track. Default 420.
#' @param lollipop.track.background background of lollipop track.  Default \emph{rgb(244,244,244)}
#' @param lollipop.pop.min.size lollipop pop minimal size.  Default 2.
#' @param lollipop.pop.max.size lollipop pop maximal size. Default 12.
#' @param lollipop.pop.info.limit threshold of lollipop pop size to show count information in middle of pop.  Default 8.
#' @param lollipop.pop.info.color lollipop pop information text color. Default \emph{#EEE}.
#' @param lollipop.line.color lollipop line color. Default \emph{rgb(42,42,42)}.
#' @param lollipop.line.width lollipop line width. Default 0.5.
#' @param lollipop.circle.color lollipop circle border color. Default \emph{wheat}.
#' @param lollipop.circle.width lollipop circle border width. Default 0.5.
#' @param lollipop.label.ratio lollipop click-out label font size to circle size ratio.  Default 1.4.
#' @param lollipop.label.min.font.size lollipop click-out label minimal font size.  Default 10.
#' @param lollipop.color.scheme color scheme to fill lollipop pops.  Default \emph{accent}.
#'
#' @param title.text title of chart. Default is empty.
#' @param title.font font of chart title. Default \emph{normal 16px Arial}.
#' @param title.color color of chart title. Default \emph{#424242}.
#' @param title.alignment text alignment of chart title (start/middle/end). Default \emph{middle}.
#' @param title.dy text adjustment of chart title.  Default \emph{0.35em}.
#'
#' @param anno.height height of protein structure annotation track.  Default 30.
#' @param anno.margin margin of protein structure annotation track.  Default \code{list(top = 4, bottom = 0)}.
#' @param anno.background background of protein structure annotation track.  Default \emph{transparent}.
#' @param anno.bar.fill background of protein bar in protein structure annotation track.  Default \emph{#e5e3e1}.
#' @param anno.bar.margin margin of protein bar in protein structure annotation track.  Default \code{list(top = 2, bottom = 2)}.
#'
#' @param domain.color.scheme color scheme of protein domains.  Default \emph{category10}.
#' @param domain.margin margin of protein domains.  Default \code{list(top = 0, bottom = 0)}.
#' @param domain.text.font domain label text font in shorthand format.  Default \emph{normal 11px Arial}.
#' @param domain.text.color domain label text color.  Default \emph{#f2f2f2}.
#'
#' @param legend if show legend.  Default \code{TRUE}.
#' @param tooltip if show tooltip.  Default \code{TRUE}.
#' @param brush if show brush.  Default \code{TRUE}.
#' @param zoom if enable zoom feature.  Default \code{TRUE}.
#'
#' @import htmlwidgets
#'
#' @export
g3Lollipop <- function(mutation.dat,
                       gene.symbol,
                       uniprot.id = NA,
                       gene.symbol.col = "Hugo_Symbol",
                       variant.class.col = c("Variant_Classification", "Mutation_Type"),
                       protein.change.col = c("Protein_Change", "HGVSp_Short"),
                       mutation.class.col = "Mutation_Class",
                       aa.pos.col = "AA_Position",
                       factor.col = NA,
                       # chart options
                       chart.width = 800,
                       chart.type = "pie",
                       chart.margin = list(left = 40, right = 20, top = 15, bottom = 25),
                       chart.background = "transparent",
                       transition.time = 600,
                       # axis
                       y.axis.label = "mutations",
                       axis.label.font = "normal 12px Arial",
                       axis.label.color = "#4f4f4f",
                       axis.label.alignment = "middle",
                       axis.label.dy = "-2em",
                       # legend
                       legend.margin = list(left = 10, right = 0, top = 5, bottom = 5),
                       legend.interactive = TRUE,
                       legend.title = NA,
                       # lollipop track
                       lollipop.track.height = 420,
                       lollipop.track.background = "rgb(244,244,244)",
                       # pop size
                       lollipop.pop.min.size = 2,
                       lollipop.pop.max.size = 12,
                       lollipop.pop.info.limit = 8,
                       lollipop.pop.info.color = "#EEE",
                       lollipop.line.color = "rgb(42,42,42)",
                       lollipop.line.width = 0.5,
                       lollipop.circle.color = "wheat",
                       lollipop.circle.width = 0.5,
                       lollipop.label.ratio = 1.4,
                       lollipop.label.min.font.size = 10,
                       lollipop.color.scheme = "accent",
                       # title text
                       title.text = "",
                       title.font = "normal 16px Arial",
                       title.color = "#424242",
                       title.alignment = "middle",
                       title.dy = "0.35em",
                       # annotation track
                       anno.height = 30,
                       anno.margin = list(top = 4, bottom = 0),
                       anno.background = "transparent",
                       anno.bar.fill = "#e5e3e1",
                       anno.bar.margin = list(top = 2, bottom = 2),
                       # domain
                       domain.color.scheme = "category10",
                       domain.margin = list(top = 0, bottom = 0),
                       domain.text.font = "normal 11px Arial",
                       domain.text.color = "#f2f2f2",
                       # others
                       legend = TRUE,
                       tooltip = TRUE,
                       brush = TRUE,
                       zoom = TRUE
                       ){
  # check gene.symbol
  if(is.null(gene.symbol)){
    stop("Please provide a gene symbol")
  }

  variant.class.col <- guessMAFColumnName(mutation.dat, variant.class.col)
  if(is.na(variant.class.col)){
    stop("Can not find variant_class column in mutation data.")
  }

  protein.change.col <- guessMAFColumnName(mutation.dat, protein.change.col)
  if(is.na(protein.change.col)){
    stop("Can not find protein_change column in mutation data.")
  }

  # check if all required columns exists in mut.dat
  mut.required.col <- c(gene.symbol.col, protein.change.col)

  missing.columns <- mut.required.col[!mut.required.col %in% colnames(mutation.dat)]
  if(length(missing.columns) > 0){
    message(mutation.dat, " contains columns: ", paste(colnames(mutation.dat), collapse = ", "))
    stop("Some columns are missing in mutation data: ", paste(missing.columns, collapse = ", "))
  }

  # if need to check "mutation.class.col" or "aa.pos.col"
  # parse Mutation_Class
  if(!mutation.class.col %in% colnames(mutation.dat)){
    mutation.dat[, mutation.class.col] <- mapMutationTypeToMutationClass(mutation.dat[, variant.class.col])
  }

  # parse amino-acid position
  if(!aa.pos.col %in% colnames(mutation.dat)){
    mutation.dat[, aa.pos.col] <- parseProteinChange(mutation.dat[, protein.change.col],
                                                     mutation.dat[, mutation.class.col])
  }

  # check if by.factor column exists
  if(is.na(factor.col)){
    factor.col <- mutation.class.col
  }
  if(!factor.col %in% colnames(mutation.dat)){
    stop("No ", factor.col, " column in ", maf.file)
  }

  if(is.na(legend.title)){
    legend.title <- factor.col
  }

  # get mutation data for the given gene
  snv.data.df <- mutation.dat[mutation.dat[, gene.symbol.col] == gene.symbol
                              & !is.na(mutation.dat[, aa.pos.col]), ]
  snv.data.json <- jsonlite::toJSON(snv.data.df, pretty = FALSE, auto_unbox = TRUE)

  # get protein domain information
  domain.data.json <- hgnc2pfam(gene.symbol, uniprot.id)

  # read in data
  snv.data.format <- list(
    x = aa.pos.col,
    y = protein.change.col,
    factor = factor.col
  )

  snv.data.format.json <- jsonlite::toJSON(snv.data.format, pretty = FALSE, auto_unbox = TRUE)

  # domain data format
  domain.data.format = list(
    length = "length",
    domainType = "pfam",
    details = list(
      start = "start",
      end = "end",
      name = "hmm.name"
    )
  )
  domain.data.format.json = jsonlite::toJSON(domain.data.format, pretty = FALSE, auto_unbox = TRUE)

  # plot settings
  plot.settings <- list(
    chartWidth = chart.width,
    chartType = chart.type,
    chartMargin = chart.margin,
    chartBackground = chart.background,
    transitionTime = transition.time,
    # axis
    yAxisLabel = y.axis.label,
    axisLabelFont = axis.label.font,
    axisLabelColor = axis.label.color,
    axisLabelAlignment = axis.label.alignment,
    axisLabelDy = axis.label.dy,
    # legend
    legendMargin = legend.margin,
    legendInteractive = legend.interactive,
    legendTitle = legend.title,
    # lollipop track
    lollipopTrackHeight = lollipop.track.height,
    lollipopTrackBackground = lollipop.track.background,
    # pop size
    lollipopPopMinSize = lollipop.pop.min.size,
    lollipopPopMaxSize = lollipop.pop.max.size,
    lollipopPopInfoLimit = lollipop.pop.info.limit,
    lollipopPopInfoColor = lollipop.pop.info.color,
    lollipopLineColor = lollipop.line.color,
    lollipopLineWidth = lollipop.line.width,
    lollipopCircleColor = lollipop.circle.color,
    lollipopCircleWidth = lollipop.circle.width,
    lollipopLabelRatio = lollipop.label.ratio,
    lollipopLabelMinFontSize = lollipop.label.min.font.size,
    lollipopColorScheme = lollipop.color.scheme,
    # title text
    titleText = title.text,
    titleFont = title.font,
    titleColor = title.color,
    titleAlignment = title.alignment,
    titleDy = title.dy,
    # annotation track
    annoHeight = anno.height,
    annoMargin = anno.margin,
    annoBackground = anno.background,
    annoBarFill = anno.bar.fill,
    annoBarMargin = anno.bar.margin,
    # domain
    domainColorScheme = domain.color.scheme,
    domainMargin = domain.margin,
    domainTextFont = domain.text.font,
    domainTextColor = domain.text.color,
    # others
    legend = legend,
    tooltip = tooltip,
    brush = brush,
    zoom = zoom
  )

  plot.settings.json <- jsonlite::toJSON(plot.settings, pretty = FALSE, auto_unbox = TRUE)

  x <- list(
    domainData = domain.data.json,
    domainDataFormat = domain.data.format.json,
    snvData = snv.data.json,
    snvDataFormat = snv.data.format.json,
    plotSettings = plot.settings.json
  )

  htmlwidgets::createWidget(
    name = "g3Lollipop",
    x,
    package = "g3viz"
  )

#  plot.settings.json
}

#' Shiny bindings for g3-lollipop
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
#' @name g3-lollipop-shiny
#'
#' @export
g3LollipopOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'g3-lollipop', width, height, package = 'g3viz')
}

#' @rdname g3-lollipop-shiny
#' @export
renderG3Lollipop <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, g3-lollipopOutput, env, quoted = TRUE)
}
