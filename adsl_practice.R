library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  titlePanel("ADSL Viewer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("trt", "Select Treatment:",
                  choices = c("Placebo", "Xanomeline High Dose", "Xanomeline Low Dose"))
    ),
    mainPanel(
      tabsetPanel(
      #tableOutput("adsl_table"),
      #plotOutput("age_plot"),
      tabPanel('Plot', h4('Plot output'), plotlyOutput("age_plot")),
      tabPanel('Table', h4('Table output'), DTOutput("adsl_table"))
      )
    )
  )
)

server <- function(input, output, session) {
  
  adsl_filtered <- reactive({
    adsl %>% filter(TRT01P == input$trt)
  })
  
  # output$adsl_table <- renderTable({
  #   adsl_filtered()
  # })
  output$adsl_table <- renderDT({
      datatable(adsl_filtered())
  })
  
  output$age_plot <- renderPlotly({
    ggplot(adsl_filtered(), aes(x = AGE)) +
      geom_histogram()
  })
}

shinyApp(ui, server)