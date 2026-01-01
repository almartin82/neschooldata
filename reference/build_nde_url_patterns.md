# Build URL patterns to try for NDE enrollment file download

NDE uploads files to different paths depending on when they're released.
Historical data has been archived with various naming conventions. This
function generates multiple URL patterns to try.

## Usage

``` r
build_nde_url_patterns(end_year)
```

## Arguments

- end_year:

  School year end

## Value

Character vector of URLs to try
