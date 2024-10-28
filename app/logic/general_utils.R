#' Check if a column is a datetime column
#' @param column A column from a data frame
#' @return TRUE if the column is convertible to date, FALSE otherwise
#' @export
is_convertible_to_date <- function(column, dataset, format = "%Y-%m-%d") {
  tryCatch({
    converted <- as.Date(dataset[[column]], format)
    any(!is.na(converted))
  }, error = function(e) {
    FALSE
  })
}
