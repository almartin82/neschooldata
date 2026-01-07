# Fetch directory data for multiple administrator types

Convenience function to fetch directory data for multiple administrator
types and combine into a single data frame.

## Usage

``` r
fetch_directory_multi(
  admin_types = c("superintendents", "elementary_principals", "middle_principals",
    "secondary_principals"),
  use_cache = TRUE
)
```

## Arguments

- admin_types:

  Vector of administrator types (e.g., c("superintendents",
  "elementary_principals"))

- use_cache:

  If TRUE (default), uses locally cached data when available.

## Value

Combined data frame with directory information for all requested types

## Examples

``` r
if (FALSE) { # \dontrun{
# Get superintendents and all principals
leadership <- fetch_directory_multi(c("superintendents", "elementary_principals",
                                      "secondary_principals"))

# Count by admin type
leadership |>
  dplyr::group_by(admin_type) |>
  dplyr::summarize(count = dplyr::n(), .groups = "drop")
} # }
```
