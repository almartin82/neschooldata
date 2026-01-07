# ==============================================================================
# Directory Data Tests
# ==============================================================================

context("Directory data fetching")

# Test that URLs return HTTP 200
test_that("Directory URLs return HTTP 200", {
  skip_if_offline()

  response <- httr::HEAD(
    "https://www.education.ne.gov/wp-content/uploads/2025/12/PublicSuperintendents-2526.xlsx",
    httr::timeout(30)
  )

  expect_equal(httr::status_code(response), 200)
})


# Test that files download correctly
test_that("Can download directory Excel files", {
  skip_if_offline()

  urls <- list(
    superintendents = "https://www.education.ne.gov/wp-content/uploads/2025/12/PublicSuperintendents-2526.xlsx",
    elementary_principals = "https://www.education.ne.gov/wp-content/uploads/2025/12/PublicElementaryPrincipals-2526.xlsx"
  )

  for (type in names(urls)) {
    temp <- tempfile(fileext = ".xlsx")

    response <- httr::GET(
      urls[[type]],
      httr::write_disk(temp, overwrite = TRUE),
      httr::user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"),
      httr::timeout(120)
    )

    expect_equal(httr::status_code(response), 200)
    expect_gt(file.info(temp)$size, 1000)

    # Verify it's a valid Excel file
    sheets <- readxl::excel_sheets(temp)
    expect_true(length(sheets) > 0)

    unlink(temp)
  }
})


# Test fetch_directory function
test_that("fetch_directory returns valid data structure", {
  skip_if_offline()

  # Get all administrators
  dir_all <- fetch_directory(use_cache = FALSE)

  expect_s3_class(dir_all, "data.frame")
  expect_true(nrow(dir_all) > 0)

  # Check for required columns
  required_cols <- c("admin_type", "name", "state")
  expect_true(all(required_cols %in% names(dir_all)))

  # Check state is always NE
  expect_true(all(dir_all$state == "NE"))
})


test_that("fetch_directory can get specific admin types", {
  skip_if_offline()

  # Get only superintendents
  supts <- fetch_directory("superintendents", use_cache = FALSE)

  expect_s3_class(supts, "data.frame")
  expect_true(all(supts$admin_type == "superintendents"))
  expect_true(nrow(supts) > 0)
  expect_true(nrow(supts) < 1000)  # Nebraska has ~250 districts

  # Get elementary principals
  elem <- fetch_directory("elementary_principals", use_cache = FALSE)

  expect_s3_class(elem, "data.frame")
  expect_true(all(elem$admin_type == "elementary_principals"))
  expect_true(nrow(elem) > 0)
})


test_that("fetch_directory_multi combines multiple types", {
  skip_if_offline()

  # Get two types
  both <- fetch_directory_multi(
    c("superintendents", "elementary_principals"),
    use_cache = FALSE
  )

  expect_s3_class(both, "data.frame")
  expect_true(nrow(both) > 0)

  # Check both types are present
  expect_true("superintendents" %in% unique(both$admin_type))
  expect_true("elementary_principals" %in% unique(both$admin_type))

  # Count should be sum of individual types
  supts_only <- fetch_directory("superintendents", use_cache = FALSE)
  elem_only <- fetch_directory("elementary_principals", use_cache = FALSE)

  expect_equal(nrow(both), nrow(supts_only) + nrow(elem_only))
})


# Data quality tests
test_that("Directory data has no missing names", {
  skip_if_offline()

  dir_data <- fetch_directory(use_cache = FALSE)

  expect_false(any(is.na(dir_data$name) | dir_data$name == ""))
})


test_that("Phone numbers are cleaned properly", {
  skip_if_offline()

  dir_data <- fetch_directory(use_cache = FALSE)

  # Phone column should contain only digits (or NA)
  phones <- dir_data$phone[!is.na(dir_data$phone)]
  if (length(phones) > 0) {
    expect_true(all(grepl("^[0-9]+$", phones)))
  }
})


test_that("Email addresses have valid format", {
  skip_if_offline()

  dir_data <- fetch_directory(use_cache = FALSE)

  # Basic email validation: contains @ and domain
  emails <- dir_data$email[!is.na(dir_data$email)]
  if (length(emails) > 0) {
    expect_true(all(grepl("@", emails)))
    expect_true(all(grepl("\\.[a-zA-Z]{2,}$", emails)))
  }
})


# Known value tests (fidelity tests)
test_that("Expected number of superintendents", {
  skip_if_offline()

  # Nebraska has approximately 250 school districts
  supts <- fetch_directory("superintendents", use_cache = FALSE)

  expect_gt(nrow(supts), 200)  # At least 200 districts
  expect_lt(nrow(supts), 500)  # Less than 500 (sanity check)
})


test_that("Major districts have superintendents", {
  skip_if_offline()

  supts <- fetch_directory("superintendents", use_cache = FALSE)

  # Check for major Nebraska districts
  major_districts <- c("Omaha", "Lincoln", "Millard", "Papillion")

  for (district in major_districts) {
    expect_true(any(grepl(district, supts$district, ignore.case = TRUE)),
                 info = paste("Should have superintendent for", district))
  }
})
