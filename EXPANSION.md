# Nebraska School Data Expansion Research

**Last Updated:** 2026-01-11
**Theme Researched:** Assessment Data (NSCAS/NeSA)

## Executive Summary

**STATUS: NOT FEASIBLE FOR AUTOMATED DOWNLOAD**

Nebraska assessment data (NSCAS and legacy NeSA) is NOT available through direct file downloads like enrollment data. The assessment results are only accessible through:
1. **Nebraska Education Profile (NEP)** - A JavaScript-based web portal with no public API
2. **PDF Technical Reports** - Annual reports in PDF format (not machine-readable)
3. **NEP Secure** - Requires authentication via NDE Portal with district credentials

This is fundamentally different from enrollment data, which Nebraska provides via direct CSV/TXT file downloads.

## Current Package Capabilities

The `neschooldata` package currently supports:
- **Enrollment data**: 2003-2026 (23 years)
- **Source**: Direct CSV/TXT file downloads from NDE
- **Data types**: Membership by grade, race, and gender
- **Assessment data**: NONE (not implemented)

## Nebraska Assessment System History

### Assessment Eras

**1. STARS (School-based, Teacher-led Assessment and Reporting System)**
- Years: ~2001-2009
- Format: District-led assessments with state reporting
- Data: Limited publicly available data

**2. NeSA (Nebraska State Accountability)**
- Years: 2010-2020
- Subjects:
  - NeSA-R (Reading) - Grades 3-8, 11
  - NeSA-M (Mathematics) - Grades 3-8, 11
  - NeSA-S (Science) - Grades 5, 8, 11
- Format: Statewide summative assessments
- Data: Technical reports available as PDFs

**3. NSCAS (Nebraska Student-Centered Assessment System)**
- Years: 2017-present
- Subjects:
  - NSCAS Summative ELA - Grades 3-8
  - NSCAS Summative Math - Grades 3-8
  - NSCAS Summative Science - Grades 5, 8
  - NSCAS Growth (adapted from NWEA MAP) - Grades 3-9
- Format: Statewide summative + growth assessments
- Data: Technical reports available as PDFs, web interface via NEP

## Data Sources Investigated

### 1. Nebraska Department of Education - Data Reports Page
- **URL**: https://www.education.ne.gov/dataservices/data-reports/
- **HTTP Status**: 200 OK
- **Assessment Data**: NOT AVAILABLE as downloadable files

Available data files (NOT assessment):
| Data Type | Format | Years |
|-----------|--------|-------|
| Membership by Grade/Race/Gender | CSV, TXT | 2003-2026 |
| County Membership by Grade | CSV, TXT | 2003-2026 |
| Free/Reduced Lunch | XLS, XLSX | 2007-2026 |
| Student Absences by District | XLSX | 2018-2025 |

**Finding**: No assessment result files are publicly posted on the data reports page.

### 2. Nebraska Education Profile (NEP)
- **URL**: https://nep.education.ne.gov/
- **HTTP Status**: 200 OK (returns JavaScript app)
- **Format**: Angular-based single-page application
- **API**: No public API discovered
- **Assessment Data**: Available through web interface only

**Finding**: The NEP is a JavaScript-rendered application. Assessment results (NSCAS and NeSA) are viewable in the web interface but not downloadable as data files. The application loads data dynamically via AJAX calls, but no public API endpoints were documented or discovered.

### 3. NEP Secure (Authenticated Portal)
- **URL**: https://portal.education.ne.gov/
- **Access**: Requires NDE Portal account with activation code from district administrator
- **Data Available**: 2023-2024 Assessment, Cohort Graduation and Dropout data
- **Status**: Embargoed until public release each November

**Finding**: This is the primary source for detailed school-level assessment data but requires institutional authentication. District Assessment Contacts and Data Administrators can access detailed student score data files, but these are not publicly available.

### 4. NSCAS Technical Reports (PDF Format)

Available technical reports (all PDF):
| Year | Document | URL |
|------|----------|-----|
| 2024 | 2023-2024 NSCAS Growth Technical Report v3 | https://www.education.ne.gov/wp-content/uploads/2025/01/2024-NSCAS-Growth-Technical-Report-v3.pdf |
| 2022 | 2022 NSCAS Growth Technical Report | https://www.education.ne.gov/wp-content/uploads/2022/12/2022-NSCAS-Growth-Technical-Report.pdf |
| 2014 | 2014 NeSA Technical Report | https://www.education.ne.gov/assessment/pdfs/Final_2014_NeSA_Technical_Report.pdf |
| 2010 | 2010 NeSA Technical Report | http://govdocs.nebraska.gov/epubs/E2000/B116-2010.pdf |

**Finding**: These are PDF documents with methodology and summary results, not raw data files. While they contain assessment results, the data is embedded in tables within PDFs, making automated extraction difficult and fragile.

### 5. Data and Information Archives
- **URL**: https://www.education.ne.gov/dataservices/data-reports/data-and-information-archives/
- **HTTP Status**: 200 OK
- **Assessment Data**: NOT AVAILABLE

Available archives (NOT assessment):
- Membership by Grade, Race, and Gender (2000-2021) - CSV/TXT
- County Membership by Grade (2000-2021) - CSV/TXT
- Free and Reduced Lunch Counts by School (2007-2021) - XLS
- Student Absence Counts by District (2018-2021) - XLSX
- Statistics & Facts About Nebraska Schools (1999-2021) - PDF

**Finding**: No assessment result files in the archives. The archives only contain enrollment, FRPL, and attendance data.

## URLs Verified

### Working URLs (No Downloadable Assessment Data)
| URL | Status | Content |
|-----|--------|---------|
| education.ne.gov/dataservices/data-reports/ | 200 | Enrollment, FRPL, Attendance files |
| education.ne.gov/dataservices/data-reports/data-and-information-archives/ | 200 | Historical enrollment, FRPL files |
| nep.education.ne.gov/ | 200 | JavaScript app (assessment data visible but not downloadable) |
| education.ne.gov/assessment/ | 200 | Assessment information, test schedules, technical reports (PDF) |
| education.ne.gov/assessment/nscas-growth/ | 200 | NSCAS Growth information and user guides |

### Assessment Technical Report URLs (PDF only)
| URL | Status | Content |
|-----|--------|---------|
| education.ne.gov/wp-content/uploads/2025/01/2024-NSCAS-Growth-Technical-Report-v3.pdf | 200 | 2023-2024 NSCAS technical report (PDF) |
| education.ne.gov/wp-content/uploads/2022/12/2022-NSCAS-Growth-Technical-Report.pdf | 200 | 2022 NSCAS technical report (PDF) |
| education.ne.gov/assessment/pdfs/Final_2014_NeSA_Technical_Report.pdf | 200 | 2014 NeSA technical report (PDF) |
| govdocs.nebraska.gov/epubs/E2000/B116-2010.pdf | 200 | 2010 NeSA technical report (PDF) |

### Failed URL Patterns Tested
| URL Pattern Tested | Status | Notes |
|-------------------|--------|-------|
| /wp-content/uploads/*/NSCAS*.csv | 404 | Does not exist |
| /wp-content/uploads/*/NSCAS*.xlsx | 404 | Does not exist |
| /wp-content/uploads/*/NeSA*.csv | 404 | Does not exist |
| /wp-content/uploads/*/NeSA*.xlsx | 404 | Does not exist |
| /wp-content/uploads/*/assessment*.csv | 404 | Does not exist |
| /wp-content/uploads/*/assessment*.xlsx | 404 | Does not exist |
| nep.education.ne.gov/api/* | 404 | No public API |

## Schema Analysis

Unable to analyze schema for assessment data as no downloadable files exist.

### Expected Schema Elements (from NSCAS documentation)

Based on NSCAS Growth User and Student Management Guides, district/school-level data would likely include:
- **Student IDs** (de-identified for public reporting)
- **District/School IDs** (using Nebraska's CO_DIST_SCH format)
- **Grade levels** (3-8 for NSCAS Summative, 3-9 for NSCAS Growth)
- **Subject areas** (ELA, Mathematics, Science)
- **Scale scores** (RIT scores for NSCAS Growth, scale scores for NSCAS Summative)
- **Achievement levels** (e.g., "Exceeds", "Meets", "Below", "Well Below")
- **Subgroup data** (race/ethnicity, gender, ELL, SPED, FRPL)
- **Test administration dates**

However, without access to raw data files, the exact column names and formats cannot be verified.

## Time Series Heuristics (from news reports and technical summaries)

Based on Nebraska Department of Education press releases and news coverage:

**NSCAS Summative (2024 results):**
- **ELA proficiency**: ~57% statewide (grades 3-8)
- **Math proficiency**: ~55% statewide (grades 3-8)
- **Science proficiency**: ~69% statewide (grades 5 & 8)

**Historical context:**
- NSCAS replaced NeSA in 2017-2020 (phased transition)
- NeSA was operational 2010-2020
- STARS was used before 2010

**Achievement gaps** (from various sources):
- White students: ~60-65% proficient
- Hispanic students: ~35-40% proficient
- Black students: ~25-30% proficient
- Asian students: ~70%+ proficient
- Native American students: ~25-30% proficient

These would serve as validation benchmarks if data becomes available.

## Barriers to Implementation

### Primary Barrier: No Downloadable Data Files
Unlike enrollment data, Nebraska does NOT provide assessment results as downloadable CSV/XLSX/TXT files. All assessment data is locked behind:
1. A JavaScript web application (NEP)
2. Authenticated portals (NEP Secure)
3. PDF technical reports

### Secondary Barriers
1. **No Public API**: The NEP application does not expose a documented API
2. **Authentication Required**: Full detailed data requires NDE Portal credentials (District Assessment Contact role)
3. **PDF-Only Reports**: Technical reports are PDFs, not data files
4. **JavaScript Rendering**: Web scraping would require headless browser automation
5. **Student Privacy**: Assessment data includes student-level information with FERPA implications

## Alternative Approaches (Not Recommended)

### Option A: Headless Browser Automation
- Use Selenium/Playwright to navigate NEP web interface
- Extract data from rendered HTML tables
- **Problems**:
  - Extremely fragile (UI changes break scraper)
  - Violates CLAUDE.md guidance ("NEVER suggest manual downloads")
  - May violate NDE terms of service
  - Complex maintenance burden
  - Slow (must render each page)

### Option B: PDF Text Extraction
- Extract tables from NSCAS/NeSA technical reports (PDF)
- Use PDF parsing libraries (tabula, pdftotext)
- **Problems**:
  - PDFs have inconsistent formatting
  - Table structures vary by year
  - Summary tables only (not school-level detail)
  - Missing data for early years
  - Fragile and error-prone
  - Does not provide complete historical series

### Option C: Federal Data Sources
- NCES CCD has Nebraska assessment data
- Ed Data Express has state-level assessment data
- **Problems**:
  - **EXPLICITLY FORBIDDEN** per CLAUDE.md
  - "NEVER use Urban Institute API, NCES CCD, or ANY federal data source"
  - Loses state-specific detail
  - May not include NSCAS (only aggregated federal reporting)

### Option D: Data Request to NDE
- Submit formal data request through nep.education.ne.gov/#/data-request
- Request bulk assessment data files be made public
- **Problems**:
  - Outside scope of package development
  - No guarantee of success
  - Long timeline
  - FERPA/student privacy concerns may prevent release

## Comparison with Enrollment Data

### Enrollment Data (SUCCESSFULLY IMPLEMENTED)
- **Format**: Direct CSV/TXT file downloads
- **URL Pattern**: Predictable file naming (e.g., MembershipByGradeRaceAndGender_20242025.csv)
- **Access**: Public, no authentication required
- **Historical Coverage**: 2000-2026 (26 years)
- **Implementation**: Straightforward with readr::read_delim()

### Assessment Data (NOT AVAILABLE)
- **Format**: JavaScript web interface only (NEP)
- **URL Pattern**: No downloadable file URLs
- **Access**: Requires authentication or manual web interaction
- **Historical Coverage**: Data exists in NEP and PDFs, but not accessible
- **Implementation**: Would require web scraping or PDF parsing (both fragile)

## Recommended Action

**Do NOT implement assessment data support at this time.**

The data is simply not available for automated download in a sustainable way. Unlike enrollment data where Nebraska provides excellent direct file access, assessment data is locked behind authenticated web portals or embedded in PDF documents.

### What Would Need to Change
Assessment data implementation would be feasible if:
1. NDE adds assessment data files to their data reports page (like enrollment)
2. NDE documents a public API for NEP
3. NDE provides bulk data downloads for research purposes
4. New data portals are announced with programmatic access

### Future Monitoring
Monitor these URLs for changes:
1. https://www.education.ne.gov/dataservices/data-reports/ - Check for new "Assessment" section with downloadable files
2. https://nep.education.ne.gov/ - Watch for API documentation or download buttons
3. https://www.education.ne.gov/assessment/ - Check for data file releases
4. https://www.education.ne.gov/dataservices/data-reports/data-and-information-archives/ - Check for assessment archives

### When to Revisit
- If NDE adds assessment data files to their data reports page
- If NDE documents a public API for NEP
- If NDE creates a research data portal
- If new assessment data access policies are announced

## Appendix: Nebraska Assessment Timeline

| Years | Assessment System | Subjects | Notes |
|-------|------------------|----------|-------|
| ~2001-2009 | STARS | Reading, Math, Writing | District-led with state reporting |
| 2010-2016 | NeSA | NeSA-R, NeSA-M, NeSA-S | First statewide summative assessments |
| 2017-2020 | NeSA → NSCAS Transition | Phased | Moving to NSCAS Summative |
| 2021-present | NSCAS | ELA, Math, Science | NSCAS Summative + Growth |

### Assessment Coverage by Grade
**NSCAS Summative (current):**
- ELA: Grades 3-8
- Math: Grades 3-8
- Science: Grades 5, 8

**NSCAS Growth (current):**
- ELA: Grades 3-9
- Math: Grades 3-9

**NeSA (legacy 2010-2020):**
- NeSA-R: Grades 3-8, 11
- NeSA-M: Grades 3-8, 11
- NeSA-S: Grades 5, 8, 11

## Appendix: Sources

### Nebraska Department of Education
- [Statewide Assessment Main Page](https://www.education.ne.gov/assessment/)
- [Data Reports Page](https://www.education.ne.gov/dataservices/data-reports/)
- [Data and Information Archives](https://www.education.ne.gov/dataservices/data-reports/data-and-information-archives/)
- [Nebraska Education Profile (NEP)](https://nep.education.ne.gov/)
- [NSCAS Growth Information](https://www.education.ne.gov/assessment/nscas-growth/)

### Technical Reports
- [2023-2024 NSCAS Growth Technical Report](https://www.education.ne.gov/wp-content/uploads/2025/01/2024-NSCAS-Growth-Technical-Report-v3.pdf)
- [2022 NSCAS Growth Technical Report](https://www.education.ne.gov/wp-content/uploads/2022/12/2022-NSCAS-Growth-Technical-Report.pdf)
- [2014 NeSA Technical Report](https://www.education.ne.gov/assessment/pdfs/Final_2014_NeSA_Technical_Report.pdf)
- [2010 NeSA Technical Report](http://govdocs.nebraska.gov/epubs/E2000/B116-2010.pdf)

### Documentation
- [NSCAS Growth User and Student Management Guide](https://cdn.nwea.org/docs/NE/NSCAS_User_Student_Mgmt_Guide.pdf)
- [NSCAS Growth Reports Interpretive Guide](https://www.nwea.org/uploads/NSCASReportsIntGuideEnglish_NWEA_Guide.pdf)

---

**Package Status Warning:**
This package (neschooldata) is currently **failing R-CMD-check** and **pkgdown** builds. Before adding any new features, the existing package issues must be resolved. The current focus should be on fixing the failing checks rather than expanding data access.
