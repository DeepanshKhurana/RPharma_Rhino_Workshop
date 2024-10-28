box::use(
  testthat[
    describe,
    expect_false,
    expect_true,
    test_that
  ],
)

box::use(
  app/logic/general_utils[
    is_convertible_to_date
  ],
)

describe("is_convertible_to_date", {

  test_that("it returns FALSE for a non-date column", {
    expect_false(
      is_convertible_to_date(
        "mpg",
        mtcars
      )
    )
  })

  test_that("it returns TRUE for a date column", {
    expect_true(
      is_convertible_to_date(
        "date",
        data.frame(
          date = as.Date("2021-01-01")
        )
      )
    )
  })

  test_that("it returns true for dates in different formats", {
    expect_true(
      is_convertible_to_date(
        "date",
        data.frame(
          date = c(
            "01-01-2021",
            "02-01-2021",
            "03-01-2021"
          )
        ),
        format = "%d-%m-%Y"
      )
    )
  })

})
