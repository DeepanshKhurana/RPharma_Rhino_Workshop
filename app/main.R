box::use(
  shiny[
    fluidPage,
    moduleServer,
    NS,
    observeEvent,
    reactiveValues,
    req,
  ],
)

box::use(
  app/view/mod_form,
  app/view/mod_table,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    class = "app-container",
    mod_form$ui(ns("form")),
    mod_table$ui(ns("table"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    app_data <- reactiveValues(
      dataset = NULL
    )

    mod_form$server(
      "form",
      app_data
    )

    observeEvent(app_data$dataset, {
      req(app_data$dataset)
      mod_table$server(
        "table",
        app_data
      )
    })

  })
}
