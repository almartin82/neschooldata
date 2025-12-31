# ==============================================================================
# Utility Functions
# ==============================================================================

#' Pipe operator
#'
#' See \code{dplyr::\link[dplyr:reexports]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom dplyr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL


#' Convert to numeric, handling suppression markers
#'
#' NDE uses various markers for suppressed data (*, <5, -1, etc.)
#' and may use commas in large numbers.
#'
#' @param x Vector to convert
#' @return Numeric vector with NA for non-numeric values
#' @keywords internal
safe_numeric <- function(x) {
  # Remove commas and whitespace
  x <- gsub(",", "", x)
  x <- trimws(x)

  # Handle common suppression markers
  x[x %in% c("*", ".", "-", "-1", "<5", "<10", "N/A", "NA", "", "NULL")] <- NA_character_

  suppressWarnings(as.numeric(x))
}


#' Get available years for Nebraska enrollment data
#'
#' Returns a vector of school year ends for which enrollment data is available.
#' Nebraska provides historical enrollment data from 2002-03 through present:
#' - 2018-present: CSV files (MembershipByGradeRaceAndGender)
#' - 2011-2017: TXT files with current column format
#' - 2003-2010: TXT files with legacy column format (pre-2010 race categories)
#'
#' Note: Years 2001-2002 (end_year 2002) and earlier have different data structures
#' and are not currently supported.
#'
#' @return Integer vector of available school year ends
#' @export
#' @examples
#' get_available_years()
get_available_years <- function() {
  # Nebraska has data from 2002-03 school year to present
  # The current year updates in December
  current_year <- as.integer(format(Sys.Date(), "%Y"))
  current_month <- as.integer(format(Sys.Date(), "%m"))

  # If we're past December, the current school year data should be available
  if (current_month >= 12) {
    max_year <- current_year + 1
  } else if (current_month >= 9) {
    # School year started but data not yet released
    max_year <- current_year
  } else {
    max_year <- current_year
  }

  # Return range from earliest available to most recent
  # 2003 = 2002-03 school year (earliest with consistent format)
  2003:max_year
}


#' Format school year string
#'
#' Converts end year to school year string format (e.g., 2024 -> "20232024")
#'
#' @param end_year School year end
#' @return Character string in YYYYYYYY format
#' @keywords internal
format_school_year <- function(end_year) {
  paste0(end_year - 1, end_year)
}


#' Parse Nebraska district code
#'
#' Nebraska uses CO_DIST format (county-district) like "01-0003"
#'
#' @param co_dist Character vector of CO_DIST codes
#' @return List with county and district components
#' @keywords internal
parse_district_code <- function(co_dist) {
  parts <- strsplit(co_dist, "-")
  list(
    county_code = sapply(parts, function(x) if(length(x) >= 1) x[1] else NA_character_),
    district_code = sapply(parts, function(x) if(length(x) >= 2) x[2] else NA_character_)
  )
}


#' Parse Nebraska school code
#'
#' Nebraska uses CO_DIST_SCH format (county-district-school) like "01-0003-001"
#'
#' @param co_dist_sch Character vector of CO_DIST_SCH codes
#' @return List with county, district, and school components
#' @keywords internal
parse_school_code <- function(co_dist_sch) {
  parts <- strsplit(co_dist_sch, "-")
  list(
    county_code = sapply(parts, function(x) if(length(x) >= 1) x[1] else NA_character_),
    district_code = sapply(parts, function(x) if(length(x) >= 2) x[2] else NA_character_),
    school_code = sapply(parts, function(x) if(length(x) >= 3) x[3] else NA_character_)
  )
}
