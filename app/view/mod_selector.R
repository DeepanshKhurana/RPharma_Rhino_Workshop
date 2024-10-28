box::use(
  glue[
    glue
  ],
  shiny[
    dateRangeInput,
    div,
    moduleServer,
    NS,
    observeEvent,
    removeUI,
    renderUI,
    tags,
    uiOutput
  ],
  stats[
    na.omit
  ],
)

box::use(
  app/logic/general_utils[
    is_convertible_to_date
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "selectors",
    uiOutput(
      ns("date_range")
    ),
  )
}

#' @export
server <- function(
  id,
  app_data
) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    observeEvent(app_data$date_column, {
      if (
        is_convertible_to_date(
          app_data$date_column,
          app_data$dataset
        )
      ) {
        output$date_range <- renderUI({
          dates <- na.omit(
            app_data$dataset[[app_data$date_column]]
          )
          dateRangeInput(
            inputId = ns("date_range"),
            label = app_data$date_column,
            start = min(dates),
            end = max(dates),
            min = min(dates),
            max = max(dates)
          )
        })
      } else {
        removeUI(selector = ns("date_range"))
        output$date_range <- renderUI({
          tags$p(
            glue(
              "{app_data$date_column} has no dates"
            )
          )
        })
      }
    })
  })
}
