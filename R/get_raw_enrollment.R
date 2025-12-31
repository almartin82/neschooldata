# ==============================================================================
# Raw Enrollment Data Download Functions
# ==============================================================================
#
# This file contains functions for downloading raw enrollment data from
# Nebraska Department of Education.
#
# Data comes from NDE's public data reports:
# - CSV files: 2016-present (MembershipByGradeRaceAndGender)
#
# URL Pattern:
# https://www.education.ne.gov/wp-content/uploads/{YEAR}/{MONTH}/MembershipByGradeRaceAndGender_{YYYYYYYY}.csv
#
# File Structure:
# - DATAYEARS: School year in YYYYYYYY format (e.g., "20242025")
# - CO_DIST: County-District code (e.g., "01-0003")
# - DISTRICT_NAME: District name
# - COUNTY_NAME: County name
# - CO_DIST_SCH: County-District-School code (e.g., "01-0003-001")
# - SCHOOL_NAME: School name
# - GRADE_CODE: Grade level (PK, KN, 01-12)
# - Demographic columns: F_WH, M_WH, FBL, M_BL, F_HI, M_HI, F_AS, M_AS,
#   F_AM, M_AM, F_PI, M_PI, F_MU, M_MU, FEMALE_TOTAL, MALE_TOTAL, TOTAL
#
# ==============================================================================

#' Download raw enrollment data from NDE
#'
#' Downloads school-level enrollment data from Nebraska Department of Education's
#' public data reports.
#'
#' @param end_year School year end (2023-24 = 2024)
#' @return Data frame with raw enrollment data
#' @keywords internal
get_raw_enr <- function(end_year) {

  # Validate year
  available_years <- get_available_years()
  if (!end_year %in% available_years) {
    stop(paste("end_year must be between", min(available_years), "and", max(available_years)))
  }

  message(paste("Downloading NDE enrollment data for", end_year, "..."))

  # Download the CSV file
  df <- download_nde_csv(end_year)

  # Add end_year column
  df$end_year <- end_year

  df
}


#' Download NDE enrollment CSV file
#'
#' Downloads the MembershipByGradeRaceAndGender CSV file from NDE's website.
#' Tries multiple URL patterns since the upload path varies by year.
#'
#' @param end_year School year end
#' @return Data frame with raw CSV data
#' @keywords internal
download_nde_csv <- function(end_year) {

  school_year <- format_school_year(end_year)
  filename <- paste0("MembershipByGradeRaceAndGender_", school_year, ".csv")

  # Try different URL patterns - NDE uploads vary by year and month
  # Pattern: /wp-content/uploads/{YYYY}/{MM}/filename.csv
  url_patterns <- build_nde_url_patterns(end_year, filename)

  # Try each URL pattern until one works
  df <- NULL
  successful_url <- NULL

  for (url in url_patterns) {
    result <- try_download_csv(url)
    if (!is.null(result)) {
      df <- result
      successful_url <- url
      break
    }
  }

  if (is.null(df)) {
    stop(paste(
      "Failed to download enrollment data for year", end_year,
      "\nTried URLs:",
      paste(url_patterns[1:min(3, length(url_patterns))], collapse = "\n  "),
      "\n\nThe data may not yet be available or the URL pattern has changed.",
      "\nCheck https://www.education.ne.gov/dataservices/data-reports/ for current data."
    ))
  }

  message(paste("  Downloaded from:", successful_url))
  df
}


#' Build URL patterns to try for NDE CSV download
#'
#' NDE uploads files to different paths depending on when they're released.
#' This function generates multiple URL patterns to try.
#'
#' @param end_year School year end
#' @param filename The filename to download
#' @return Character vector of URLs to try
#' @keywords internal
build_nde_url_patterns <- function(end_year, filename) {
  base_url <- "https://www.education.ne.gov/wp-content/uploads"

  # Determine the calendar year and likely months for upload
  # Data for school year ending in YYYY is typically released in fall/winter of YYYY-1 or YYYY
  upload_year <- end_year - 1
  upload_year_alt <- end_year

  # Common upload months (most likely first)
  months <- c("12", "11", "10", "01", "02", "08", "09")

  urls <- c()

  # Primary year patterns
  for (month in months) {
    urls <- c(urls, paste0(base_url, "/", upload_year_alt, "/", month, "/", filename))
  }

  # Previous year patterns
  for (month in months) {
    urls <- c(urls, paste0(base_url, "/", upload_year, "/", month, "/", filename))
  }

  # Year before that (for older historical data)
  if (end_year < 2022) {
    for (month in months) {
      urls <- c(urls, paste0(base_url, "/", upload_year - 1, "/", month, "/", filename))
    }
  }

  # Also try 2017/07 path for oldest files
  if (end_year <= 2017) {
    urls <- c(urls, paste0(base_url, "/2017/07/", filename))
  }

  unique(urls)
}


#' Try to download CSV from a URL
#'
#' @param url URL to try
#' @return Data frame if successful, NULL if failed
#' @keywords internal
try_download_csv <- function(url) {
  tname <- tempfile(fileext = ".csv")

  tryCatch({
    response <- httr::GET(
      url,
      httr::write_disk(tname, overwrite = TRUE),
      httr::timeout(120)
    )

    # Check for HTTP errors
    if (httr::http_error(response)) {
      unlink(tname)
      return(NULL)
    }

    # Check file size (very small files are likely error pages)
    file_info <- file.info(tname)
    if (file_info$size < 1000) {
      content <- readLines(tname, n = 5, warn = FALSE)
      if (any(grepl("error|not found|404|<!DOCTYPE|<html", content, ignore.case = TRUE))) {
        unlink(tname)
        return(NULL)
      }
    }

    # Try to read the CSV
    df <- readr::read_csv(
      tname,
      col_types = readr::cols(.default = readr::col_character()),
      show_col_types = FALSE
    )

    unlink(tname)

    # Validate we got actual data
    if (nrow(df) < 100 || !any(grepl("DISTRICT|SCHOOL|GRADE", names(df), ignore.case = TRUE))) {
      return(NULL)
    }

    df

  }, error = function(e) {
    if (file.exists(tname)) unlink(tname)
    NULL
  })
}


#' Get column mapping for NDE data
#'
#' Returns a list mapping NDE column names to standardized names.
#'
#' @return Named list of column mappings
#' @keywords internal
get_nde_column_map <- function() {
  list(
    # Identifiers
    data_year = "DATAYEARS",
    district_id = "CO_DIST",
    district_name = "DISTRICT_NAME",
    county_name = "COUNTY_NAME",
    class_code = "CLASS_CODE",
    district_type = "DISTRICT_TYPE_CODE",
    school_id = "CO_DIST_SCH",
    county_code = "COUNTY",
    district_code = "DISTRICT",
    school_code = "SCHOOL",
    school_name = "SCHOOL_NAME",
    grade_code = "GRADE_CODE",

    # Demographics by gender and race
    female_white = "F_WH",
    male_white = "M_WH",
    female_black = "FBL",
    male_black = "M_BL",
    female_hispanic = "F_HI",
    male_hispanic = "M_HI",
    female_asian = "F_AS",
    male_asian = "M_AS",
    female_native_american = "F_AM",
    male_native_american = "M_AM",
    female_pacific_islander = "F_PI",
    male_pacific_islander = "M_PI",
    female_multiracial = "F_MU",
    male_multiracial = "M_MU",

    # Totals
    female_total = "FEMALE_TOTAL",
    male_total = "MALE_TOTAL",
    total = "TOTAL"
  )
}
