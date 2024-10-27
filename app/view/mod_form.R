box::use(
  pharmaversesdtm[
    dm,
    ds
  ],
  shiny[
    dateRangeInput,
    div,
    moduleServer,
    NS,
    observe,
    selectizeInput,
    textInput,
    updateDateRangeInput
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
    dateRangeInput(
      inputId = ns("date_range"),
      label = "Date Range",
      start = "2020-01-01",
      end = "2020-12-31"
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
      if ("DMDTC" %in% names(app_data$dataset)) {
        updateDateRangeInput(
          session,
          inputId = "date_range",
          start = min(app_data$dataset$DMDTC),
          end = max(app_data$dataset$DMDTC)
        )
      } else if ("DSDTC" %in% names(app_data$dataset)) {
        updateDateRangeInput(
          session,
          inputId = "date_range",
          start = min(app_data$dataset$DSDTC),
          end = max(app_data$dataset$DSDTC)
        )
      } else {
        stop("Expected date column not found in dataset.")
      }
    })

  })
}
