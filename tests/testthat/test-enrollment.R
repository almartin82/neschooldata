# Tests for enrollment functions
# Note: Most tests are marked as skip_on_cran since they require network access

test_that("safe_numeric handles various inputs", {
  # Normal numbers
  expect_equal(safe_numeric("100"), 100)
  expect_equal(safe_numeric("1,234"), 1234)

  # Suppressed values
  expect_true(is.na(safe_numeric("*")))
  expect_true(is.na(safe_numeric("-1")))
  expect_true(is.na(safe_numeric("<5")))
  expect_true(is.na(safe_numeric("<10")))
  expect_true(is.na(safe_numeric("")))

  # Whitespace handling
  expect_equal(safe_numeric("  100  "), 100)
})

test_that("get_available_years returns valid range", {
  years <- get_available_years()

  # Should be a numeric vector
  expect_true(is.numeric(years))

  # Should include historical years from 2003-2024
  expect_true(2003 %in% years)
  expect_true(2010 %in% years)
  expect_true(2016 %in% years)
  expect_true(2024 %in% years)

  # Should start at 2003 (earliest available)
  expect_equal(min(years), 2003)

  # Should be consecutive
  expect_equal(years, seq(min(years), max(years)))
})

test_that("format_school_year formats correctly", {
  expect_equal(format_school_year(2024), "20232024")
  expect_equal(format_school_year(2016), "20152016")
  expect_equal(format_school_year(2020), "20192020")
})

test_that("fetch_enr validates year parameter", {
  expect_error(fetch_enr(2000), "end_year must be between")
  expect_error(fetch_enr(2002), "end_year must be between")  # 2003 is earliest
  expect_error(fetch_enr(2040), "end_year must be between")
})

test_that("get_cache_dir returns valid path", {
  cache_dir <- get_cache_dir()
  expect_true(is.character(cache_dir))
  expect_true(grepl("neschooldata", cache_dir))
})

test_that("cache functions work correctly", {
  # Test cache path generation
  path <- get_cache_path(2024, "tidy")
  expect_true(grepl("enr_tidy_2024.rds", path))

  # Test cache_exists returns FALSE for non-existent cache
  expect_false(cache_exists(9999, "tidy"))
})

test_that("parse_district_code parses correctly", {
  result <- parse_district_code("55-0001")
  expect_equal(result$county_code, "55")
  expect_equal(result$district_code, "0001")

  result2 <- parse_district_code("01-0003")
  expect_equal(result2$county_code, "01")
  expect_equal(result2$district_code, "0003")
})

test_that("parse_school_code parses correctly", {
  result <- parse_school_code("55-0001-001")
  expect_equal(result$county_code, "55")
  expect_equal(result$district_code, "0001")
  expect_equal(result$school_code, "001")
})

test_that("map_grade_code maps correctly", {
  expect_equal(unname(map_grade_code("PK")), "pk")
  expect_equal(unname(map_grade_code("KN")), "k")
  expect_equal(unname(map_grade_code("KG")), "k")
  expect_equal(unname(map_grade_code("01")), "01")
  expect_equal(unname(map_grade_code("12")), "12")
})

test_that("build_nde_url_patterns returns valid URLs", {
  # Test modern year
  urls_2024 <- build_nde_url_patterns(2024)
  expect_true(length(urls_2024) >= 1)
  expect_true(all(grepl("^https://", urls_2024)))
  expect_true(all(grepl("education.ne.gov", urls_2024)))

  # Test legacy year
  urls_2010 <- build_nde_url_patterns(2010)
  expect_true(length(urls_2010) >= 1)
  expect_true(all(grepl("^https://", urls_2010)))

  # Test oldest format year
  urls_2005 <- build_nde_url_patterns(2005)
  expect_true(length(urls_2005) >= 1)
  expect_true(all(grepl("^https://", urls_2005)))
})

test_that("get_known_file_urls returns all years", {
  known_urls <- get_known_file_urls()

  # Should have entries for 2003-2026
  expect_true("2003" %in% names(known_urls))
  expect_true("2010" %in% names(known_urls))
  expect_true("2024" %in% names(known_urls))
  expect_true("2026" %in% names(known_urls))

  # Each entry should be a character vector
  expect_true(is.character(known_urls[["2024"]]))
  expect_true(is.character(known_urls[["2010"]]))
})

# Integration tests (require network access)
test_that("fetch_enr downloads and processes data", {
  skip_on_cran()
  skip_if_offline()

  # Use a recent year that we know exists
  result <- fetch_enr(2024, tidy = FALSE, use_cache = FALSE)

  # Check structure
  expect_true(is.data.frame(result))
  expect_true("district_id" %in% names(result))
  expect_true("campus_id" %in% names(result))
  expect_true("row_total" %in% names(result))
  expect_true("type" %in% names(result))

  # Check we have all levels
  expect_true("State" %in% result$type)
  expect_true("District" %in% result$type)
  expect_true("Campus" %in% result$type)

  # Check demographics exist
  expect_true("white" %in% names(result))
  expect_true("black" %in% names(result))
  expect_true("hispanic" %in% names(result))
  expect_true("asian" %in% names(result))

  # Check gender exists
  expect_true("female" %in% names(result))
  expect_true("male" %in% names(result))
})

test_that("fetch_enr works for older years", {
  skip_on_cran()
  skip_if_offline()

  # Test an older year (modern format)
  result <- fetch_enr(2021, tidy = FALSE, use_cache = FALSE)

  expect_true(is.data.frame(result))
  expect_true(nrow(result) > 0)
  expect_true("State" %in% result$type)
})

test_that("fetch_enr works for legacy format years (2003-2010)", {
  skip_on_cran()
  skip_if_offline()

  # Test a legacy format year
  result <- fetch_enr(2010, tidy = FALSE, use_cache = FALSE)

  expect_true(is.data.frame(result))
  expect_true(nrow(result) > 0)
  expect_true("State" %in% result$type)
  expect_true("District" %in% result$type)
  expect_true("Campus" %in% result$type)

  # Legacy format should have basic demographics
  expect_true("white" %in% names(result))
  expect_true("black" %in% names(result))
  expect_true("hispanic" %in% names(result))
  expect_true("asian" %in% names(result))  # Asian/Pacific Islander combined

  # Pacific Islander and Multiracial columns should exist
  # (values may be NA or 0 depending on the format era)
  expect_true("pacific_islander" %in% names(result))
  expect_true("multiracial" %in% names(result))

  # For Campus-level records, check that Pacific Islander and Multiracial
  # are either all NA or all 0 (not actual data)
  campus_records <- result[result$type == "Campus", ]
  pi_values <- campus_records$pacific_islander[!is.na(campus_records$pacific_islander)]
  mu_values <- campus_records$multiracial[!is.na(campus_records$multiracial)]

  # If there are non-NA values, they should all be 0
  if (length(pi_values) > 0) {
    expect_true(all(pi_values == 0))
  }
  if (length(mu_values) > 0) {
    expect_true(all(mu_values == 0))
  }
})

test_that("fetch_enr works for oldest format years (2003-2005)", {
  skip_on_cran()
  skip_if_offline()

  # Test an oldest format year
  result <- fetch_enr(2005, tidy = FALSE, use_cache = FALSE)

  expect_true(is.data.frame(result))
  expect_true(nrow(result) > 0)
  expect_true("State" %in% result$type)

  # Should have basic demographics
  expect_true("white" %in% names(result))
  expect_true("black" %in% names(result))
  expect_true("row_total" %in% names(result))
})

test_that("tidy_enr produces correct long format", {
  skip_on_cran()
  skip_if_offline()

  # Get wide data
  wide <- fetch_enr(2024, tidy = FALSE, use_cache = TRUE)

  # Tidy it
  tidy_result <- tidy_enr(wide)

  # Check structure
  expect_true("grade_level" %in% names(tidy_result))
  expect_true("subgroup" %in% names(tidy_result))
  expect_true("n_students" %in% names(tidy_result))
  expect_true("pct" %in% names(tidy_result))

  # Check subgroups include expected values
  subgroups <- unique(tidy_result$subgroup)
  expect_true("total_enrollment" %in% subgroups)
  expect_true("hispanic" %in% subgroups)
  expect_true("white" %in% subgroups)

  # Check gender subgroups
  expect_true("female" %in% subgroups)
  expect_true("male" %in% subgroups)
})

test_that("id_enr_aggs adds correct flags", {
  skip_on_cran()
  skip_if_offline()

  # Get tidy data with aggregation flags
  result <- fetch_enr(2024, tidy = TRUE, use_cache = TRUE)

  # Check flags exist
  expect_true("is_state" %in% names(result))
  expect_true("is_district" %in% names(result))
  expect_true("is_campus" %in% names(result))

  # Check flags are boolean
  expect_true(is.logical(result$is_state))
  expect_true(is.logical(result$is_district))
  expect_true(is.logical(result$is_campus))

  # Check mutual exclusivity (each row is only one type)
  type_sums <- result$is_state + result$is_district + result$is_campus
  expect_true(all(type_sums == 1))
})

test_that("state totals are reasonable", {
  skip_on_cran()
  skip_if_offline()

  result <- fetch_enr(2024, tidy = TRUE, use_cache = TRUE)

  # Get state total enrollment
  state_total <- result %>%
    dplyr::filter(is_state, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
    dplyr::pull(n_students)

  # Nebraska has roughly 320,000 K-12 students
  expect_true(state_total > 250000)
  expect_true(state_total < 400000)
})

test_that("fetch_enr_multi combines years correctly", {
  skip_on_cran()
  skip_if_offline()

  # Fetch 2 years
  result <- fetch_enr_multi(2023:2024, tidy = TRUE, use_cache = TRUE)

  # Should have both years
  expect_true(all(c(2023, 2024) %in% result$end_year))

  # Should have 2x the rows (approximately)
  single_year <- fetch_enr(2024, tidy = TRUE, use_cache = TRUE)
  expect_true(nrow(result) > nrow(single_year))
})

test_that("district IDs have correct format", {
  skip_on_cran()
  skip_if_offline()

  result <- fetch_enr(2024, tidy = FALSE, use_cache = TRUE)

  # Get district IDs (excluding state-level NA)
  district_ids <- result %>%
    dplyr::filter(type == "District") %>%
    dplyr::pull(district_id)

  # All should match CO_DIST format (XX-XXXX)
  expect_true(all(grepl("^\\d{2}-\\d{4}$", district_ids)))
})

test_that("school IDs have correct format", {
  skip_on_cran()
  skip_if_offline()

  result <- fetch_enr(2024, tidy = FALSE, use_cache = TRUE)

  # Get school IDs (excluding district/state level NA)
  school_ids <- result %>%
    dplyr::filter(type == "Campus", !is.na(campus_id)) %>%
    dplyr::pull(campus_id)

  # All should match CO_DIST_SCH format (XX-XXXX-XXX)
  expect_true(all(grepl("^\\d{2}-\\d{4}-\\d{3}$", school_ids)))
})
