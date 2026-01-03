# Get available years for Nebraska enrollment data

Returns a vector of school year ends for which enrollment data is
available. Nebraska provides historical enrollment data from 2002-03
through present:

- 2018-present: CSV files (MembershipByGradeRaceAndGender)

- 2011-2017: TXT files with current column format

- 2003-2010: TXT files with legacy column format (pre-2010 race
  categories)

## Usage

``` r
get_available_years()
```

## Value

Integer vector of available school year ends

## Details

Note: Years 2001-2002 (end_year 2002) and earlier have different data
structures and are not currently supported.

## Examples

``` r
get_available_years()
#>  [1] 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017
#> [16] 2018 2019 2020 2021 2022 2023 2024
```
