box::use(
  glue[
    glue
  ],
  pharmaversesdtm[
    dm #nolint
  ],
  shiny,
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
  ns <- shiny$NS(id)
  shiny$tags$div(
    class = "selectors",
    shiny$uiOutput(
      ns("date_range_container")
    ),
    shiny$actionButton(
      ns("reset"),
      NULL,
      icon = shiny$icon("undo")
    )
  )
}

#' @export
server <- function(
  id,
  app_data
) {
  shiny$moduleServer(id, function(input, output, session) {

    ns <- session$ns

    shiny$observeEvent(input$reset, {
      app_data$filtered_dataset <- app_data$dataset
      app_data$date_column <- NULL
      shiny$removeUI(ns("date_range_container"))
    })

    shiny$observeEvent(input$date_range, {
      shiny$req(app_data$date_column)
      if (is.null(input$date_range)) {
        app_data$filtered_dataset <- app_data$dataset
      } else {
        app_data$filtered_dataset <- app_data$dataset[
          app_data$dataset[[app_data$date_column]] >= input$date_range[1] &
            app_data$dataset[[app_data$date_column]] <= input$date_range[2],
        ]
      }
    })

    shiny$observeEvent(app_data$date_column, {
      if (
        is_convertible_to_date(
          app_data$date_column,
          app_data$dataset
        )
      ) {
        output$date_range_container <- shiny$renderUI({
          shiny$req(app_data$date_column)
          dates <- na.omit(
            app_data$dataset[[app_data$date_column]]
          )
          shiny$dateRangeInput(
            inputId = ns("date_range"),
            label = app_data$date_column,
            start = min(dates),
            end = max(dates),
            min = min(dates),
            max = max(dates)
          )
        })
      } else {
        output$date_range_container <- shiny$renderUI({
          shiny$tags$p(
            glue(
              "{app_data$date_column} has no dates"
            )
          )
        })
      }
    })
  })
}
