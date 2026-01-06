# ==============================================================================
# Directory Data Fetching Functions
# ==============================================================================
#
# This file contains user-facing functions for fetching Nebraska school
# directory information (principals and superintendents).
#
# ==============================================================================

#' Fetch Nebraska school directory data
#'
#' Downloads and processes school directory data from the Nebraska Department
#' of Education's administrator contact lists.
#'
#' @param admin_type Type of administrator to fetch:
#'   \itemize{
#'     \item "all" (default): All administrator types
#'     \item "superintendents": District superintendents
#'     \item "elementary_principals": Elementary school principals
#'     \item "middle_principals": Middle school principals
#'     \item "secondary_principals": High school principals
#'   }
#' @param use_cache If TRUE (default), uses locally cached data when available.
#'   Set to FALSE to force re-download from NDE.
#'
#' @return Data frame with directory information including:
#'   \itemize{
#'     \item admin_type: Type of administrator
#'     \item name: Administrator name
#'     \item title: Job title
#'     \item district: School district name
#'     \item school: School name (if applicable)
#'     \item address: Street address
#'     \item city: City
#'     \item state: State (always "NE")
#'     \item zip: ZIP code
#'     \item phone: Phone number
#'     \item email: Email address
#'   }
#'
#' @export
#' @examples
#' \dontrun{
#' # Get all administrators
#' directory <- fetch_directory()
#'
#' # Get only superintendents
#' supts <- fetch_directory("superintendents")
#'
#' # Get elementary school principals
#' elem_principals <- fetch_directory("elementary_principals")
#'
#' # Filter by district
#' lincoln_supts <- directory |>
#'   dplyr::filter(admin_type == "superintendents",
#'                grepl("Lincoln", district, ignore.case = TRUE))
#'
#' # Force fresh download
#' directory_fresh <- fetch_directory(use_cache = FALSE)
#' }
fetch_directory <- function(admin_type = "all", use_cache = TRUE) {

  # Validate admin_type
  valid_types <- c("all", "superintendents", "elementary_principals",
                   "middle_principals", "secondary_principals")
  if (!admin_type %in% valid_types) {
    stop(paste("admin_type must be one of:",
               paste(valid_types, collapse = ", ")))
  }

  # Check cache
  cache_key <- paste0("directory_", admin_type)

  if (use_cache && cache_exists(cache_key, "directory")) {
    message(paste("Using cached directory data for", admin_type))
    return(read_cache(cache_key, "directory"))
  }

  # Get raw data from NDE
  raw <- get_raw_directory(admin_type)

  # Process to standard format
  processed <- process_directory(raw)

  # Cache the result
  if (use_cache) {
    write_cache(processed, cache_key, "directory")
  }

  message(paste("Loaded", nrow(processed), "administrator records"))
  processed
}


#' Fetch directory data for multiple administrator types
#'
#' Convenience function to fetch directory data for multiple administrator
#' types and combine into a single data frame.
#'
#' @param admin_types Vector of administrator types (e.g., c("superintendents", "elementary_principals"))
#' @param use_cache If TRUE (default), uses locally cached data when available.
#' @return Combined data frame with directory information for all requested types
#'
#' @export
#' @examples
#' \dontrun{
#' # Get superintendents and all principals
#' leadership <- fetch_directory_multi(c("superintendents", "elementary_principals",
#'                                       "secondary_principals"))
#'
#' # Count by admin type
#' leadership |>
#'   dplyr::group_by(admin_type) |>
#'   dplyr::summarize(count = dplyr::n(), .groups = "drop")
#' }
fetch_directory_multi <- function(admin_types = c("superintendents",
                                                   "elementary_principals",
                                                   "middle_principals",
                                                   "secondary_principals"),
                                     use_cache = TRUE) {

  # Validate types
  valid_types <- c("superintendents", "elementary_principals",
                   "middle_principals", "secondary_principals")
  invalid_types <- admin_types[!admin_types %in% valid_types]
  if (length(invalid_types) > 0) {
    stop(paste("Invalid admin_types:", paste(invalid_types, collapse = ", "),
               "\nValid types:", paste(valid_types, collapse = ", ")))
  }

  # Fetch each type
  results <- purrr::map(
    admin_types,
    function(type) {
      message(paste("Fetching", type, "..."))
      fetch_directory(type, use_cache = use_cache)
    }
  )

  # Combine
  dplyr::bind_rows(results)
}
