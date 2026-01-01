# neschooldata: Fetch and Process Nebraska School Data

Downloads and processes school data from the Nebraska Department of
Education. Provides functions for fetching enrollment data from NDE's
public data reports and transforming it into tidy format for analysis.

## Main functions

- [`fetch_enr`](https://almartin82.github.io/neschooldata/reference/fetch_enr.md):

  Fetch enrollment data for a school year

- [`fetch_enr_multi`](https://almartin82.github.io/neschooldata/reference/fetch_enr_multi.md):

  Fetch enrollment data for multiple years

- [`tidy_enr`](https://almartin82.github.io/neschooldata/reference/tidy_enr.md):

  Transform wide data to tidy (long) format

- [`id_enr_aggs`](https://almartin82.github.io/neschooldata/reference/id_enr_aggs.md):

  Add aggregation level flags

- [`enr_grade_aggs`](https://almartin82.github.io/neschooldata/reference/enr_grade_aggs.md):

  Create grade-level aggregations

- [`get_available_years`](https://almartin82.github.io/neschooldata/reference/get_available_years.md):

  Get list of available data years

## Cache functions

- [`cache_status`](https://almartin82.github.io/neschooldata/reference/cache_status.md):

  View cached data files

- [`clear_cache`](https://almartin82.github.io/neschooldata/reference/clear_cache.md):

  Remove cached data files

## ID System

Nebraska uses a hierarchical ID system with county-based codes:

- District IDs: County-District format (e.g., "55-0001" = Lincoln Public
  Schools)

- School IDs: County-District-School format (e.g., "55-0001-001")

- County codes: 2 digits (01-93)

- District codes: 4 digits

- School codes: 3 digits

## Data Sources

Data is sourced from Nebraska Department of Education's public reports:

- Data Reports:
  <https://www.education.ne.gov/dataservices/data-reports/>

- Archives:
  <https://www.education.ne.gov/dataservices/data-reports/data-and-information-archives/>

## Data Availability

- Years: 2003-present (2002-03 school year onwards)

- Aggregation levels: State, District, School (Campus)

- Demographics: White, Black, Hispanic, Asian, Native American, Pacific
  Islander, Multiracial

- Gender: Male, Female

- Grade levels: PK, K, 01-12

## Historical Data Notes

- For years 2003-2010: Pacific Islander is included in Asian,
  Multiracial not available

- For years 2003-2005: Limited metadata (no county information)

## Known Limitations

- No economically disadvantaged, LEP, or special education data in
  membership files

- Pre-2003 data has different file formats (not yet supported)

## See also

Useful links:

- <https://github.com/almartin82/neschooldata>

- Report bugs at <https://github.com/almartin82/neschooldata/issues>

## Author

**Maintainer**: Al Martin <almartin@example.com>
