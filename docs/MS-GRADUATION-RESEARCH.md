# Mississippi Graduation Rate Data Research Report

**Date:** 2026-01-09
**State:** Mississippi (MS)
**Package:** msschooldata
**Researcher:** Claude Code
**Status:** ❌ NOT VIABLE - Tier 4 (Skip)

---

## Executive Summary

**Finding:** Mississippi graduation rate data is **NOT VIABLE** for automated implementation in the msschooldata package.

**Reason:** The Mississippi Department of Education (MDE) publishes graduation rate data exclusively as:
1. PDF reports (not machine-readable)
2. JavaScript-rendered interactive website (msrc.mdek12.org) with no public API
3. No CSV/Excel downloads for recent years

**Recommendation:** **SKIP** Mississippi graduation rate implementation. Mark as Tier 4 (Not Viable) in the master tracker.

---

## Data Sources Investigated

### 1. Mississippi Succeeds Report Card (MSRC)
**URL:** https://msrc.mdek12.org
**Format:** Interactive JavaScript website
**Years Available:** 2018-2024 (7 years)
**Viability:** ❌ NOT VIABLE

**Details:**
- Interactive dashboard for state, district, and school graduation rates
- Data rendered client-side via JavaScript (Alpine.js framework)
- No public API endpoint discovered
- No CSV/Excel download buttons
- Each entity (state/district/school) has separate pages requiring different EntityID parameters

**Example URLs:**
- State: `https://msrc.mdek12.org/details?EntityID=0000-000&Component=GR&SchoolYear=2023`
- District: `https://msrc.mdek12.org/details?EntityID=3000-000&Component=GR&SchoolYear=2023`
- School: `https://msrc.mdek12.org/details?EntityID=5920-008&Component=GR&SchoolYear=2023`

**Why This Doesn't Work:**
- Requires browser automation (RSelenium) or API reverse-engineering
- EntityIDs are not predictable (would need to scrape district/school lists first)
- Rate limiting and bot detection likely
- JavaScript rendering adds complexity and fragility
- Violates project preference against browser automation

---

### 2. PDF Graduation/Dropout Reports
**URL Pattern:** `https://www.mdek12.org/sites/default/files/Offices/MDE/OEA/OPR/{YEAR}/grad_dropout_rates_{YEAR}_report.pdf`
**Format:** PDF documents
**Years Available:**
- 2024: https://www.mdek12.org/sites/default/files/Offices/MDE/OEA/OPR/2024/grad_dropout_rates_2024_report_1.pdf
- 2023: https://www.mdek12.org/sites/default/files/Offices/MDE/OEA/OPR/2023/grad_dropout_rates_2023_report.pdf
- 2021: https://www.mdek12.org/sites/default/files/Offices/MDE/OEA/OPR/2021/2021_graduation_and_dropout_rates.pdf
- 2018: https://www.mdek12.org/sites/default/files/Offices/MDE/OEA/OPR/2018/Grad%20Dropout%20Rates%20-%202018%20Report%2009FEB2018.pdf

**Viability:** ❌ NOT VIABLE

**Details:**
- District-level graduation rates in tabular format within PDFs
- PDFs are ~90-100 pages with embedded tables
- Would require PDF parsing (pdftools) which is error-prone
- Layout may change year-to-year
- No subgroup breakdowns in PDFs (only overall rates)
- Cohort counts and graduate counts not consistently available

**Why This Doesn't Work:**
- PDF parsing is fragile and error-prone
- Tables may have merged cells or inconsistent formatting
- No machine-readable structure guarantees
- Would break whenever MDE changes PDF layout
- Missing subgroup data (race, gender, special populations)

---

### 3. Historical Excel Files (2003-2007)
**URL Pattern:** `https://www.mdek12.org/sites/default/files/documents/OAE/OCSA/Docs/DGRI/{YEAR}/`
**Format:** XLS files
**Years Available:** 2003-2007 (5 years)
**Viability:** ❌ NOT VIABLE (Too old)

**Examples:**
- 2006-07: https://www.mdek12.org/sites/default/files/documents/OAE/OCSA/Docs/DGRI/2006_2007/sy0607g09_4yr_school_graduation_rates.xls
- 2005-06: https://www.mdek12.org/sites/default/files/documents/OAE/OCSA/Docs/DGRI/2005-2006/sy0506g09_4yr_district_dropout_rates.xls
- 2003-04: https://www.mdek12.org/sites/default/files/documents/OAE/OCSA/Docs/DGRI/2003-2004/sy0304g09_4yr_grad.xls

**Why This Doesn't Work:**
- Data is 18+ years old (not useful for 2021-2025 target range)
- Format likely changed significantly since then
- No recent files available in this format

---

### 4. New Reports Portal (newreports.mdek12.org)
**URL:** https://newreports.mdek12.org
**Format:** Data download portal
**Years Available:** 2006-2024 (19 years)
**Viability:** ❌ DOES NOT INCLUDE GRADUATION RATES

**Available Downloads:**
- Student Enrollment: `/DataDownload` (2006-2024)
- College and Career Readiness: `/CareerDownload` (2006-2024)

**Missing:**
- ❌ Graduation rate downloads
- ❌ Dropout rate downloads
- ❌ Cohort data downloads

**Why This Doesn't Work:**
- Portal only offers enrollment and college/career readiness data
- Graduation rates not included despite having historical data
- No indication this will be added in the future

---

## Data Structure (If It Were Available)

Based on the Mississippi Succeeds Report Card website, the data structure would include:

### Expected Columns (Hypothetical)
| Column | Description |
|--------|-------------|
| EntityID | State/District/School identifier |
| EntityType | "State", "District", or "School" |
| SchoolYear | Academic year (e.g., "2023-2024") |
| Component | "GR" (Graduation Rate) |
| Subgroup | Race, gender, special populations |
| GraduationRate | Percentage (e.g., 89.4%) |
| Goal | State goal for that subgroup/year |

### Subgroups Available (from MSRC website)
**Demographics:**
- All Students
- Female
- Male
- Black or African American
- White
- Asian
- Hispanic or Latino
- Native Hawaiian or Other Pacific Islander
- American Indian or Alaska Native
- Two or More Races

**Special Populations:**
- Economically Disadvantaged
- English Learners
- Students with Disabilities
- Migrant
- Homeless
- Foster Care

### Verified Data Values (2022-2023)
- **State Total:** 89.4%
- **Female:** 92.2%
- **Male:** 86.7%
- **Black or African American:** 88.2%
- **White:** 91.1%
- **Asian:** 96.6%
- **Hispanic or Latino:** 85.0%
- **Students with Disabilities:** 70.0%
- **English Learners:** 64.0%

---

## Alternative Approaches Considered

### 1. Browser Automation (RSelenium)
**Viability:** Technically possible but violates project guidelines

**Approach:**
- Use RSelenium to navigate MSRC website
- Scrape graduation rates for all districts/schools
- Handle EntityID discovery dynamically

**Why This Was Rejected:**
- Project guidelines state: "Tier 4 (Skip): Not viable (browser automation, PDFs, ASP.NET)"
- High maintenance burden (site changes break scraper)
- Slow and resource-intensive
- Potential legal/ethical issues with automated scraping

---

### 2. PDF Table Extraction (pdftools)
**Viability:** Technically possible but fragile and incomplete

**Approach:**
- Download PDF reports for each year
- Extract tables using pdftools or tabulizer
- Parse into structured data

**Why This Was Rejected:**
- PDFs have inconsistent formatting year-to-year
- Missing subgroup breakdowns (only overall rates)
- Cohort counts and graduate counts not always present
- High error rate with PDF parsing
- Would break whenever MDE changes PDF template

---

### 3. Contact MDE for Data Access
**Viability:** Unknown, not scalable for 51 states

**Approach:**
- Contact MDE Office of Technology and Strategic Services (OTSS)
- Request API access or bulk CSV files
- Build integration if data provided

**Why This Was Rejected:**
- Not scalable for batch implementation across 51 states
- May require formal data agreement
- No guarantee data will be provided in usable format
- Timeline uncertain (weeks/months vs hours)

---

## Comparison with Other States

### Tier 1 States (Direct Downloads) - MS is NOT Tier 1
- ND: Direct CSV download from ND Insights
- VA: CKAN API with JSON output
- OR: Direct Excel download
- MS: ❌ No direct downloads available

### Tier 2 States (API Access) - MS is NOT Tier 2
- MA: Socrata API with SoQL queries
- NY: Open data portal API
- MS: ❌ No public API available

### Tier 3 States (Special Cases) - MS could be Tier 3
- AZ: Cloudflare blocking (bundled files workaround)
- MS: ❌ JavaScript rendering requires browser automation (Tier 4)

---

## Recommendations

### For msschooldata Package
**Status:** SKIP graduation rate implementation

**Rationale:**
- No viable machine-readable data source
- PDF parsing is too fragile
- Browser automation violates project guidelines
- MSRC website has no public API
- Alternative sources (Urban Institute, NCES) prohibited by project rules

**Documentation:**
- Add note to CLAUDE.md: "Graduation rate data not available - Mississippi only publishes PDF reports and interactive website with no API"
- Update GRADUATION-RATE-MASTER-TRACKER.md: Mark MS as "Tier 4 (Not Viable)"

---

### For Mississippi Department of Education
**Recommendations for MDE:**

1. **Add API endpoints** to Mississippi Succeeds Report Card
   - JSON API for graduation rate data
   - Filterable by year, entity, subgroup
   - Document endpoints publicly

2. **Provide CSV/Excel downloads** on MSRC website
   - Bulk download for all districts/schools
   - Annual snapshots
   - Include cohort counts and graduate counts

3. **Expand newreports.mdek12.org**
   - Add graduation rate download section (like enrollment)
   - Provide multi-year download capability
   - Include subgroup breakdowns

**Contact:**
- Mississippi Department of Education
- Office of Technology and Strategic Services (OTSS)
- PO Box 771, Jackson, MS 39205
- (601) 359-3513

---

## Sources

### Mississippi Department of Education
- [Mississippi Succeeds Report Card](https://msrc.mdek12.org)
- [Public Reporting Portal](https://mdek12.org/publicreporting/)
- [2024 Graduation/Dropout Rates PDF](https://www.mdek12.org/sites/default/files/Offices/MDE/OEA/OPR/2024/grad_dropout_rates_2024_report_1.pdf)
- [2023 Graduation/Dropout Rates PDF](https://www.mdek12.org/sites/default/files/Offices/MDE/OEA/OPR/2023/grad_dropout_rates_2023_report.pdf)
- [Data Downloads (Enrollment only)](https://newreports.mdek12.org/DataDownload)
- [College and Career Readiness Downloads](https://newreports.mdek12.org/CareerDownload)

### News Coverage
- [MDE announces 2023-24 graduation rate of 89.2%](https://www.themississippimonitor.com/mde-announces-mississippis-2023-24-graduation-rate-of-89-2-and-dropout-rate-of-8-5/)
- [Mississippi's graduation rate continues to exceed national average](https://www.wdam.com/2025/02/25/state-graduation-rates-continue-surpass-national-average/)

---

**Conclusion:** Mississippi graduation rate data is **NOT VIABLE** for automated implementation using R packages. The state must improve its data dissemination practices (API, CSV downloads) before graduation rate data can be included in the msschooldata package.

**Next Steps:** Update master tracker, mark MS as Tier 4 (Skip), proceed with other states that have viable data sources.
