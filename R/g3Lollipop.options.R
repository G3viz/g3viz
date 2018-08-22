#' G3Lollipop plot options
#'
#' @param chart.width chart width. Default 800.
#' @param chart.type \emph{pie} or \emph{circle}. Default \emph{pie}.
#' @param chart.margin specify chart margin in _list_ format. Default \code{list(left = 40, right = 20, top = 15, bottom = 25)}.
#' @param chart.background chart background. Default \emph{transparent}.
#' @param transition.time chart animation transition time in millisecond.  Default 600.
#'
#' @param y.axis.label Y-axis label text. Default \emph{mutations}.
#' @param axis.label.font css font style shorthand
#'   (\emph{font-style font-variant font-weight font-size/line-height font-family}).
#'   Default \emph{"normal 12px Arial"}.
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
#' @return a list with g3Lollipop plot options
#' @export
g3Lollipop.options <- function(chart.width = 800,
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
  # plot settings
  plot.options <- list(chartWidth = chart.width,
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

  plot.options
}
