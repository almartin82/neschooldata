# ==============================================================================
# Raw Enrollment Data Download Functions
# ==============================================================================
#
# This file contains functions for downloading raw enrollment data from
# Nebraska Department of Education.
#
# Data comes from NDE's public data reports:
# - CSV files: 2018-present (MembershipByGradeRaceAndGender)
# - TXT files: 2003-2017 (archived historical data)
#
# Data Format Evolution:
# - 2011+: Modern format with 7 race categories (White, Black, Hispanic, Asian,
#          Native American, Pacific Islander, Multiracial)
# - 2003-2010: Legacy format with 5 race categories (White Non-Hispanic,
#              Black Non-Hispanic, Hispanic, Asian/Pacific Islander,
#              American Indian/Alaska Native)
#
# URL Patterns vary by year - see get_known_file_urls() for exact URLs
#
# File Structure (Modern 2011+):
# - DATAYEARS: School year in YYYYYYYY format (e.g., "20242025")
# - CO_DIST: County-District code (e.g., "01-0003")
# - DISTRICT_NAME: District name
# - COUNTY_NAME: County name
# - CO_DIST_SCH: County-District-School code (e.g., "01-0003-001")
# - SCHOOL_NAME: School name
# - GRADE_CODE: Grade level (PK, KN, 01-12)
# - Demographic columns: F_WH, M_WH, F_BL, M_BL, F_HI, M_HI, F_AS, M_AS,
#   F_AM, M_AM, F_PI, M_PI, F_MU, M_MU, FEMALE_TOTAL, MALE_TOTAL, TOTAL
#
# File Structure (Legacy 2003-2010):
# - CoDist/co-dist: County-District code
# - DistName/DISTNAME: District name
# - CoDistSch/AGENCYID: School ID
# - SchName/SchoolName: School name
# - Grade/grade_code: Grade level
# - FWNH, MWNH: Female/Male White Non-Hispanic
# - FBNH, MBNH: Female/Male Black Non-Hispanic
# - FH, MH: Female/Male Hispanic
# - FAPI, MAPI: Female/Male Asian/Pacific Islander
# - FAIA, MAIA: Female/Male American Indian/Alaska Native
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


#' Download NDE enrollment data file
#'
#' Downloads the MembershipByGradeRaceAndGender file from NDE's website.
#' Handles both CSV (2018+) and TXT (2003-2017) formats.
#' Tries multiple URL patterns since the upload path varies by year.
#'
#' @param end_year School year end
#' @return Data frame with raw enrollment data
#' @keywords internal
download_nde_csv <- function(end_year) {

  # Get URL patterns for this year
  url_patterns <- build_nde_url_patterns(end_year)

  if (length(url_patterns) == 0) {
    stop(paste(
      "No URL patterns available for year", end_year,
      "\nAvailable years:", paste(range(get_available_years()), collapse = "-")
    ))
  }

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


#' Build URL patterns to try for NDE enrollment file download
#'
#' NDE uploads files to different paths depending on when they're released.
#' Historical data has been archived with various naming conventions.
#' This function generates multiple URL patterns to try.
#'
#' @param end_year School year end
#' @return Character vector of URLs to try
#' @keywords internal
build_nde_url_patterns <- function(end_year) {
  base_url <- "https://www.education.ne.gov/wp-content/uploads"

  # Get known URLs for historical years (these are the exact URLs from NDE archives)
  known_urls <- get_known_file_urls()

  if (as.character(end_year) %in% names(known_urls)) {
    # Return known URLs first, then fall back to generated patterns
    urls <- known_urls[[as.character(end_year)]]
  } else {
    urls <- c()
  }

  # For recent years, also try dynamic URL patterns
  if (end_year >= 2018) {
    school_year <- format_school_year(end_year)
    filename_csv <- paste0("MembershipByGradeRaceAndGender_", school_year, ".csv")

    upload_year <- end_year - 1
    upload_year_alt <- end_year

    # Common upload months (most likely first)
    months <- c("12", "11", "10", "01", "02", "08", "09", "03")

    # Primary year patterns
    for (month in months) {
      urls <- c(urls, paste0(base_url, "/", upload_year_alt, "/", month, "/", filename_csv))
    }

    # Previous year patterns
    for (month in months) {
      urls <- c(urls, paste0(base_url, "/", upload_year, "/", month, "/", filename_csv))
    }
  }

  unique(urls)
}


#' Get known file URLs for historical years
#'
#' Returns a list of known working URLs for each historical year.
#' These URLs are extracted from NDE's data archives page.
#'
#' @return Named list of URL vectors by end_year
#' @keywords internal
get_known_file_urls <- function() {
  base_url <- "https://www.education.ne.gov/wp-content/uploads"

  list(
    # Recent years (CSV format, current column structure)
    "2026" = c(
      paste0(base_url, "/2025/12/MembershipByGradeRaceAndGender_20252026.csv")
    ),
    "2025" = c(
      paste0(base_url, "/2024/12/MembershipByGradeRaceAndGender_20242025.csv")
    ),
    "2024" = c(
      paste0(base_url, "/2023/12/MembershipByGradeRaceAndGender_20232024.csv")
    ),
    "2023" = c(
      paste0(base_url, "/2023/08/MembershipByGradeRaceAndGender_20222023.csv")
    ),
    "2022" = c(
      paste0(base_url, "/2021/12/MembershipByGradeRaceAndGender_20212022.csv")
    ),
    "2021" = c(
      paste0(base_url, "/2020/11/MembershipByGradeRaceAndGender_20202021.csv")
    ),
    "2020" = c(
      paste0(base_url, "/2019/12/MembershipByGradeRaceAndGender_20192020.csv")
    ),
    "2019" = c(
      paste0(base_url, "/2019/03/MembershipByGradeRaceAndGender_20182019.csv"),
      paste0(base_url, "/2018/11/MembershipByGradeRaceAndGender_20182019.csv")
    ),
    "2018" = c(
      paste0(base_url, "/2017/11/MembershipByGradeRaceAndGender_20172018_Export.csv")
    ),

    # Transition years (TXT format, current column structure with minor variations)
    "2017" = c(
      paste0(base_url, "/2017/07/MembershipByGradeRaceAndGender_20162017_Export.txt")
    ),
    "2016" = c(
      paste0(base_url, "/2019/01/MembershipByGradeRaceAndGender_Export_1516.txt")
    ),
    "2015" = c(
      paste0(base_url, "/2017/07/20142015_MembershipByGradeRaceAndGender_Export.txt")
    ),
    "2014" = c(
      paste0(base_url, "/2017/07/2013-14-Membership-by-Grade-Race-and-Gender.txt")
    ),
    "2013" = c(
      paste0(base_url, "/2017/07/2012-13_Membership_by-Grade_Race_and_Gender.txt")
    ),
    "2012" = c(
      paste0(base_url, "/2017/07/2011-12_Membership_by-Grade_Race_and_Gender.txt")
    ),
    "2011" = c(
      paste0(base_url, "/2017/07/2010-11_Membership_by_Grade_Race_and_Gender.txt")
    ),

    # Legacy years (TXT format, pre-2010 race categories - no Pacific Islander/Multiracial)
    "2010" = c(
      paste0(base_url, "/2017/07/2009-10_Membership_by_Grade-Race_and_Gender.txt")
    ),
    "2009" = c(
      paste0(base_url, "/2017/07/2008-09_Membership_by_Grade_Race_and_Gender.txt")
    ),
    "2008" = c(
      paste0(base_url, "/2017/07/2007-08_Membership_by_Grade-Race_and_Gender.txt")
    ),
    "2007" = c(
      paste0(base_url, "/2017/07/0607_MEMBGRADE.txt")
    ),
    "2006" = c(
      paste0(base_url, "/2017/07/0506_MEMBGRADE.txt")
    ),
    "2005" = c(
      paste0(base_url, "/2017/07/0405_MembGrade.txt")
    ),
    "2004" = c(
      paste0(base_url, "/2017/07/0304_MembGrade.txt")
    ),
    "2003" = c(
      paste0(base_url, "/2017/07/0203_MembGrade.txt")
    )
  )
}


#' Try to download enrollment data from a URL
#'
#' Handles both CSV (comma-separated) and TXT (tab-separated) files.
#'
#' @param url URL to try
#' @return Data frame if successful, NULL if failed
#' @keywords internal
try_download_csv <- function(url) {
  # Determine file extension from URL
  is_txt <- grepl("\\.txt$", url, ignore.case = TRUE)
  ext <- if (is_txt) ".txt" else ".csv"
  tname <- tempfile(fileext = ext)

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

    # Detect delimiter by checking first line
    first_line <- readLines(tname, n = 1, warn = FALSE)
    is_tab_separated <- grepl("\t", first_line)

    # Read the file with appropriate delimiter
    if (is_tab_separated) {
      df <- readr::read_tsv(
        tname,
        col_types = readr::cols(.default = readr::col_character()),
        show_col_types = FALSE
      )
    } else {
      df <- readr::read_csv(
        tname,
        col_types = readr::cols(.default = readr::col_character()),
        show_col_types = FALSE
      )
    }

    unlink(tname)

    # Validate we got actual data
    # Check for columns from any format era:
    # - Modern: DISTRICT_NAME, SCHOOL_NAME, GRADE_CODE
    # - Legacy: DISTNAME, SchoolName, grade_code
    # - Oldest: DistName, SchName, Grade
    has_valid_cols <- any(grepl("DIST|SCH|GRADE", names(df), ignore.case = TRUE))
    if (nrow(df) < 100 || !has_valid_cols) {
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
