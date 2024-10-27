box::use(
  shiny[
    div,
    isTruthy,
    moduleServer,
    NS,
    observeEvent,
    reactiveValues,
    renderUI,
    req,
    tags,
    uiOutput
  ],
)

box::use(
  app/view/mod_report,
  app/view/mod_form
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "app-container",
    mod_report$ui(ns("report")),
    mod_form$ui(ns("form"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

      app_data <- reactiveValues(
        dataset = NULL,
        description = NULL,
        title = NULL
      )

      mod_form$server(
        "form",
        app_data
      )

      observeEvent(app_data$dataset, {
        req(app_data$dataset)
        mod_report$server(
          "report",
          app_data
        )
      })

  })
}
