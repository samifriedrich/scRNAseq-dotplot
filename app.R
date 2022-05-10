library(shiny)
library(shinysky)
library(glue)
library(Seurat)
library(ggplot2)
library(shinyWidgets)

df <- readRDS("runs_combined.rds")
all_gene_symbols <- unique(rownames(x = df))
default_genes <-
  c(
    'CFD',
    'CLIC4',
    'CSF1R',
    'RGS10',
    'MAG',
    'PLP1',
    'FGFR3',
    'SOX9',
    'GAD2',
    'GAD1',
    'CAMK2A',
    'SLC17A6',
    'SYN2',
    'SNAP25'
  )

ui <- fluidPage(
  titlePanel("Cell Classes of the Intermediate Arcopallium"),
  textInput.typeahead(
    id = "gene_symbol",
    placeholder = "Enter gene symbol",
    local = data.frame(name = c(all_gene_symbols)),
    valueKey = "name",
    tokens = c(1:length(all_gene_symbols)),
    template = HTML(
      "<p class='repo-language'>{{info}}</p> <p class='repo-name'>{{name}}</p>"
    )
  ),
  actionBttn(
    inputId = "add",
    label = "Add",
    style = "simple",
    color = "primary",
    size = "sm"
  ),
  actionBttn(
    inputId = "clear",
    label = "Clear plot",
    style = "bordered",
    color = "primary",
    size = "sm"
  ),
  actionBttn(
    inputId = "default",
    label = "Cluster definitions",
    style = "bordered",
    color = "primary",
    size = "sm"
  ),
  downloadBttn(
    outputId = "download",
    label = "Download plot",
    style = "bordered",
    color = "primary",
    size = "sm"
  ),
  br(),
  br(),
  plotOutput(outputId = "dotplot"),
)

server <- function(input, output, session) {
  # create reactive values object
  myValues <- reactiveValues()
  
  # when "Add gene" button is pressed, append to genelist
  # condition checks that gene is not already in list, as duplicates broke
  # the factor() function used within DotPlot()
  observeEvent(input$add, {
    if (!(isolate(input$gene_symbol) %in% isolate(myValues$genelist))) {
      myValues$genelist <-
        c(isolate(myValues$genelist),
          isolate(input$gene_symbol))
    }
  })
  
  observeEvent(input$default, {
    myValues$genelist <- default_genes
  })
  
  # listen for either "add" or "default" button click
  triggerplot <- reactive({
    paste(input$add, input$default)
  })
  
  # build plot whenever "Add gene" button is clicked
  plot_reactive <- eventReactive(triggerplot(), {
    p <- DotPlot(df, features = myValues$genelist)
    p <- p +
      xlab("") +
      ylab("Cluster") +
      theme(axis.text.x = element_text(
        angle = 45,
        vjust = 0.9,
        hjust = 1
      ))
  })
  
  # display plot
  output$dotplot <- renderPlot({
    if (input$add > 0 | input$default > 0) {
      print(plot_reactive())
    }
  })
  
  # download plot
  output$download <- downloadHandler(
    filename = "dotplot.png",
    content  = function(file) {
      ggsave(
        file,
        plot = plot_reactive(),
        height = 5,
        width = (3 + length(isolate(
          myValues$genelist
        )) * 0.5)
      )
    }
  )
  # restart session (clear all input data)
  observeEvent(input$clear, {
    session$reload()
  })
  
}

shinyApp(ui = ui, server = server)
