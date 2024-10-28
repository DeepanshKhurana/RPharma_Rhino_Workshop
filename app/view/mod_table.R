box::use(
  dplyr[
    matches,
    mutate,
    rowwise,
    select,
    ungroup
  ],
  glue[
    glue
  ],
  reactable[
    colDef,
    getReactableState,
    reactable,
    reactableOutput,
    renderReactable
  ],
  shiny[
    div,
    icon,
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

    table_data <- reactive({
      app_data$filtered_dataset |>
        rowwise() |>
        mutate(
          STUDY = paste(
            STUDYID,
            DOMAIN,
            USUBJID,
            SITEID,
            sep = ":::"
          ),
          DEMOGRAPHIC = paste(
            AGE,
            AGEU,
            SEX,
            RACE,
            ETHNIC,
            sep = ":::"
          ),
          DRUG = paste(
            ARMCD,
            ACTARMCD,
            sep = ":::"
          )
        ) |>
        ungroup() |>
        select(
          STUDY,
          DEMOGRAPHIC,
          DRUG,
          matches("DTC$")
        )
    })

    output$table <- renderReactable({
      reactable(
        data = table_data(),
        borderless = TRUE,
        searchable = TRUE,
        # TODO: This can be converted to a separate function as well
        columns = list(
          STUDY = colDef(
            width = 150,
            cell = function(value) {
              value <- strsplit(value, ":::")[[1]]
              div(
                class = "study-info-row",
                div(
                  class = "subject-id primary-text",
                  value[3]
                ),
                div(
                  class = "study-id secondary-text",
                  glue(
                    "{value[1]} ({value[2]}) ({value[4]})"
                  )
                )
              )
            }
          ),
          DEMOGRAPHIC = colDef(
            width = 200,
            cell = function(value) {
              value <- strsplit(value, ":::")[[1]]
              div(
                class = "demographic-row",
                div(
                  class = "person-age primary-text",
                  glue(
                    "{value[1]} {value[2]}"
                  ),
                  icon(
                    class = "person-sex",
                    ifelse(
                      value[3] == "M",
                      "mars",
                      "venus"
                    )
                  )
                ),
                div(
                  class = "person-ethnicity secondary-text",
                  glue(
                    "{value[4]} ({value[5]})"
                  )
                )
              )
            }
          ),
          DRUG = colDef(
            width = 150,
            cell = function(value) {
              value <- strsplit(value, ":::")[[1]]
              div(
                class = "drug-row",
                div(
                  class = "actual-arm-code primary-text",
                  glue(
                    "ARM: {value[2]}"
                  )
                ),
                div(
                  class = "arm-code secondary-text",
                  glue(
                    "ACT: {value[1]}"
                  )
                )
              )
            }
          )
        )
      )
    })
  })
}
