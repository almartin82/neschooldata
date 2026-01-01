# Process school-level enrollment data

Aggregates grade-level rows into school totals and standardizes column
names. Handles three different column formats based on the data year:

- 2011+: Modern format with separate Pacific Islander and Multiracial

- 2006-2010: Legacy format with combined Asian/Pacific Islander, no
  Multiracial

- 2003-2005: Oldest format with minimal columns

## Usage

``` r
process_school_enr(df, end_year)
```

## Arguments

- df:

  Raw data frame from NDE

- end_year:

  School year end

## Value

Processed school-level data frame
