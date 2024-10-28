box::use(
  glue[
    glue
  ],
  pharmaversesdtm[
    dm #nolint
  ],
  shiny[
    actionButton,
    dateRangeInput,
    icon,
    moduleServer,
    NS,
    observeEvent,
    renderUI,
    req,
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
  tags$div(
    class = "selectors",
    uiOutput(
      ns("date_range_container")
    ),
    actionButton(
      ns("reset"),
      NULL,
      icon = icon("undo")
    )
  )
}

#' @export
server <- function(
  id,
  app_data
) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    observeEvent(input$reset, {
      app_data$filtered_dataset <- app_data$dataset
      app_data$date_column <- NULL
    })

    observeEvent(input$date_range, {
      req(app_data$date_column)
      if (is.null(input$date_range)) {
        app_data$filtered_dataset <- app_data$dataset
      } else {
        app_data$filtered_dataset <- app_data$dataset[
        app_data$dataset[[app_data$date_column]] >= input$date_range[1] &
          app_data$dataset[[app_data$date_column]] <= input$date_range[2],
      ]
      }
    })

    observeEvent(app_data$date_column, {
      if (
        is_convertible_to_date(
          app_data$date_column,
          app_data$dataset
        )
      ) {
        output$date_range_container <- renderUI({
          req(app_data$date_column)
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
        output$date_range_container <- renderUI({
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
