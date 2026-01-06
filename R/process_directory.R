# ==============================================================================
# Directory Data Processing Functions
# ==============================================================================
#
# This file contains functions for processing raw directory data from the
# Nebraska Department of Education (NDE) into a standard format.
#
# ==============================================================================

#' Process raw directory data
#'
#' Processes the raw administrator contact list data into a standardized format.
#'
#' @param raw_data List of raw data frames from get_raw_directory()
#' @return Data frame with standardized columns
#' @keywords internal
process_directory <- function(raw_data) {

  # Process each admin type and combine
  processed <- lapply(names(raw_data), function(type) {
    df <- raw_data[[type]]

    # Standardize column names (convert to lowercase)
    names(df) <- tolower(names(df))

    # Create a result data frame with all required columns initialized from df
    n_rows <- nrow(df)
    result <- data.frame(
      admin_type = rep(type, n_rows),
      name = NA_character_,
      title = NA_character_,
      district = NA_character_,
      school = NA_character_,
      address = NA_character_,
      city = NA_character_,
      state = rep("NE", n_rows),
      zip = NA_character_,
      phone = NA_character_,
      email = NA_character_,
      stringsAsFactors = FALSE
    )

    # Map columns based on what exists in the data
    # Common column name patterns (Nebraska NDE format)
    col_map <- list(
      title = c("title", "jobtitle", "job_title", "position"),
      district = c("district", "district name", "lea", "school district", "company"),
      school = c("school", "school name", "building", "building name"),
      address = c("address", "street", "mailing address"),
      city = c("city", "mailing city"),
      zip = c("zip", "zip code", "postal"),
      phone = c("phone", "telephone", "work phone", "contact", "businessphone", "business_phone"),
      email = c("email", "email address", "e-mail", "work email", "emailaddress", "email_address")
    )

    # Special handling for name (combine first and last name if separate)
    if ("firstname" %in% names(df) && "lastname" %in% names(df)) {
      result$name <- paste(df$firstname, df$lastname)
    }

    # Map other columns
    for (std_col in names(col_map)) {
      for (pattern in col_map[[std_col]]) {
        matched <- grep(pattern, names(df), ignore.case = TRUE)
        if (length(matched) > 0) {
          result[[std_col]] <- as.character(df[[matched[1]]])
          break
        }
      }
    }

    # Remove rows with missing name (essential field)
    if ("name" %in% names(result)) {
      result <- result[!is.na(result$name) & result$name != "", , drop = FALSE]
    }

    # Clean up phone numbers (remove common formatting)
    if ("phone" %in% names(result)) {
      result$phone <- gsub("[^0-9]", "", result$phone)
    }

    # Convert to tibble
    tibble::as_tibble(result)
  })

  # Combine all admin types
  combined <- dplyr::bind_rows(processed)

  # Select only columns that exist
  available_cols <- intersect(c("admin_type", "name", "title", "district", "school",
                               "address", "city", "state", "zip", "phone", "email"),
                             names(combined))

  combined <- combined[, available_cols, drop = FALSE]

  combined
}
