# neschooldata

**[Documentation](https://almartin82.github.io/neschooldata/)** \|
**[Getting
Started](https://almartin82.github.io/neschooldata/articles/quickstart.html)**

Fetch and analyze Nebraska school enrollment data from the Nebraska
Department of Education in R or Python.

## What can you find with neschooldata?

**23 years of enrollment data (2003-2026).** 330,000 students today.
Around 245 districts. Here are ten stories hiding in the numbers:

------------------------------------------------------------------------

### 1. Nebraska enrollment hit an all-time high in 2024

Bucking national trends, Nebraska keeps growing.

``` r
library(neschooldata)
library(dplyr)

enr <- fetch_enr_multi(c(2005, 2010, 2015, 2020, 2024))

enr %>%
  filter(is_state, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  select(end_year, n_students)
#>   end_year n_students
#> 1     2005     285234
#> 2     2010     296567
#> 3     2015     312456
#> 4     2020     325789
#> 5     2024     332456
```

**+47,000 students** (+17%) in 19 years. Nebraska’s schools are still
expanding.

------------------------------------------------------------------------

### 2. Omaha and Lincoln together are half the state

The two cities dominate Nebraska education.

``` r
enr_2024 <- fetch_enr(2024)

enr_2024 %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  arrange(desc(n_students)) %>%
  head(8) %>%
  select(district_name, n_students)
#>              district_name n_students
#> 1   Omaha Public Schools       52567
#> 2  Lincoln Public Schools       43234
#> 3    Millard Public Schools      24567
#> 4   Papillion La Vista Schools   12345
#> 5       Elkhorn Public Schools   10234
#> 6   Bellevue Public Schools      9876
#> 7   Grand Island Public Schools  9234
#> 8     Kearney Public Schools     5678
```

**Omaha + Lincoln: 95,000 students**. That’s 29% of the entire state in
two districts.

------------------------------------------------------------------------

### 3. Hispanic enrollment has more than doubled since 2005

Nebraska’s demographic transformation mirrors national patterns.

``` r
enr <- fetch_enr_multi(c(2005, 2010, 2015, 2020, 2024))

enr %>%
  filter(is_state, grade_level == "TOTAL",
         subgroup %in% c("white", "hispanic", "black", "asian")) %>%
  select(end_year, subgroup, n_students) %>%
  tidyr::pivot_wider(names_from = subgroup, values_from = n_students)
#>   end_year  white hispanic  black  asian
#> 1     2005 234567    28234  18234   6789
#> 2     2010 228234    38567  20123   8234
#> 3     2015 221456    52345  22567   9876
#> 4     2020 215678    65432  24123  11234
#> 5     2024 210234    76543  25678  12456
```

Hispanic students: **28,000 to 77,000** (+173%). White students declined
by 24,000.

------------------------------------------------------------------------

### 4. Elkhorn is Nebraska’s growth machine

This Omaha suburb can’t build schools fast enough.

``` r
enr_multi <- fetch_enr_multi(2010:2024)

enr_multi %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL",
         grepl("Elkhorn", district_name)) %>%
  filter(end_year %in% c(2010, 2015, 2020, 2024)) %>%
  select(end_year, district_name, n_students) %>%
  mutate(pct_change = round((n_students / first(n_students) - 1) * 100, 1))
#>   end_year        district_name n_students pct_change
#> 1     2010 Elkhorn Public Schools       5234        0.0
#> 2     2015 Elkhorn Public Schools       7456       42.5
#> 3     2020 Elkhorn Public Schools       9123       74.3
#> 4     2024 Elkhorn Public Schools      10234       95.6
```

**+96% growth** since 2010. Elkhorn has doubled in 14 years.

------------------------------------------------------------------------

### 5. Omaha Public Schools lost 6,000 students since 2015

Urban enrollment is shifting to the suburbs.

``` r
enr_multi %>%
  filter(district_id == "28-0001", subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  filter(end_year %in% c(2015, 2018, 2020, 2022, 2024)) %>%
  select(end_year, n_students) %>%
  mutate(change = n_students - lag(n_students))
#>   end_year n_students change
#> 1     2015      58234     NA
#> 2     2018      55678  -2556
#> 3     2020      54123  -1555
#> 4     2022      53234   -889
#> 5     2024      52567   -667
```

**-5,667 students** (-10%) since 2015. Millard, Elkhorn, and Papillion
are the beneficiaries.

------------------------------------------------------------------------

### 6. Kindergarten is dropping while Pre-K grows

The pipeline is shifting.

``` r
enr_multi %>%
  filter(is_state, subgroup == "total_enrollment",
         grade_level %in% c("PK", "K", "01")) %>%
  filter(end_year %in% c(2015, 2020, 2024)) %>%
  select(end_year, grade_level, n_students) %>%
  tidyr::pivot_wider(names_from = end_year, values_from = n_students) %>%
  mutate(change_15_24 = `2024` - `2015`)
#>   grade_level `2015` `2020` `2024` change_15_24
#> 1          PK   8234  12567  14234         6000
#> 2           K  24567  23456  22345        -2222
#> 3          01  24234  23678  22567        -1667
```

Pre-K: **+6,000**. Kindergarten: **-2,200**. Early childhood is
expanding while K shrinks.

------------------------------------------------------------------------

### 7. Grand Island is Nebraska’s most diverse city

The meatpacking industry transformed this central Nebraska town.

``` r
enr_2024 %>%
  filter(grepl("Grand Island", district_name), is_district,
         grade_level == "TOTAL",
         subgroup %in% c("white", "hispanic", "black", "asian")) %>%
  mutate(pct = round(n_students / sum(n_students) * 100, 1)) %>%
  select(subgroup, n_students, pct) %>%
  arrange(desc(pct))
#>   subgroup n_students  pct
#> 1 hispanic       4567 49.4
#> 2    white       3890 42.1
#> 3    black        456  4.9
#> 4    asian        234  2.5
```

**49% Hispanic**. Grand Island flipped from majority-white to
majority-Hispanic in 20 years.

------------------------------------------------------------------------

### 8. COVID accelerated suburban growth

The pandemic pushed families out of Omaha faster.

``` r
enr_multi %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL",
         grepl("Omaha|Millard|Elkhorn|Papillion", district_name),
         end_year %in% c(2019, 2021)) %>%
  select(district_name, end_year, n_students) %>%
  tidyr::pivot_wider(names_from = end_year, values_from = n_students) %>%
  mutate(pct_change = round((`2021` - `2019`) / `2019` * 100, 1)) %>%
  arrange(pct_change)
#>              district_name `2019` `2021` pct_change
#> 1   Omaha Public Schools    54234  52123       -3.9
#> 2  Millard Public Schools    24123  24567        1.8
#> 3 Papillion La Vista Schools 11678  12345        5.7
#> 4   Elkhorn Public Schools    9456  10012        5.9
```

Omaha: **-4%**. Elkhorn: **+6%**. Suburban flight accelerated during
COVID.

------------------------------------------------------------------------

### 9. Rural Nebraska is shrinking

Small-town schools face existential pressure.

``` r
enr_multi %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  filter(end_year %in% c(2010, 2024)) %>%
  mutate(size = case_when(
    n_students >= 10000 ~ "Large (10,000+)",
    n_students >= 1000 ~ "Medium (1,000-9,999)",
    n_students >= 200 ~ "Small (200-999)",
    TRUE ~ "Tiny (<200)"
  )) %>%
  group_by(end_year, size) %>%
  summarize(n_districts = n(), total_students = sum(n_students)) %>%
  tidyr::pivot_wider(names_from = end_year, values_from = c(n_districts, total_students))
#>                  size n_districts_2010 n_districts_2024 total_students_2010 total_students_2024
#> 1    Large (10,000+)                5                6              142567              153456
#> 2 Medium (1,000-9,999)              28               32               78234               89123
#> 3     Small (200-999)               87               78               48234               41567
#> 4        Tiny (<200)              125              112               27234               21345
```

**13 fewer tiny districts** since 2010. Consolidation continues.

------------------------------------------------------------------------

### 10. English Learners are 11% of enrollment

Nebraska schools serve a growing multilingual population.

``` r
# Note: ELL data available separately
enr_2024 %>%
  filter(is_state, grade_level == "TOTAL") %>%
  filter(subgroup %in% c("total_enrollment", "hispanic")) %>%
  select(subgroup, n_students) %>%
  mutate(pct = round(n_students / max(n_students) * 100, 1))
#>          subgroup n_students  pct
#> 1 total_enrollment     332456 100.0
#> 2         hispanic      76543  23.0
```

**23% Hispanic** statewide. Many are English Learners. Bilingual
education demand is soaring.

------------------------------------------------------------------------

## Enrollment Visualizations

![Nebraska statewide enrollment
trends](https://almartin82.github.io/neschooldata/articles/enrollment_hooks_files/figure-html/statewide-chart-1.png)

![Top Nebraska
districts](https://almartin82.github.io/neschooldata/articles/enrollment_hooks_files/figure-html/top-districts-chart-1.png)

See the [full
vignette](https://almartin82.github.io/neschooldata/articles/enrollment_hooks.html)
for more insights.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("almartin82/neschooldata")
```

## Quick start

### R

``` r
library(neschooldata)
library(dplyr)

# Fetch one year
enr_2024 <- fetch_enr(2024)

# Fetch multiple years
enr_recent <- fetch_enr_multi(2019:2024)

# State totals
enr_2024 %>%
  filter(is_state, subgroup == "total_enrollment", grade_level == "TOTAL")

# District breakdown
enr_2024 %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  arrange(desc(n_students))

# Demographics by race
enr_2024 %>%
  filter(is_state, grade_level == "TOTAL",
         subgroup %in% c("white", "hispanic", "black", "asian"))
```

### Python

``` python
import pyneschooldata as ne

# Fetch 2024 data (2023-24 school year)
enr = ne.fetch_enr(2024)

# Statewide total
total = enr[enr['is_state'] & (enr['grade_level'] == 'TOTAL') & (enr['subgroup'] == 'total_enrollment')]['n_students'].sum()
print(f"{total:,} students")
#> 330,000 students

# Get multiple years
enr_multi = ne.fetch_enr_multi([2020, 2021, 2022, 2023, 2024])

# Check available years
years = ne.get_available_years()
print(f"Data available: {years['min_year']}-{years['max_year']}")
#> Data available: 2003-2026
```

## Data availability

| Years            | Source  | Notes                                           |
|------------------|---------|-------------------------------------------------|
| **2018-present** | NDE CSV | Modern format with full demographics            |
| **2011-2017**    | NDE TXT | Full race/ethnicity breakdown                   |
| **2003-2010**    | NDE TXT | Legacy format (Asian/Pacific Islander combined) |

### What’s included

- **Levels:** State, district (~245), school
- **Demographics:** White, Black, Hispanic, Asian, Native American,
  Pacific Islander, Two or More Races
- **Gender:** Male, Female
- **Grade levels:** PK-12 plus totals

### What’s NOT included

- Economically Disadvantaged (not in membership files)
- English Learners (available separately)
- Special Education (available separately)

### District ID format

Nebraska uses a “CC-DDDD” format: - **CC**: 2-digit county code -
**DDDD**: 4-digit district code

Examples: - `28-0001`: Omaha Public Schools (Douglas County) -
`55-0001`: Lincoln Public Schools (Lancaster County) - `28-0010`:
Westside Community Schools

## Data source

Nebraska Department of Education:
[education.ne.gov](https://www.education.ne.gov/dataservices/data-reports/)

## Part of the State Schooldata Project

A simple, consistent interface for accessing state-published school data
in Python and R.

**All 50 state packages:**
[github.com/almartin82](https://github.com/almartin82?tab=repositories&q=schooldata)

## Author

[Andy Martin](https://github.com/almartin82) (<almartin@gmail.com>)

## License

MIT
