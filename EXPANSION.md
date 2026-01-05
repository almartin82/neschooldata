# Nebraska School Data Expansion Research

**Last Updated:** 2026-01-04
**Theme Researched:** Graduation Rates

## Executive Summary

**STATUS: NOT FEASIBLE FOR AUTOMATED DOWNLOAD**

Nebraska graduation rate data is NOT available through direct file downloads like enrollment data. The graduation data is only accessible through:
1. **Nebraska Education Profile (NEP)** - A JavaScript-based web portal with no public API
2. **NEP Secure** - Requires authentication via NDE Portal with activation codes from district administrators

This is fundamentally different from enrollment data, which Nebraska provides via direct CSV/TXT file downloads.

## Current Package Capabilities

The `neschooldata` package currently supports:
- **Enrollment data**: 2003-2024 (22 years)
- **Source**: Direct CSV/TXT file downloads from NDE
- **Data types**: Membership by grade, race, and gender

## Data Sources Investigated

### 1. Nebraska Department of Education - Data Reports Page
- **URL**: https://www.education.ne.gov/dataservices/data-reports/
- **HTTP Status**: 200 OK
- **Graduation Data**: NOT AVAILABLE

Available data files (NOT graduation):
| Data Type | Format | Years |
|-----------|--------|-------|
| Membership by Grade/Race/Gender | CSV, TXT | 2003-2026 |
| County Membership by Grade | CSV, TXT | 2003-2026 |
| Free/Reduced Lunch | XLS, XLSX | 2007-2026 |
| Student Absences by District | XLSX | 2018-2025 |

**Finding**: No graduation rate files are publicly posted on the data reports page.

### 2. Nebraska Education Profile (NEP)
- **URL**: https://nep.education.ne.gov/
- **HTTP Status**: 200 OK (returns JavaScript app)
- **Format**: Angular-based single-page application
- **API**: No public API discovered
- **Graduation Data**: Available through web interface only

**Finding**: The NEP is a JavaScript-rendered application. Standard web scraping will not work. The application loads data dynamically via AJAX calls, but no public API endpoints were documented or discovered.

### 3. NEP Secure (Authenticated Portal)
- **URL**: https://portal.education.ne.gov/
- **Access**: Requires NDE Portal account with activation code from district administrator
- **Data Available**: 2023-2024 Assessment, Cohort Graduation and Dropout data
- **Status**: Embargoed until public release each November

**Finding**: This is the primary source for school-level graduation data but requires institutional authentication.

### 4. AQuESTT Website
- **URL**: https://aquestt.com/
- **HTTP Status**: 200 OK
- **Format**: PDF documents only

Available files (all PDF):
- 2024 AQuESTT Classification Rules
- 2023 AQuESTT Classification Rules
- 2022 AQuESTT Classification Rules
- Various classification explanation documents

**Finding**: No raw data files. Only methodology documentation in PDF format.

### 5. CCPE (Coordinating Commission for Postsecondary Education)
- **URL**: https://ccpe.nebraska.gov/dashboards
- **HTTP Status**: 200 OK
- **Format**: Interactive dashboards and PDF reports

Available:
- College Continuation Rates dashboard (2007-2024)
- Higher Education Progress Report (PDF)
- Excel download mentioned for college-going rates

**Finding**: This is higher education data (college-going rates), not K-12 graduation rates. Different scope from what we need.

## URLs Verified

### Working URLs (No Graduation Data)
| URL | Status | Content |
|-----|--------|---------|
| education.ne.gov/dataservices/data-reports/ | 200 | Enrollment, FRPL, Attendance files |
| education.ne.gov/dataservices/data-reports/data-and-information-archives/ | 200 | Historical enrollment, FRPL files |
| nep.education.ne.gov/ | 200 | JavaScript app (no direct data access) |
| aquestt.com/archive/ | 200 | PDF methodology documents only |
| aquestt.com/resources/ | 200 | PDF methodology documents only |

### Failed URL Patterns Tested
| URL Pattern Tested | Status | Notes |
|-------------------|--------|-------|
| /wp-content/uploads/*/GraduationRate*.csv | 404 | Does not exist |
| /wp-content/uploads/*/CohortGraduation*.csv | 404 | Does not exist |
| /wp-content/uploads/*/Graduation*.xlsx | 404 | Does not exist |
| nep.education.ne.gov/api/* | 404 | No public API |

## Schema Analysis

Unable to analyze schema for graduation data as no downloadable files exist.

### ID System (from enrollment data)
Nebraska uses a County-District-School ID format:
- **District ID**: `CO_DIST` format (e.g., "01-0003")
  - 2-digit county code
  - 4-digit district code
- **School ID**: `CO_DIST_SCH` format (e.g., "01-0003-001")
  - Same as district ID plus 3-digit school code

This ID format would likely be consistent in graduation data if it were available.

## Time Series Heuristics (from external sources)

Based on news reports and CCPE publications:
- **State average graduation rate**: ~88% (4-year cohort)
- **State dropout rate**: ~1%
- **Female graduation rate**: ~90.3%
- **Male graduation rate**: ~86.2%
- **Lowest subgroup rate**: ~74.2% (Native American)
- **Highest subgroup rate**: ~90.2% (Asian)
- **Annual graduates**: ~22,000

These would serve as validation benchmarks if data becomes available.

## Barriers to Implementation

### Primary Barrier: No Downloadable Data Files
Unlike enrollment data, Nebraska does NOT provide graduation rate data as downloadable CSV/XLSX/TXT files. All graduation data is locked behind:
1. A JavaScript web application (NEP)
2. Authenticated portals (NEP Secure)

### Secondary Barriers
1. **No Public API**: The NEP application does not expose a documented API
2. **Authentication Required**: Full data requires NDE Portal credentials
3. **Data Embargo**: Data is embargoed until November each year
4. **JavaScript Rendering**: Web scraping would require headless browser automation

## Alternative Approaches (Not Recommended)

### Option A: Headless Browser Automation
- Use Selenium/Playwright to navigate NEP web interface
- Extract data from rendered HTML tables
- **Problems**:
  - Fragile (UI changes break scraper)
  - Violates CLAUDE.md guidance ("NEVER suggest manual downloads")
  - May violate NDE terms of service
  - Complex maintenance burden

### Option B: Federal Data Sources
- NCES CCD has Nebraska graduation data
- Ed Data Express has state-level graduation data
- **Problems**:
  - **EXPLICITLY FORBIDDEN** per CLAUDE.md
  - "NEVER use Urban Institute API, NCES CCD, or ANY federal data source"
  - Loses state-specific detail

### Option C: Data Request to NDE
- Submit formal data request through nep.education.ne.gov/#/data-request
- Request bulk graduation data files be made public
- **Problems**:
  - Outside scope of package development
  - No guarantee of success
  - Long timeline

## Recommended Action

**Do NOT implement graduation rate support at this time.**

The data is simply not available for automated download. Unlike enrollment data where Nebraska provides excellent direct file access, graduation data is locked behind authenticated web portals.

### Future Monitoring
Monitor these URLs for changes:
1. https://www.education.ne.gov/dataservices/data-reports/ - Check for new "Graduation" section
2. https://nep.education.ne.gov/ - Watch for API documentation
3. https://aquestt.com/resources/ - Check for data file releases

### When to Revisit
- If NDE adds graduation data files to their data reports page
- If NDE documents a public API for NEP
- If new data portals are announced

## Appendix: All Files Verified on NDE Data Reports Page

### Currently Available (NOT Graduation)

**Enrollment/Membership:**
- MembershipByGradeRaceAndGender_20252026.csv (2026)
- MembershipByGradeRaceAndGender_20242025.csv (2025)
- MembershipByGradeRaceAndGender_20232024.csv (2024)
- ... (back to 2003 in TXT format)

**Free/Reduced Lunch:**
- 2025-2026_Free_and_Reduced_Lunch_Counts_by_School.xlsx
- 2024-2025_Free_and_Reduced_Lunch_Counts_by_School.xlsx
- ... (back to 2007)

**Attendance/Absences:**
- 2024-2025-Student-Absences-Counts-by-District.xlsx
- 2023-2024-Student-Absences-Counts-by-District.xlsx
- ... (back to 2018)

**NOT Available:**
- No graduation rate files
- No cohort graduation files
- No dropout rate files
