# Get the download URL for administrator type

Constructs the download URL for Nebraska administrator contact lists.
URLs follow a pattern based on file type and update date.

## Usage

``` r
get_directory_url(admin_type = "all")
```

## Arguments

- admin_type:

  Type of administrator ("superintendents", "elementary_principals",
  "middle_principals", "secondary_principals", "all")

## Value

Character string with download URL or named list of URLs
