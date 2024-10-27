box::use(
  reactable[
    reactable,
    reactableOutput,
    renderReactable
  ],
  shiny[
    moduleServer,
    NS
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  reactableOutput(
    ns("table")
  )
}

#' @export
server <- function(
  id,
  app_data
) {
  moduleServer(id, function(input, output, session) {
    output$table <- renderReactable({
      reactable(
        data = app_data$dataset
      )
    })
  })
}
