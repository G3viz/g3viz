#' G3Lollipop chart themes
#'
#' @param theme.name theme name.  Default \emph{default}
#' @param y.axis.label Y-axis label text. Default \emph{"# of mutations"}.
#' @param legend.title legend title.  If \code{NA}, \emph{factor.col} in \code{\link{g3Lollipop}} is used.
#'                     Default is \code{NA}.
#' @param title.text title of chart. Default is empty.
#'
#' @return a list with g3Lollipop plot options
#'
#' @return a list with g3Lollipop plot options
#' @export
g3Lollipop.theme.options <- function(
  theme.name = "default",
  title.text = "",
  y.axis.label = "# of mutations",
  legend.title = NA
){
  # plot settings
  theme.list <- list()

  # default theme
  theme.list[["default"]] <- g3Lollipop.options(
    chart.width = 640,
    lollipop.track.height = 360
  )

  # cbioportal theme
  theme.list[["cbioportal"]] <- g3Lollipop.options(
    # chart options
    chart.width = 680,
    chart.type = "circle",
    # lollipop track options
    lollipop.track.height = 260,
    lollipop.track.background = "transparent",
    lollipop.pop.max.size = 4,
    lollipop.pop.min.size = 4,
    # set larger than lollipop.pop.max.size to turn off pop info
    lollipop.pop.info.limit = 4.1,
    # y-axis label
    lollipop.line.color = "grey",
    lollipop.line.width = 0.5,
    lollipop.circle.color = "grey",
    lollipop.circle.width = 0.5,
    lollipop.color.scheme = "bottlerocket2",
    y.axis.line.color = "transparent",
    # domain annotation bar
    anno.bar.fill = "#969696",
    anno.bar.margin = list(top = 4, bottom = 8),
    # domain track options
    domain.margin = list(top = 2, bottom = 6),
    domain.color.scheme = "bottlerocket1",
    domain.text.font = "normal 12px Arial",
    domain.text.color = "white",
    # highlight text
    highlight.text.angle = 45,
    # disable brush
    brush = FALSE,
    # disable legend
    legend = TRUE
  )

  # Nature theme
  theme.list[["nature"]] <- g3Lollipop.options(
    chart.width = 640,
    chart.type = "pie",
    chart.background = "transparent",
    lollipop.track.background = "#ffffcc",
    lollipop.track.height = 360,
    anno.height = 30,
    anno.background = "#ffffcc",
    anno.margin = list(top = 0, bottom = 0),
    anno.bar.fill = "#b4b4b4",
    anno.bar.margin = list(top = 8, bottom = 8),
    domain.text.color = "white",
    domain.text.font = "italic 12px Serif",
    domain.color.scheme = "dark2",
    lollipop.pop.min.size = 6,
    lollipop.pop.max.size = 6,
    lollipop.pop.info.limit = 6.1,
    lollipop.color.scheme = "pie5",
    lollipop.circle.color = "#b4b4b4",
    lollipop.circle.width = 1,
    brush.selection.background = "transparent",
    brush.border.color = "#666666",
    brush.handler.color = "#666666"
    #    anno.bar.fill = "transparent"
  )

  # ggplot2 theme
  theme.list[["ggplot2"]] <- g3Lollipop.options(
    chart.width = 680,
    chart.type = "pie",
    chart.margin = list(left = 40, right = 20, top = 30, bottom = 25),
    chart.background = "transparent",
    # lollipop axis
    axis.label.font = "normal 12px Serif",
    axis.label.alignment = "middle",
    axis.label.color = "black",
    axis.label.dy = "-2em",
    # anno track
    anno.height = 24,
    anno.background = "#f2f2f2",
    anno.margin = list(top = 0, bottom = 0),
    anno.bar.fill = "#999999",
    anno.bar.margin = list(top = 3, bottom = 3),
    # lollipop track options
    lollipop.track.height = 320,
    lollipop.track.background = "#f2f2f2",
    lollipop.pop.info.color = "white",
    lollipop.color.scheme = "dark2",
    # yline
    y.axis.line.color = "white",
    y.axis.line.style = "line",
    y.axis.line.width = 0.5,
    # domain annotation track options
    domain.text.font = "bold 13px Serif",
    domain.color.scheme = "google16",
    domain.text.color = "white",
    # title
    title.font = "bold 18px Verdana",
    title.color = "#999999",
    title.alignment = "middle",
    title.dy = "0.3em",
    # domain brush options
    brush.selection.background = "#495769",
    brush.selection.opacity = 0.2,
    brush.border.color = "#666666",
    brush.handler.color = "#666666",
    highlight.text.angle = 90
  )

  # blue economist theme
  theme.list[["blue"]] <- g3Lollipop.options(
    chart.width = 680,
    chart.type = "pie",
    chart.margin = list(left = 40, right = 20, top = 30, bottom = 25),
    chart.background = "#deebf7",
    # lollipop axis
    axis.label.font = "bold 16px Sans",
    axis.label.alignment = "middle",
    axis.label.dy = "-1.5em",
    # lollipop track options
    lollipop.track.height = 300,
    lollipop.track.background = "white",
    lollipop.pop.info.color = "white",
    lollipop.color.scheme = "category10",
    # yaxis
    y.axis.line.color = "#bdbff9",
    y.axis.line.style = "line",
    y.axis.line.width = 0.5,
    # domain annotation track options
    domain.color.scheme = "pie5",
    domain.text.color = "white",
    # title
    title.font = "bold 20px Verdana",
    title.color = "steelblue",
    title.alignment = "middle",
    title.dy = "0.3em",
    # domain brush options
    brush.selection.background = "steelblue",
    brush.selection.opacity = 0.3,
    brush.border.color = "#666666",
    brush.handler.color = "#666666",
    highlight.text.angle = 60
  )

  # simple theme
  theme.list[["simple"]] <- g3Lollipop.options(
    chart.width = 640,
    chart.type = "circle",
    chart.background = "transparent",
    lollipop.track.background = "transparent",
    lollipop.track.height = 360,
    anno.height = 24,
    anno.background = "transparent",
    anno.margin = list(top = 0, bottom = 0),
    anno.bar.fill = "#a3a3a3",
    anno.bar.margin = list(top = 8, bottom = 8),
    domain.text.color = "white",
    domain.text.font = "bold 14px Sans",
    domain.color.scheme = "set2",
    lollipop.pop.min.size = 6,
    lollipop.pop.max.size = 6,
    lollipop.pop.info.limit = 16.1,
    lollipop.color.scheme = "accent",
    lollipop.circle.color = "transparent",
    lollipop.circle.width = 0,
    y.axis.line.style = "line",
    y.axis.line.color = "#f2f2f2",
    brush.selection.background = "#969696",
    brush.selection.opacity = 0.5,
    brush.border.color = "#525252",
    brush.handler.color = "#525252"
#    anno.bar.fill = "transparent"
  )

  if(is.null(theme.list[[theme.name]])){
    message("Unknown theme name [", theme.name, "], use default")
    message("Available theme name are ", paste(names(theme.list), collapse = " | "))
    theme <- theme.list[["default"]]
  } else {
    theme <- theme.list[[theme.name]]
  }

  theme$yAxisLabel = y.axis.label
  theme$legendTitle = legend.title
  theme$titleText = title.text

  theme
}
