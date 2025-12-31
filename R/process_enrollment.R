# ==============================================================================
# Enrollment Data Processing Functions
# ==============================================================================
#
# This file contains functions for processing raw NDE enrollment data into a
# clean, standardized format.
#
# ==============================================================================

#' Process raw NDE enrollment data
#'
#' Transforms raw NDE data into a standardized schema with school, district,
#' and state level aggregations.
#'
#' @param raw_data Data frame from get_raw_enr
#' @param end_year School year end
#' @return Processed data frame with standardized columns
#' @keywords internal
process_enr <- function(raw_data, end_year) {

  # Process school-level data
  school_processed <- process_school_enr(raw_data, end_year)

  # Create district aggregates from school data
  district_processed <- create_district_aggregate(school_processed, end_year)

  # Create state aggregate from district data
  state_processed <- create_state_aggregate(district_processed, end_year)

  # Combine all levels
  result <- dplyr::bind_rows(state_processed, district_processed, school_processed)

  result
}


#' Process school-level enrollment data
#'
#' Aggregates grade-level rows into school totals and standardizes column names.
#'
#' @param df Raw data frame from NDE
#' @param end_year School year end
#' @return Processed school-level data frame
#' @keywords internal
process_school_enr <- function(df, end_year) {

  cols <- names(df)

  # Helper to find column by pattern (case-insensitive)
  find_col <- function(patterns) {
    for (pattern in patterns) {
      matched <- grep(paste0("^", pattern, "$"), cols, value = TRUE, ignore.case = TRUE)
      if (length(matched) > 0) return(matched[1])
    }
    NULL
  }

  # Get column names
  school_id_col <- find_col(c("CO_DIST_SCH"))
  district_id_col <- find_col(c("CO_DIST"))
  school_name_col <- find_col(c("SCHOOL_NAME"))
  district_name_col <- find_col(c("DISTRICT_NAME"))
  county_col <- find_col(c("COUNTY_NAME"))
  grade_col <- find_col(c("GRADE_CODE"))

  # Demographic columns
  f_wh_col <- find_col(c("F_WH"))
  m_wh_col <- find_col(c("M_WH"))
  f_bl_col <- find_col(c("FBL", "F_BL"))
  m_bl_col <- find_col(c("M_BL"))
  f_hi_col <- find_col(c("F_HI"))
  m_hi_col <- find_col(c("M_HI"))
  f_as_col <- find_col(c("F_AS"))
  m_as_col <- find_col(c("M_AS"))
  f_am_col <- find_col(c("F_AM"))
  m_am_col <- find_col(c("M_AM"))
  f_pi_col <- find_col(c("F_PI"))
  m_pi_col <- find_col(c("M_PI"))
  f_mu_col <- find_col(c("F_MU"))
  m_mu_col <- find_col(c("M_MU"))
  female_col <- find_col(c("FEMALE_TOTAL"))
  male_col <- find_col(c("MALE_TOTAL"))
  total_col <- find_col(c("TOTAL"))

  # Convert demographics to numeric and combine by race
  df_work <- df

  # Combine male and female counts for each race
  if (!is.null(f_wh_col) && !is.null(m_wh_col)) {
    df_work$white <- safe_numeric(df[[f_wh_col]]) + safe_numeric(df[[m_wh_col]])
  }
  if (!is.null(f_bl_col) && !is.null(m_bl_col)) {
    df_work$black <- safe_numeric(df[[f_bl_col]]) + safe_numeric(df[[m_bl_col]])
  }
  if (!is.null(f_hi_col) && !is.null(m_hi_col)) {
    df_work$hispanic <- safe_numeric(df[[f_hi_col]]) + safe_numeric(df[[m_hi_col]])
  }
  if (!is.null(f_as_col) && !is.null(m_as_col)) {
    df_work$asian <- safe_numeric(df[[f_as_col]]) + safe_numeric(df[[m_as_col]])
  }
  if (!is.null(f_am_col) && !is.null(m_am_col)) {
    df_work$native_american <- safe_numeric(df[[f_am_col]]) + safe_numeric(df[[m_am_col]])
  }
  if (!is.null(f_pi_col) && !is.null(m_pi_col)) {
    df_work$pacific_islander <- safe_numeric(df[[f_pi_col]]) + safe_numeric(df[[m_pi_col]])
  }
  if (!is.null(f_mu_col) && !is.null(m_mu_col)) {
    df_work$multiracial <- safe_numeric(df[[f_mu_col]]) + safe_numeric(df[[m_mu_col]])
  }

  # Gender totals
  if (!is.null(female_col)) {
    df_work$female <- safe_numeric(df[[female_col]])
  }
  if (!is.null(male_col)) {
    df_work$male <- safe_numeric(df[[male_col]])
  }
  if (!is.null(total_col)) {
    df_work$total <- safe_numeric(df[[total_col]])
  }

  # Add identifiers
  if (!is.null(school_id_col)) {
    df_work$campus_id <- trimws(df[[school_id_col]])
  }
  if (!is.null(district_id_col)) {
    df_work$district_id <- trimws(df[[district_id_col]])
  }
  if (!is.null(school_name_col)) {
    df_work$campus_name <- trimws(df[[school_name_col]])
  }
  if (!is.null(district_name_col)) {
    df_work$district_name <- trimws(df[[district_name_col]])
  }
  if (!is.null(county_col)) {
    df_work$county <- trimws(df[[county_col]])
  }
  if (!is.null(grade_col)) {
    df_work$grade_code <- trimws(df[[grade_col]])
  }

  # Map NDE grade codes to standard format
  df_work$grade_level <- map_grade_code(df_work$grade_code)

  # Create grade-level columns for each school
  # First, aggregate to school-grade level (in case of duplicates)
  school_grade <- df_work %>%
    dplyr::group_by(campus_id, district_id, campus_name, district_name, county, grade_level) %>%
    dplyr::summarize(
      white = sum(white, na.rm = TRUE),
      black = sum(black, na.rm = TRUE),
      hispanic = sum(hispanic, na.rm = TRUE),
      asian = sum(asian, na.rm = TRUE),
      native_american = sum(native_american, na.rm = TRUE),
      pacific_islander = sum(pacific_islander, na.rm = TRUE),
      multiracial = sum(multiracial, na.rm = TRUE),
      female = sum(female, na.rm = TRUE),
      male = sum(male, na.rm = TRUE),
      total = sum(total, na.rm = TRUE),
      .groups = "drop"
    )

  # Pivot grade counts to wide format
  grade_counts <- school_grade %>%
    dplyr::select(campus_id, grade_level, total) %>%
    tidyr::pivot_wider(
      names_from = grade_level,
      values_from = total,
      names_prefix = "grade_",
      values_fill = 0
    )

  # Aggregate demographics to school level (sum across grades)
  school_totals <- school_grade %>%
    dplyr::group_by(campus_id, district_id, campus_name, district_name, county) %>%
    dplyr::summarize(
      row_total = sum(total, na.rm = TRUE),
      white = sum(white, na.rm = TRUE),
      black = sum(black, na.rm = TRUE),
      hispanic = sum(hispanic, na.rm = TRUE),
      asian = sum(asian, na.rm = TRUE),
      native_american = sum(native_american, na.rm = TRUE),
      pacific_islander = sum(pacific_islander, na.rm = TRUE),
      multiracial = sum(multiracial, na.rm = TRUE),
      female = sum(female, na.rm = TRUE),
      male = sum(male, na.rm = TRUE),
      .groups = "drop"
    )

  # Join grade counts
  result <- school_totals %>%
    dplyr::left_join(grade_counts, by = "campus_id")

  # Add metadata
  result$end_year <- end_year
  result$type <- "Campus"

  # Reorder columns
  id_cols <- c("end_year", "type", "district_id", "campus_id", "district_name", "campus_name", "county")
  demo_cols <- c("row_total", "white", "black", "hispanic", "asian",
                 "native_american", "pacific_islander", "multiracial",
                 "female", "male")
  grade_cols <- grep("^grade_", names(result), value = TRUE)

  all_cols <- c(id_cols, demo_cols, grade_cols)
  existing_cols <- all_cols[all_cols %in% names(result)]

  result <- result[, existing_cols]

  result
}


#' Map NDE grade codes to standard format
#'
#' Nebraska uses codes like PK, KN, 01-12
#'
#' @param grade_code Vector of NDE grade codes
#' @return Vector of standardized grade levels
#' @keywords internal
map_grade_code <- function(grade_code) {
  grade_map <- c(
    "PK" = "pk",
    "KN" = "k",
    "KG" = "k",
    "01" = "01",
    "02" = "02",
    "03" = "03",
    "04" = "04",
    "05" = "05",
    "06" = "06",
    "07" = "07",
    "08" = "08",
    "09" = "09",
    "10" = "10",
    "11" = "11",
    "12" = "12"
  )

  # Apply mapping, keeping original if not found
  result <- grade_map[toupper(trimws(grade_code))]
  result[is.na(result)] <- tolower(trimws(grade_code[is.na(result)]))

  result
}


#' Create district-level aggregate from school data
#'
#' @param school_df Processed school-level data frame
#' @param end_year School year end
#' @return District-level data frame
#' @keywords internal
create_district_aggregate <- function(school_df, end_year) {

  # Columns to sum
  sum_cols <- c(
    "row_total",
    "white", "black", "hispanic", "asian",
    "pacific_islander", "native_american", "multiracial",
    "female", "male"
  )

  # Grade columns
  grade_cols <- grep("^grade_", names(school_df), value = TRUE)
  sum_cols <- c(sum_cols, grade_cols)

  # Filter to columns that exist
  sum_cols <- sum_cols[sum_cols %in% names(school_df)]

  # Aggregate by district
  district_df <- school_df %>%
    dplyr::group_by(district_id, district_name, county) %>%
    dplyr::summarize(
      dplyr::across(dplyr::all_of(sum_cols), ~sum(.x, na.rm = TRUE)),
      .groups = "drop"
    )

  # Add metadata
  district_df$end_year <- end_year
  district_df$type <- "District"
  district_df$campus_id <- NA_character_
  district_df$campus_name <- NA_character_

  # Reorder columns
  id_cols <- c("end_year", "type", "district_id", "campus_id", "district_name", "campus_name", "county")
  existing_id_cols <- id_cols[id_cols %in% names(district_df)]

  district_df <- district_df[, c(existing_id_cols, sum_cols)]

  district_df
}


#' Create state-level aggregate from district data
#'
#' @param district_df Processed district data frame
#' @param end_year School year end
#' @return Single-row data frame with state totals
#' @keywords internal
create_state_aggregate <- function(district_df, end_year) {

  # Columns to sum
  sum_cols <- c(
    "row_total",
    "white", "black", "hispanic", "asian",
    "pacific_islander", "native_american", "multiracial",
    "female", "male"
  )

  # Grade columns
  grade_cols <- grep("^grade_", names(district_df), value = TRUE)
  sum_cols <- c(sum_cols, grade_cols)

  # Filter to columns that exist
  sum_cols <- sum_cols[sum_cols %in% names(district_df)]

  # Create state row
  state_row <- data.frame(
    end_year = end_year,
    type = "State",
    district_id = NA_character_,
    campus_id = NA_character_,
    district_name = NA_character_,
    campus_name = NA_character_,
    county = NA_character_,
    stringsAsFactors = FALSE
  )

  # Sum each column
  for (col in sum_cols) {
    state_row[[col]] <- sum(district_df[[col]], na.rm = TRUE)
  }

  state_row
}
