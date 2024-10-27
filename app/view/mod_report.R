box::use(
  shiny[
    div,
    moduleServer,
    NS,
    reactiveValuesToList,
    renderPrint,
    verbatimTextOutput
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "mod-report",
    verbatimTextOutput(
      ns("report")
    )
  )
}

#' @export
server <- function(
  id,
  app_data
) {
  moduleServer(id, function(input, output, session) {
    output$report <- renderPrint({
      list(
        "dataset" = app_data$dataset,
        "description" = app_data$description,
        "title" = app_data$title
      )
    })
  })
}
