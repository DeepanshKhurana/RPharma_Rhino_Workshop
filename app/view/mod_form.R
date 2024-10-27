box::use(
  pharmaversesdtm[
    dm,
    ds
  ],
  shiny[
    div,
    moduleServer,
    NS,
    observe,
    selectizeInput,
    textInput
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "mod-form",
    selectizeInput(
      inputId = ns("dataset"),
      label = "Dataset",
      choices = c(
        "dm",
        "ds"
      ),
      selected = "dm"
    )
  )
}

#' @export
server <- function(
  id,
  app_data
) {
  moduleServer(id, function(input, output, session) {

    observe({
      app_data$dataset <- get(input$dataset)
    })

  })
}
