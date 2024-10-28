box::use(
  reactable[
    getReactableState,
    reactable,
    reactableOutput,
    renderReactable
  ],
  shiny[
    div,
    moduleServer,
    NS,
    observeEvent,
    reactive
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "table",
    reactableOutput(
      ns("table")
    )
  )
}

#' @export
server <- function(
  id,
  app_data
) {
  moduleServer(id, function(input, output, session) {

    sort_state <- reactive({
      getReactableState(
        "table",
        "sorted"
      )
    })

    observeEvent(sort_state(), {
      app_data$date_column <- names(sort_state())[1]
    })

    output$table <- renderReactable({
      reactable(
        data = app_data$dataset,
        borderless = TRUE,
        searchable = TRUE,
        defaultSorted = list(
          "DMDTC" = "asc"
        )
      )
    })
  })
}
