# neschooldata

<!-- badges: start -->
<!-- badges: end -->

**neschooldata** is an R package for fetching, processing, and analyzing school enrollment data from Nebraska's Department of Education. It provides a programmatic interface to public school data, enabling researchers, analysts, and education policy professionals to easily access Nebraska public school data.

## Installation

You can install the development version of neschooldata from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("almartin82/neschooldata")
```

## Quick Start

```r
library(neschooldata)

# Get 2024 enrollment data (2023-24 school year)
enr_2024 <- fetch_enr(2024)

# View state totals
enr_2024 %>%
  dplyr::filter(is_state, subgroup == "total_enrollment", grade_level == "TOTAL")

# Get wide format (demographics as columns)
enr_wide <- fetch_enr(2024, tidy = FALSE)

# Get multiple years
enr_multi <- fetch_enr_multi(2020:2024)

# Track state enrollment trends
enr_multi %>%
  dplyr::filter(is_state, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  dplyr::select(end_year, n_students)
```

## Data Availability

### Years Available

| Format Era | Years | File Format | Notes |
|------------|-------|-------------|-------|
| Current CSV | 2016-present | CSV | MembershipByGradeRaceAndGender files |

**Earliest available year**: 2016 (2015-16 school year)
**Most recent available year**: 2025 (2024-25 school year)
**Total years of data**: 10+ years

### Aggregation Levels

- **State**: Statewide totals
- **District**: ~245 public school districts
- **School (Campus)**: Individual school buildings

### Demographics Available

| Category | Available | Notes |
|----------|-----------|-------|
| Race/Ethnicity | Yes | White, Black, Hispanic, Asian, Native American, Pacific Islander, Multiracial |
| Gender | Yes | Male, Female |
| Grade Level | Yes | PK, K, 01-12 |
| Economically Disadvantaged | No | Not in membership files |
| LEP/ELL | No | Not in membership files |
| Special Education | No | Not in membership files |

### What's NOT Available

- Economically disadvantaged counts (free/reduced lunch)
- Limited English Proficient (LEP) / English Language Learner (ELL) counts
- Special education counts
- Pre-2016 data (different format not yet supported)

### Known Caveats

1. **Data Release Timing**: NDE typically releases membership data in fall/winter after the school year begins. The 2024-25 data was released in December 2024.

2. **Small Cell Suppression**: NDE masks data for groups with 10 or fewer students to protect student privacy.

3. **Grade-Level Data**: Some schools may not have all grade levels (e.g., K-8 schools won't have grades 9-12).

## ID System

Nebraska uses a county-based hierarchical ID system:

| Identifier | Format | Example | Description |
|------------|--------|---------|-------------|
| District ID | XX-XXXX | 55-0001 | County code (2 digits) + District code (4 digits) |
| School ID | XX-XXXX-XXX | 55-0001-001 | District ID + School code (3 digits) |

**Notable Districts**:
- 55-0001: Lincoln Public Schools (Lancaster County)
- 28-0001: Omaha Public Schools (Douglas County)
- 28-0010: Westside Community Schools (Douglas County)
- 54-0001: Kearney Public Schools (Kearney County)

## Output Schema

### Wide Format (`tidy = FALSE`)

| Column | Type | Description |
|--------|------|-------------|
| end_year | integer | School year end (2024 = 2023-24 school year) |
| district_id | character | County-District code (e.g., "55-0001") |
| campus_id | character | County-District-School code (NA for district rows) |
| district_name | character | District name |
| campus_name | character | School name (NA for district rows) |
| county | character | County name |
| type | character | "State", "District", or "Campus" |
| row_total | integer | Total enrollment |
| white | integer | White student count |
| black | integer | Black/African American student count |
| hispanic | integer | Hispanic/Latino student count |
| asian | integer | Asian student count |
| native_american | integer | American Indian/Alaska Native count |
| pacific_islander | integer | Native Hawaiian/Pacific Islander count |
| multiracial | integer | Two or more races count |
| female | integer | Female student count |
| male | integer | Male student count |
| grade_pk | integer | Pre-K enrollment |
| grade_k | integer | Kindergarten enrollment |
| grade_01 - grade_12 | integer | Grade-level enrollment |

### Tidy Format (`tidy = TRUE`, default)

| Column | Type | Description |
|--------|------|-------------|
| end_year | integer | School year end |
| district_id | character | District identifier |
| campus_id | character | School identifier |
| district_name | character | District name |
| campus_name | character | School name |
| county | character | County name |
| type | character | Aggregation level |
| grade_level | character | "TOTAL", "PK", "K", "01"-"12" |
| subgroup | character | "total_enrollment", "white", "black", "hispanic", "asian", "native_american", "pacific_islander", "multiracial", "female", "male" |
| n_students | integer | Student count |
| pct | numeric | Percentage of total (0-1 scale) |
| is_state | logical | TRUE if state-level aggregate |
| is_district | logical | TRUE if district-level aggregate |
| is_campus | logical | TRUE if school-level record |

## Caching

Downloaded data is cached locally to avoid repeated downloads:

```r
# View cache status
cache_status()

# Clear all cached data
clear_cache()

# Clear specific year
clear_cache(2024)

# Force fresh download
enr <- fetch_enr(2024, use_cache = FALSE)
```

Cache location: `rappdirs::user_cache_dir("neschooldata")`

## Data Source

Data is sourced from the Nebraska Department of Education's public data reports:

- **Main Portal**: https://www.education.ne.gov/dataservices/data-reports/
- **Archives**: https://www.education.ne.gov/dataservices/data-reports/data-and-information-archives/

The package downloads MembershipByGradeRaceAndGender CSV files directly from NDE's website.

## Related Packages

This package is part of a family of state school data packages:

- [txschooldata](https://github.com/almartin82/txschooldata) - Texas
- [ilschooldata](https://github.com/almartin82/ilschooldata) - Illinois
- [nyschooldata](https://github.com/almartin82/nyschooldata) - New York
- [ohschooldata](https://github.com/almartin82/ohschooldata) - Ohio
- [paschooldata](https://github.com/almartin82/paschooldata) - Pennsylvania
- [caschooldata](https://github.com/almartin82/caschooldata) - California

## License
MIT
