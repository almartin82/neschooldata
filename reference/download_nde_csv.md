# Download NDE enrollment data file

Downloads the MembershipByGradeRaceAndGender file from NDE's website.
Handles both CSV (2018+) and TXT (2003-2017) formats. Tries multiple URL
patterns since the upload path varies by year.

## Usage

``` r
download_nde_csv(end_year)
```

## Arguments

- end_year:

  School year end

## Value

Data frame with raw enrollment data
