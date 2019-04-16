#' G3Lollipop chart options of built-in themes.
#'
#' @param theme.name theme name, including \emph{default}, \emph{cbioportal},
#'   \emph{nature}, \emph{nature2}, \emph{dark}, \emph{blue}, \emph{ggplot2}, and \emph{simple}. Default
#'   \emph{default}.
#' @param y.axis.label Y-axis label text. Default \emph{"# of mutations"}.
#' @param legend.title legend title.  If \code{NA}, \emph{factor.col} in
#'   \code{\link{g3Lollipop}} is used. Default is \code{NA}.
#' @param title.text title of chart. Default is empty.
#'
#' @return a list with g3Lollipop plot options
#'
#' @export
g3Lollipop.theme <- function(
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
    lollipop.track.background = "#F5F5DC",
    lollipop.track.height = 360,
    anno.height = 30,
    anno.background = "#F5F5DC",
    anno.margin = list(top = 0, bottom = 0),
    anno.bar.fill = "#F5F5DC",
    anno.bar.margin = list(top = 8, bottom = 8),
    domain.text.color = "white",
    domain.text.font = "italic 12px Serif",
    domain.color.scheme = "dark2",
    lollipop.pop.min.size = 6,
    lollipop.pop.max.size = 6,
    lollipop.pop.info.limit = 6.1,
    lollipop.color.scheme = "pie5",
    lollipop.circle.color = "#b2b3b4",
    lollipop.circle.width = 1,
    brush.selection.background = "transparent",
    brush.border.color = "#808000",
    brush.handler.color = "#808000"
    #    anno.bar.fill = "transparent"
  )

  theme.list[["nature2"]] <- g3Lollipop.options(
    chart.width = 800,
    chart.type = "pie",
    chart.background = "transparent",
    lollipop.track.background = "#F5F5DC",
    lollipop.track.height = 360,
    anno.height = 30,
    anno.background = "#F5F5DC",
    anno.margin = list(top = 2, bottom = 0),
    anno.bar.fill = "grey",
    anno.bar.margin = list(top = 8, bottom = 8),
    domain.text.color = "white",
    domain.text.font = "italic 18px Serif",
    domain.color.scheme = "dark2",
    lollipop.pop.min.size = 2,
    lollipop.pop.max.size = 12,
    lollipop.pop.info.limit = 8,
    #  lollipop.color.scheme = "pie5",
    lollipop.circle.color = "#b2b3b4",
    lollipop.circle.width = 1,
    brush.selection.background = "transparent",
    brush.border.color = "#808000",
    brush.handler.color = "#808000"
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
    anno.background = "#f5f5f5",
    anno.margin = list(top = 0, bottom = 0),
    anno.bar.fill = "#999999",
    anno.bar.margin = list(top = 3, bottom = 3),
    # lollipop track options
    lollipop.track.height = 320,
    lollipop.track.background = "#ebebeb",
    lollipop.pop.info.color = "white",
    lollipop.color.scheme = "dark2",
    # yline
    y.axis.line.color = "white",
    y.axis.line.style = "line",
    y.axis.line.width = 1.4,
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

  # dark theme
  theme.list[["dark"]] <- g3Lollipop.options(
    # chart options
    chart.width = 600,
    chart.type = "pie",
    chart.margin = list(left = 30, right = 20, top = 20, bottom = 30),
    chart.background = "#d3d3d3",
    # transition time
    transition.time = 300,
    axis.label.color = "#303030",
    axis.label.alignment = "end",
    axis.label.font = "italic 12px Serif",
    axis.label.dy = "-1.5em",
    # in-chart tick lines
    y.axis.line.color = "#303030",
    y.axis.line.width = 0.5,
    y.axis.line.style = "line",
		y.max.range.ratio = 1.1,
    # legend
    legend = TRUE,
    legend.margin = list(left=20, right = 0, top = 10, bottom = 5),
    legend.interactive = TRUE,
    # lollipop track
    lollipop.track.height = 200,
    lollipop.track.background = "#d3d3d3",
    # lollipop pop
    lollipop.pop.min.size = 1,
    lollipop.pop.max.size = 8,
    # lollipop in-pop information
    lollipop.pop.info.limit = 5.5,
    lollipop.pop.info.dy = "0.24em",
    lollipop.pop.info.color = "white",
    # lollipop line
    lollipop.line.color = "#a9A9A9",
    lollipop.line.width = 3,
    # lollipop circle
    lollipop.circle.color = "#ffdead",
    lollipop.circle.width = 0.4,
    # lollipop click-on-pop highlight label
    lollipop.label.ratio = 2,
    lollipop.label.min.font.size = 12,
    # lollipop color scheme
    lollipop.color.scheme = "dark2",
    # highlight text angle
    highlight.text.angle = 60,
    # chart title
    title.color = "#303030",
    title.font = "bold 12px monospace",
    title.alignment = "start",
    # annotation track
    anno.height = 16,
    anno.margin = list(top = 0, bottom = 0),
    anno.background = "#d3d3d3",
    # annotation track bar
    anno.bar.fill = "#a9a9a9",
    anno.bar.margin = list(top = 4, bottom = 4),
    # protein domain
    domain.color.scheme = "pie5",
    domain.margin = list(top = 2, bottom = 2),
    domain.text.color = "white",
    domain.text.font = "italic 8px Serif",
    # selection brush
    brush = TRUE,
    brush.selection.background = "#F8F8FF",
    brush.selection.opacity = 0.3,
    brush.border.color = "#a9a9a9",
    brush.border.width = 1,
    brush.handler.color = "#303030",
    # tooltip
    tooltip = TRUE,
    # zoom
    zoom = TRUE
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
