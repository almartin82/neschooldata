# Process raw NDE enrollment data

Transforms raw NDE data into a standardized schema with school,
district, and state level aggregations.

## Usage

``` r
process_enr(raw_data, end_year)
```

## Arguments

- raw_data:

  Data frame from get_raw_enr

- end_year:

  School year end

## Value

Processed data frame with standardized columns
