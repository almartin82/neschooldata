# Parse Nebraska school code

Nebraska uses CO_DIST_SCH format (county-district-school) like
"01-0003-001"

## Usage

``` r
parse_school_code(co_dist_sch)
```

## Arguments

- co_dist_sch:

  Character vector of CO_DIST_SCH codes

## Value

List with county, district, and school components
