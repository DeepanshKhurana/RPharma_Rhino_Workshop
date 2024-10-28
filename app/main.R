box::use(
  config[
    get
  ],
  pharmaversesdtm[
    dm #nolint
  ],
  shiny[
    fluidPage,
    moduleServer,
    NS,
    reactiveValues,
    tags
  ],
)

box::use(
  app/view/mod_selector,
  app/view/mod_table,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    class = "app-container",
    tags$header(
      tags$a(
        href = get("rpharma_url"),
        tags$img(
          src = get("rpharma_logo"),
          alt = "R/Pharma Logo",
          class = "logo"
        )
      ),
      mod_selector$ui(ns("form"))
    ),
    mod_table$ui(ns("table"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    app_data <- reactiveValues(
      dataset = dm,
      date_column = NULL
    )

    mod_table$server(
      "table",
      app_data
    )

    mod_selector$server(
      "form",
      app_data
    )

  })
}
