# Fetch Nebraska school directory data

Downloads and processes school directory data from the Nebraska
Department of Education's administrator contact lists.

## Usage

``` r
fetch_directory(admin_type = "all", use_cache = TRUE)
```

## Arguments

- admin_type:

  Type of administrator to fetch:

  - "all" (default): All administrator types

  - "superintendents": District superintendents

  - "elementary_principals": Elementary school principals

  - "middle_principals": Middle school principals

  - "secondary_principals": High school principals

- use_cache:

  If TRUE (default), uses locally cached data when available. Set to
  FALSE to force re-download from NDE.

## Value

Data frame with directory information including:

- admin_type: Type of administrator

- name: Administrator name

- title: Job title

- district: School district name

- school: School name (if applicable)

- address: Street address

- city: City

- state: State (always "NE")

- zip: ZIP code

- phone: Phone number

- email: Email address

## Examples

``` r
if (FALSE) { # \dontrun{
# Get all administrators
directory <- fetch_directory()

# Get only superintendents
supts <- fetch_directory("superintendents")

# Get elementary school principals
elem_principals <- fetch_directory("elementary_principals")

# Filter by district
lincoln_supts <- directory |>
  dplyr::filter(admin_type == "superintendents",
               grepl("Lincoln", district, ignore.case = TRUE))

# Force fresh download
directory_fresh <- fetch_directory(use_cache = FALSE)
} # }
```
