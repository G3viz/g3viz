library(g3viz)
library(shiny)

mutation.csv <- system.file("extdata", "ccle.csv", package = "g3viz")
selectize_values <- function(){
  return(levels(read.csv(mutation.csv, header = T)$Hugo_Symbol))
}


ui <- fluidPage(
  titlePanel("g3lollipop test"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("gene", "Elija un gen de la muestra", selectize_values())
    ),
    mainPanel(
      g3LollipopOutput("distPlot",width = "800px")
    )
  )
)

server <- function(input, output, session) {


  output$distPlot <- renderG3Lollipop({

    mutation.dat <- readMAF(mutation.csv,
                            gene.symbol.col = "Hugo_Symbol",
                            variant.class.col = "Variant_Classification",
                            protein.change.col = "amino_acid_change",
                            sep = ",")  # column-separator of csv file

    gene <- input$gene
    theme <- g3Lollipop.theme(theme.name = "cbioportal",
                              title.text = paste0(gene, " gene"),
                              y.axis.label = paste0("# of ", gene, " Mutations"))
    theme[['chartWidth']] <- "1600"

    g3Lollipop(mutation.dat,
               gene.symbol = gene,
               protein.change.col = "amino_acid_change",
               plot.options = theme,
               btn.style = "gray",
               output.filename = "customized_plot")

  })
}
shinyApp(ui = ui, server = server)
