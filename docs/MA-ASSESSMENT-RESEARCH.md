# Massachusetts Assessment Data Research

**Last Updated:** 2026-01-11
**Theme Researched:** MCAS Assessment Data (K-8 and High School)
**Status:** Ready for Implementation

---

## Data Sources Found

### Source 1: MCAS Achievement Results (Primary - Recommended)

**Dataset Information:**
- **Dataset ID:** `i9w6-niyt`
- **URL:** https://educationtocareer.data.mass.gov/Assessment-and-Accountability/MCAS-Achievement-Results/i9w6-niyt
- **API Endpoint:** `https://educationtocareer.data.mass.gov/resource/i9w6-niyt.json`
- **HTTP Status:** 200 OK (verified 2026-01-11)
- **Format:** Socrata API (JSON)
- **Access:** Direct API access, no authentication required
- **Last Modified:** 2025-09-29

**Years Available:** 2017-2025 (8 years, excluding 2020 due to COVID)
- 2017, 2018, 2019 (pre-pandemic baseline)
- 2020: No data (COVID pandemic - tests cancelled)
- 2021, 2022, 2023, 2024, 2025 (post-pandemic recovery)

**Record Count:** ~400,000+ records across all years
- State, district, and school-level data
- All grades and subjects
- All student subgroups

**Data Coverage:**
- **Grades:** 3, 4, 5, 6, 7, 8 (K-8), plus high school
- **High School:** Grade 10 and "HS SCI" (high school science: Biology, Physics, Intro Physics)
- **Aggregated:** "ALL (03-08)" for grades 3-8 combined

---

## Schema Analysis

### Column Names (Consistent Across All Years)

| API Field | Description | Type | Notes |
|-----------|-------------|------|-------|
| `sy` | School year (end year) | text | e.g., "2025" for 2024-25 school year |
| `dist_code` | District code (8 digits) | text | e.g., "00350000" for Boston |
| `dist_name` | District name | text | |
| `org_code` | Organization code (8 digits) | text | Same as dist_code for districts |
| `org_name` | Organization name | text | District or school name |
| `org_type` | Organization type | text | "State", "Public School District", "School" |
| `test_grade` | Test grade level | text | "03", "04", "05", "06", "07", "08", "10", "HS SCI", "ALL (03-08)" |
| `subject_code` | Subject area | text | "ELA", "MATH", "SCI", "BIO", "PHY", "CIV" |
| `stu_grp` | Student group/subgroup | text | See list below |
| `m_plus_e_cnt` | Meeting + Exceeding count | number | Students meeting or exceeding expectations |
| `m_plus_e_pct` | Meeting + Exceeding percentage | number | Decimal (e.g., 0.42 = 42%) |
| `e_cnt` | Exceeding expectations count | number | |
| `e_pct` | Exceeding expectations percentage | number | |
| `m_cnt` | Meeting expectations count | number | |
| `m_pct` | Meeting expectations percentage | number | |
| `pm_cnt` | Partially meeting count | number | |
| `pm_pct` | Partially meeting percentage | number | |
| `nm_cnt` | Not meeting count | number | |
| `nm_pct` | Not meeting percentage | number | |
| `stu_cnt` | Total student count | number | |
| `stu_part_pct` | Student participation rate | number | Decimal (e.g., 0.99 = 99%) |
| `avg_scaled_score` | Average scaled score | number | Varies by subject/grade |
| `avg_sgp` | Average Student Growth Percentile | number | Only available for some years/grades |
| `avg_sgp_incl` | SGP count (included) | number | Number of students in SGP calculation |
| `ach_percentile` | Achievement percentile | number | Present in some records |
| `district_and_school` | Display name | text | Human-readable location string |

### Subject Codes by Grade

**Grades 3-8:**
- **ELA:** English Language Arts
- **MATH:** Mathematics
- **SCI:** Science (grades 5 and 8 only)
- **CIV:** Civics (grade 8 only, starting 2025?)

**High School:**
- **ELA:** English Language Arts (grade 10)
- **MATH:** Mathematics (grade 10)
- **BIO:** Biology (high school science)
- **PHY:** Physics / Intro Physics (high school science)

**Aggregated:**
- **ALL (03-08):** Combined results for grades 3-8

### Student Subgroups (25 categories)

**Demographic:**
1. All Students
2. American Indian or Alaska Native
3. Asian
4. Black or African American
5. Hispanic or Latino
6. Multi-Race, Not Hispanic or Latino
7. Native Hawaiian or Other Pacific Islander
8. White

**Gender:**
9. Female
10. Male

**Special Populations:**
11. Students with Disabilities
12. Students without Disabilities
13. English Learners
14. English Learners and Former English Learners
15. Ever English Learners
16. Former English Learners
17. Economically Disadvantaged
18. Low Income
19. Non-Low Income
20. High Needs
21. Foster Care
22. Homeless
23. Migrant
24. Military

**Program:**
25. Title I
26. Non-Title I

### Organization Types

1. **State** (`org_code = "00000000"`)
2. **Public School District** (e.g., Boston = `00350000`)
3. **School** (8-digit code)

### ID System

- **State ID:** `00000000`
- **District ID:** 8 digits, first 4 are unique district identifier (e.g., `00350000` for Boston)
- **School ID:** 8 digits (same format as district)
- **Consistent with enrollment and graduation APIs**

---

## Achievement Levels (Next Generation MCAS)

Massachusetts uses four achievement levels for MCAS:

1. **Exceeding Expectations (E):** Advanced understanding
2. **Meeting Expectations (M):** Proficient understanding
3. **Partially Meeting Expectations (PM):** Partial understanding
4. **Not Meeting Expectations (NM):** Minimal understanding

**Common aggregations:**
- **Meeting + Exceeding (M+E):** Combined proficient/advanced rate
- **Percentages are decimal** (e.g., 0.42 = 42%)

---

## Time Series Heuristics

### State-Level Achievement Rates (Expected Ranges)

**Grade 10 ELA (Meeting + Exceeding):**
- 2017-2019: ~45-50% (pre-pandemic)
- 2021: ~60% (simplified test, participation dip)
- 2022-2025: ~55-60% (recovery period)

**Grade 10 Math (Meeting + Exceeding):**
- 2017-2019: ~50-55% (pre-pandemic)
- 2021: ~45% (significant COVID impact)
- 2022-2025: ~45-50% (slower recovery than ELA)

**Grade 3-8 ELA:**
- Typically 45-55% Meeting + Exceeding
- More variation across grades 3-8

**Grade 3-8 Math:**
- Typically 40-50% Meeting + Exceeding
- COVID impact more severe in math than ELA

### Data Quality Expectations

- **Participation rates:** Should be 95%+ for state/district
- **Percentages sum check:** `m_plus_e_pct + pm_pct + nm_pct ≈ 1.0`
- **No negative values** in counts or percentages
- **Student counts** should be consistent across subjects (same cohort)

---

## Schema Changes and Notes

### Historical Context

**Next Generation MCAS (2017+):**
- New assessment framework introduced in 2017
- Different achievement levels than legacy MCAS
- Computer-based testing (most districts)

**Legacy MCAS (pre-2017):**
- Different achievement levels (Advanced, Proficient, Needs Improvement, Warning)
- Not included in this API dataset
- Historical data available via DESE request only

### Missing 2020 Data

**2020: No assessments** due to COVID-19 pandemic
- Tests cancelled spring 2020
- No data in API for 2020

### 2021 COVID Impact

**2021: Modified assessments**
- Reduced testing time
- Lower participation rates in some districts
- Achievement rates not directly comparable to pre-pandemic

### SGP (Student Growth Percentile) Availability

- **Available:** 2017-2019, 2021-2023
- **Not always present:** May be missing for some grades/years
- **Field presence:** `avg_sgp` and `avg_sgp_incl` only appear when available

---

## Verified Data Values (for Tests)

### State-Level Verification (2025)

**Grade 3 Math - All Students:**
```
sy: 2025
test_grade: 03
subject_code: MATH
stu_grp: All Students
m_plus_e_pct: 0.44
e_cnt: 6449
m_cnt: 22421
stu_cnt: 66361
avg_scaled_score: 496
```

**Grade 3 ELA - All Students:**
```
sy: 2025
test_grade: 03
subject_code: ELA
stu_grp: All Students
m_plus_e_pct: 0.42
e_cnt: 3934
m_cnt: 24233
stu_cnt: 66312
avg_scaled_score: 494
```

**Grade 8 ELA - All Students:**
```
sy: 2025
test_grade: 08
subject_code: ELA
stu_grp: All Students
m_plus_e_pct: 0.51
avg_scaled_score: 499
```

### District-Level Verification (Boston - 00350000)

**Boston Grade 5 Math - White Students (2025):**
```
dist_code: 00350000
test_grade: 05
subject_code: MATH
stu_grp: White
m_plus_e_pct: 0.60
stu_cnt: 459
avg_scaled_score: 505
```

### High School Science (2025)

**Biology - All Students:**
```
test_grade: HS SCI
subject_code: BIO
stu_grp: All Students
m_plus_e_pct: 0.39
stu_cnt: 52040
avg_scaled_score: 493
```

---

## Implementation Recommendations

### Priority: HIGH
- Assessment data is critical for education research
- API is stable and follows same pattern as enrollment/graduation
- 8 years of data provides good pre/post-COVID comparison

### Complexity: MEDIUM
- More complex than enrollment (multiple subjects, achievement levels)
- Schema is clean and consistent
- Grade/subject combinations require careful handling
- Student growth percentile (SGP) fields are conditional

### Estimated Files to Create/Modify:

1. `R/get_raw_assessment.R` - New file for API download
2. `R/process_assessment.R` - New file for data processing
3. `R/tidy_assessment.R` - New file for tidy transformation
4. `R/fetch_assessment.R` - New file with `fetch_assessment()` function
5. `tests/testthat/test-assessment-live.R` - Live pipeline tests
6. `tests/testthat/test-assessment-fidelity.R` - Fidelity tests
7. Update `R/maschooldata-package.R` with new functions
8. Update NAMESPACE and DESCRIPTION

---

## Implementation Plan

### 1. Create `get_raw_assessment_api()`

**Similar pattern to `get_raw_enr_api()`:**

```r
get_raw_assessment_api <- function(end_year, use_cache = TRUE) {

  # Construct API URL
  base_url <- "https://educationtocareer.data.mass.gov/resource/i9w6-niyt.json"
  url <- paste0(base_url, "?sy=", end_year, "&$limit=100000")

  # Download and parse JSON
  response <- httr::GET(url, httr::timeout(30))
  data <- jsonlite::fromJSON(httr::content(response, "text"))

  return(data)
}
```

### 2. Create `process_assessment()`

**Standardize column names:**
- Convert percentage strings to numeric
- Convert count strings to numeric
- Standardize `org_type` to match enrollment (State/District/School)
- Handle missing SGP fields (add as NULL if not present)

**Key transformations:**
- `sy` → `end_year` (integer)
- `test_grade` → `grade` (standardize format)
- `subject_code` → `subject` (standardize format)
- `stu_grp` → `subgroup` (match enrollment naming)
- `m_plus_e_pct`, `e_pct`, etc. → numeric

### 3. Create `tidy_assessment()`

**Pivot achievement levels to columns:**
- Keep rows for each subject/grade/subgroup
- Create columns: `exceeding_pct`, `meeting_pct`, `partially_meeting_pct`, `not_meeting_pct`
- Create columns: `exceeding_cnt`, `meeting_cnt`, `partially_meeting_cnt`, `not_meeting_cnt`
- Add `meeting_exceeding_pct` and `meeting_exceeding_cnt` aggregations

**ID columns:**
- Add `is_state`, `is_district`, `is_school` flags
- Extract 4-digit district_id from 8-digit dist_code
- Add aggregation helper columns

### 4. Create `fetch_assessment()`

**User-facing function:**

```r
fetch_assessment <- function(end_year,
                             grade = NULL,
                             subject = NULL,
                             subgroup = NULL,
                             tidy = TRUE,
                             use_cache = TRUE) {

  # Download raw data
  raw <- get_raw_assessment_api(end_year, use_cache)

  # Process
  processed <- process_assessment(raw)

  # Tidy if requested
  if (tidy) {
    processed <- tidy_assessment(processed)
  }

  # Filter if requested
  if (!is.null(grade)) {
    processed <- processed[processed$grade == grade, ]
  }

  # ... (subject, subgroup filtering)

  return(processed)
}
```

### 5. Create `fetch_assessment_multi()`

**Wrapper for multiple years:**

```r
fetch_assessment_multi <- function(years, ...) {
  purrr::map_dfr(years, ~fetch_assessment(.x, ...))
}
```

---

## Test Requirements

### Live Pipeline Tests

**1. URL Availability:**
```r
test_that("assessment API returns HTTP 200", {
  skip_if_offline()
  response <- httr::HEAD(
    "https://educationtocareer.data.mass.gov/resource/i9w6-niyt.json",
    httr::timeout(30)
  )
  expect_equal(httr::status_code(response), 200)
})
```

**2. JSON Parsing:**
```r
test_that("assessment API returns valid JSON", {
  skip_if_offline()
  response <- httr::GET(
    "https://educationtocareer.data.mass.gov/resource/i9w6-niyt.json?$limit=5",
    httr::timeout(30)
  )
  content <- httr::content(response, as = "text")
  data <- jsonlite::fromJSON(content)
  expect_true(is.data.frame(data))
  expect_gt(nrow(data), 0)
})
```

### Fidelity Tests

**State-level verification (2025):**
```r
test_that("2025 state grade 3 math matches API", {
  data <- fetch_assessment(2025)

  g3_math <- data[data$is_state &
                  data$grade == "03" &
                  data$subject == "MATH" &
                  data$subgroup == "All Students", ]

  expect_equal(g3_math$m_plus_e_pct, 0.44, tolerance = 0.001)
  expect_equal(g3_math$stu_cnt, 66361)
})
```

**District-level verification (Boston):**
```r
test_that("2025 Boston grade 5 math matches API", {
  data <- fetch_assessment(2025, tidy = FALSE)

  boston <- data[data$dist_code == "00350000" &
                 data$test_grade == "05" &
                 data$subject_code == "MATH" &
                 data$stu_grp == "White", ]

  expect_equal(boston$m_plus_e_pct, 0.60, tolerance = 0.001)
  expect_equal(boston$stu_cnt, 459)
})
```

### Data Quality Tests

**Percentage sums:**
```r
test_that("achievement percentages sum to approximately 1", {
  data <- fetch_assessment(2025, tidy = FALSE)

  data <- data %>%
    mutate(pct_sum = m_plus_e_pct + pm_pct + nm_pct)

  expect_true(all(data$pct_sum > 0.98 & data$pct_sum < 1.02, na.rm = TRUE))
})
```

**No negative values:**
```r
test_that("no negative counts or percentages", {
  data <- fetch_assessment(2025, tidy = FALSE)

  expect_true(all(data$stu_cnt >= 0, na.rm = TRUE))
  expect_true(all(data$m_plus_e_pct >= 0, na.rm = TRUE))
})
```

**Participation rates reasonable:**
```r
test_that("state participation rates are above 95%", {
  data <- fetch_assessment(2025)

  state <- data[data$is_state & data$subgroup == "All Students", ]

  expect_true(all(state$stu_part_pct >= 0.95, na.rm = TRUE))
})
```

---

## Additional Notes

### Relationship to Other Datasets

**Enrollment data:**
- Same ID system (district/school codes)
- Can join assessment to enrollment for participation rate analysis
- Subgroup definitions match enrollment

**Graduation data:**
- Assessment data feeds into graduation outcomes
- Same subgroup definitions
- Can track cohorts from grade 10 assessments to graduation

### API Rate Limits

- **Socrata default limit:** 1000 rows per request
- **Use `$limit=100000`** to get all data for a year
- **Expected rows per year:** ~50,000-70,000 (all grades, subjects, subgroups, schools)
- **Cache size:** ~5-10 MB per year uncompressed

### Cache Strategy

- Same caching approach as enrollment/graduation
- Cache by year and tidy/wide format
- Cache file naming: `assessment_YYYY.rds`

### Usage Examples

**Get statewide grade 10 results:**
```r
g10_2025 <- fetch_assessment(2025, grade = "10")
```

**Compare districts on grade 3 math:**
```r
g3_math <- fetch_assessment(2025, grade = "03", subject = "MATH")

districts <- g3_math[g3_math$is_district &
                     g3_math$subgroup == "All Students", ]

arrange(districts, desc(m_plus_e_pct))
```

**Track COVID recovery:**
```r
pre_covid <- fetch_assessment_multi(2017:2019)
post_covid <- fetch_assessment_multi(2021:2025)

# Compare state achievement rates
```

**Analyze achievement gaps:**
```r
data <- fetch_assessment(2025)

gaps <- data[data$is_state &
             data$grade == "10" &
             data$subject == "ELA", ]

# Compare by race/ethnicity
```

---

## Decision Points

### 1. Subject-Grade Combinations

**Question:** How to handle the many subject-grade combinations?

**Recommendation:**
- Keep all combinations in raw data
- Add filtering parameters to `fetch_assessment()`
- Document common combinations (e.g., grade 10 ELA/Math for high school)

### 2. Aggregated "ALL (03-08)" Rows

**Question:** Include or exclude aggregated rows?

**Recommendation:**
- Keep them in raw data
- Add flag: `is_aggregated` (TRUE/FALSE)
- Let users filter if they only want individual grades
- Default: exclude aggregated rows in tidy output

### 3. High School Science (BIO/PHY)

**Question:** How to handle high school science grade coding?

**Recommendation:**
- Keep "HS SCI" as grade level
- Use subject_code to distinguish BIO vs PHY
- Document this clearly in function documentation

### 4. Missing SGP Data

**Question:** How to handle missing `avg_sgp` fields?

**Recommendation:**
- Add columns with NA when SGP not available
- Document that SGP only available for certain years/grades
- Don't fail on missing SGP fields

### 5. Historical Data (pre-2017)

**Question:** Should we try to get legacy MCAS data?

**Recommendation:**
- **NO** for initial implementation
- Legacy MCAS used different achievement levels
- Would require separate processing logic
- Can add later if there's strong user demand
- Focus on Next Generation MCAS (2017+) for now

---

## Sources

- [MCAS Achievement Results - E2C Hub](https://educationtocareer.data.mass.gov/Assessment-and-Accountability/MCAS-Achievement-Results/i9w6-niyt)
- [MCAS Results - DESE](https://www.doe.mass.edu/mcas/results.html)
- [MCAS Data Trends - E2C Hub](https://educationtocareer.data.mass.gov/stories/s/MCAS-Data-Trends/qagd-r9iy/)
- [Massachusetts Comprehensive Assessment System - DESE](https://www.doe.mass.edu/mcas/)

---

## Summary

**READY FOR IMPLEMENTATION**

The MCAS Achievement Results dataset provides comprehensive K-8 and high school assessment data for Massachusetts:

- **8 years of data** (2017-2025, excluding 2020)
- **All grades and subjects** tested in Massachusetts
- **State, district, and school-level** data
- **25 student subgroups** for equity analysis
- **Clean, consistent schema** across all years
- **Same API pattern** as enrollment/graduation (low implementation risk)
- **Critical data** for education research and policy analysis

**Implementation effort:** MEDIUM (similar complexity to graduation data)
**User value:** HIGH (assessment data is highly requested)
**Maintenance burden:** LOW (API is stable and well-maintained)
