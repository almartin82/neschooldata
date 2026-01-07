# ==============================================================================
# Raw Directory Data Download Functions
# ==============================================================================
#
# This file contains functions for downloading raw directory data from the
# Nebraska Department of Education (NDE).
#
# Data sources:
# - Public Superintendents: Excel file updated annually
# - Public Elementary Principals: Excel file updated annually
# - Public Middle School Principals: Excel file updated annually
# - Public Secondary Principals: Excel file updated annually
#
# URL pattern: https://www.education.ne.gov/wp-content/uploads/YYYY/MM/Public*.xlsx
#
# ==============================================================================

#' Get the download URL for administrator type
#'
#' Constructs the download URL for Nebraska administrator contact lists.
#' URLs follow a pattern based on file type and update date.
#'
#' @param admin_type Type of administrator ("superintendents", "elementary_principals",
#'   "middle_principals", "secondary_principals", "all")
#' @return Character string with download URL or named list of URLs
#' @keywords internal
get_directory_url <- function(admin_type = "all") {

  base_url <- "https://www.education.ne.gov/wp-content/uploads/2025/12"

  urls <- list(
    superintendents = paste0(base_url, "/PublicSuperintendents-2526.xlsx"),
    elementary_principals = paste0(base_url, "/PublicElementaryPrincipals-2526.xlsx"),
    middle_principals = paste0(base_url, "/PublicMiddleSchoolsPrincipals-2526.xlsx"),
    secondary_principals = paste0(base_url, "/PublicSecondaryPrincipals-2526.xlsx")
  )

  if (admin_type == "all") {
    return(urls)
  }

  urls[[admin_type]]
}


#' Download raw directory data from NDE
#'
#' Downloads the Nebraska administrator contact list Excel file(s).
#'
#' @param admin_type Type of administrator ("superintendents", "elementary_principals",
#'   "middle_principals", "secondary_principals", "all")
#' @return List with raw data frames for each administrator type requested
#' @keywords internal
get_raw_directory <- function(admin_type = "all") {

  message(paste("Downloading Nebraska directory data:", admin_type, "..."))

  urls <- get_directory_url(admin_type)

  # Handle single type vs all types
  if (admin_type != "all") {
    urls <- setNames(list(urls), admin_type)
  }

  # Download each file
  results <- lapply(seq_along(urls), function(i) {
    type <- names(urls)[[i]]
    url <- urls[[i]]

    message(paste("  Downloading", type, "..."))

    # Create temp file
    temp_file <- tempfile(fileext = ".xlsx")

    # Download with proper headers
    tryCatch({
      response <- httr::GET(
        url,
        httr::write_disk(temp_file, overwrite = TRUE),
        httr::user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"),
        httr::timeout(120)
      )

      if (httr::http_error(response)) {
        stop(paste("HTTP error:", httr::status_code(response)))
      }

      # Verify file is a valid Excel file
      file_info <- file.info(temp_file)
      if (file_info$size < 1000) {
        content <- readLines(temp_file, n = 5, warn = FALSE)
        if (any(grepl("Access Denied|error|not found", content, ignore.case = TRUE))) {
          stop("Server returned an error page instead of data file")
        }
      }

      # Read Excel file
      df <- readxl::read_xlsx(temp_file)

      # Add metadata
      df$admin_type <- type
      df$data_source <- "Nebraska Department of Education"

      # Clean up temp file
      unlink(temp_file)

      message(paste("  Downloaded", nrow(df), "rows for", type))

      df

    }, error = function(e) {
      unlink(temp_file)
      stop(paste("Failed to download directory data for", type,
                 "\nError:", e$message,
                 "\nURL:", url))
    })
  })

  names(results) <- names(urls)
  results
}
