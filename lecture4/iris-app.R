library(shiny)

ui <- fluidPage(
  titlePanel("The famous iris dataset"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create plots based on iris species."),
      selectInput("type",
                  label = "Species",
                  choices = list("Setosa", "Versicolor", "Virginica"),
                  selected = "Setosa"),
      checkboxGroupInput("vars",
                         label = "Variables",
                         choices = list("Sepal Length", "Sepal Width",
                                        "Petal Length", "Petal Width"),
                         selected = c("Sepal Length", "Petal Length"))
    ),
    mainPanel(
      textOutput("selected_species"),
      plotOutput("irisplot")
    )
  )
)
# Define server logic
server <- function(input, output) {
  output$selected_species <- renderText({ 
    paste("You have selected the", input$type, "species")
  })
  
  output$irisplot <- renderPlot({
    data.to.plot <- iris[iris$Species == tolower(input$type), ]
    x <- data.to.plot[, gsub(" ", ".", input$vars[1])]
    y <- data.to.plot[, gsub(" ", ".", input$vars[2])]
    plot(x, y, xlab=input$vars[1], ylab=input$vars[2], pch=16)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

