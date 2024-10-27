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
    ),
    textInput(
      inputId = ns("title"),
      label = "Title",
      placeholder = "Enter title here"
    ),
    textInput(
      inputId = ns("description"),
      label = "Description",
      placeholder = "Enter description here"
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
      app_data$title <- input$title
      app_data$description <- input$description
      app_data$dataset <- get(input$dataset)
    })

  })
}
