# Assessment Data Research Summary - 10 States

**Research Date:** 2026-01-11
**Task:** /expand-state assessment data research for NM, NV, NY, OH, OK, OR, PA, RI, SC, SD
**Status:** COMPLETED

---

## Quick Reference Table

| State | Data Access | Years Available | Primary Assessments | Recommendation | Complexity |
|-------|-------------|-----------------|---------------------|----------------|------------|
| NM | ❌ Blocked (Auth) | 2005-2024 | PARCC, NM-MSSA, NM-ASR | NOT RECOMMENDED | BLOCKING |
| NV | ✅ Downloadable | 2015-Present | SBAC, ACT, SAT | RECOMMENDED* | MEDIUM-HIGH |
| NY | ✅ Downloadable | 2013-Present | Grades 3-8, Regents | RECOMMENDED | MEDIUM |
| OH | ✅ Downloadable | 2015-Present | Ohio State Tests | RECOMMENDED | EASY-MEDIUM |
| OK | ⚠️ Unknown | Unknown | OSTP | NEEDS RESEARCH | UNKNOWN |
| OR | ✅ Downloadable | 2015-Present | SBAC (OAKS) | RECOMMENDED | EASY-MEDIUM |
| PA | ⚠️ Portal Only | 2015-Present | PSSA, Keystone | NEEDS RESEARCH | MEDIUM |
| RI | ✅ Downloadable | 2017-Present | RICAS, PSAT, SAT | RECOMMENDED | EASY-MEDIUM |
| SC | ✅ Downloadable | 2015-Present | SC READY, SCPASS | RECOMMENDED | EASY-MEDIUM |
| SD | ⚠️ Limited | 2018-Present | SD ELA/Math, Science | NEEDS RESEARCH | MEDIUM |

**Legend:**
- ✅ Downloadable: Direct file downloads available
- ⚠️ Portal Only: Interactive dashboard or limited access
- ❌ Blocked: Requires authentication or no API access

---

## Detailed State Summaries

### 1. NEW MEXICO (NM)

**Status:** NOT RECOMMENDED FOR IMPLEMENTATION

**Key Findings:**
- **Primary Source:** Cognia Portal (newmexico.cognia.org) - REQUIRES AUTHENTICATION
- **Secondary Source:** NM Vistas (nmvistas.org) - Interactive dashboard, NO API
- **Historical Data:** PARCC (2015-2018), NM-MSSA (2019-Present)
- **Blockers:**
  - All data requires login credentials
  - No public API available
  - Tableau dashboards don't expose underlying data

**Years Available:** 2005-2024 (comprehensive, but inaccessible)

**Assessments:**
- NM-MSSA: Grades 3-8 (ELA, Math, Science)
- NM-ASR: Grade 11 (replaced SAT for accountability)
- DLM: Alternate assessment
- Historical: PARCC (2015-2018), SBA (pre-2015)

**Complexity:** BLOCKING
- Workarounds require IPRA request or DOE data use agreement

**Documentation:** `/Users/almartin/Documents/state-schooldata/nmschooldata/EXPANSION_ASSESSMENT.md`

**Sources:**
- [Achievement Data by Year | New Mexico Public Education Department (NMPED)](https://web.ped.nm.gov/bureaus/accountability/achievement-data-by-year/)
- [NM Vistas | About](https://nmvistas.org/About)
- [NMPED Assessments Reporting User Guide v1.0](https://newmexico.onlinehelp.cognia.org/wp-content/uploads/sites/10/2024/07/NMPED-Assessments-Reporting-User-Guide-v1.0.pdf)

---

### 2. NEVADA (NV)

**Status:** RECOMMENDED* (with caveats)

**Key Findings:**
- **Primary Source:** Nevada Report Card (nevadareportcard.nv.gov)
- **Data Interaction Tool:** https://nevadareportcard.nv.gov/DI/
- **Downloadable Files:** Excel files available through portal
- **Blockers:** Download URLs use query parameters, may be session-specific

**Years Available:** 2015-Present (Smarter Balanced era)

**Assessments:**
- Smarter Balanced (SBAC): Grades 3-8 (ELA, Math)
- Nevada Science: Grades 5, 8, HS
- ACT: Grade 11 (state-funded)
- NWEA MAP: K-3 (interim)
- DLM: Alternate assessment

**Complexity:** MEDIUM-HIGH
- Need to discover actual URL patterns
- Session management may be required
- Schema analysis needed on sample files

**Next Steps:**
1. Access Nevada Report Card Data Interaction tool
2. Download 3 sample years (2016, 2020, 2024)
3. Document schema and URL patterns
4. Contact adaminfo@doe.nv.gov for technical guidance

**Documentation:** `/Users/almartin/Documents/state-schooldata/nvschooldata/EXPANSION_ASSESSMENT.md`

**Sources:**
- [Grades 3-8: Smarter Balanced Assessments - Nevada DOE](https://doe.nv.gov/offices/office-of-assessment-data-and-accountability-management-adam/office-of-assessments/smarter-balanced-assessments)
- [Nevada Report Card](https://nevadareportcard.nv.gov/)
- [Data Interaction - Nevada Accountability Portal](https://nevadareportcard.nv.gov/DI/Help/FAQ)
- [Nevada Growth Model FAQ 2025](https://webapp-strapi-paas-prod-nde-001.azurewebsites.net/uploads/Growth_Model_FA_Qs_edc4a68fac.pdf)

---

### 3. NEW YORK (NY)

**Status:** RECOMMENDED

**Key Findings:**
- **Primary Source:** NYSED Data Website (mentioned in assessment results)
- **Assessment Page:** https://www.nysed.gov/state-assessment
- **Recent Data:** 2024-25 results released December 2025
- **NYC Data:** InfoHub (https://infohub.nyced.org/reports/academics/test-results)

**Years Available:** 2013-Present (Grades 3-8), Regents data available

**Assessments:**
- Grades 3-8: ELA and Mathematics
- Regents Exams: High school (multiple subjects)
- NYSESLAT: English proficiency for ELLs
- NYSAA: Alternate assessment

**Complexity:** MEDIUM
- Direct downloads mentioned on NYSED site
- NYC has separate portal with downloadable data
- Regents data also available

**Next Steps:**
1. Access NYSED Data Website
2. Check downloadable file formats
3. Document schema for Grades 3-8 and Regents

**Sources:**
- [State Assessment | New York State Education Department](https://www.nysed.gov/state-assessment)
- [New York State Education Department Releases 2024–25 State Assessment Results](https://www.nysed.gov/news/2025/new-york-state-education-department-releases-2024-25-state-assessment-results)
- [Test Results - InfoHub](https://infohub.nyced.org/reports/academics/test-results)

---

### 4. OHIO (OH)

**Status:** RECOMMENDED

**Key Findings:**
- **Primary Source:** Ohio School Report Cards - Download Data
- **Download URL:** https://reportcard.education.ohio.gov/download
- **Format:** Excel files by year
- **Portal:** https://reportcard.education.ohio.gov/

**Years Available:** 2015-Present (Ohio's State Tests era)

**Assessments:**
- Ohio's State Tests: Grades 3-8 (ELA, Math)
- Ohio's State Tests: Grades 5, 8, HS (Science)
- Ohio's State Tests: HS (American Government, American History)
- Alternate Assessment: Ohio Alternate Assessment
- OGT: Pre-2015 (Ohio Graduation Tests)

**Complexity:** EASY-MEDIUM
- Direct Excel downloads available
- Can select specific years or all years
- Data in standardized format

**Next Steps:**
1. Download sample Excel files from report card site
2. Document schema and columns
3. Implement fetch_assess() for Ohio

**Sources:**
- [Download Data - Ohio School Report Cards](https://reportcard.education.ohio.gov/download)
- [Ohio School Report Cards](https://reportcard.education.ohio.gov/)
- [Statistical Summaries and Item Analysis Reports](https://education.ohio.gov/Topics/Testing/Statistical-Summaries-and-Item-Analysis-Reports)

---

### 5. OKLAHOMA (OK)

**Status:** NEEDS FURTHER RESEARCH

**Key Findings:**
- **Primary Source:** Oklahoma School Testing Program (OSTP) portal
- **Assessment Page:** https://oklahoma.gov/education/services/assessments.html
- **Testing Resources:** https://oklahoma.gov/education/services/assessments/state-testing-resources.html

**Years Available:** Unknown (likely 2015-Present)

**Assessments:**
- OSTP: Grades 3-8 (ELA, Math, Science)
- U.S. History Assessment
- OAAP: Oklahoma Alternate Assessment Program (DLM)

**Complexity:** UNKNOWN
- Need to determine if OSTP portal has downloadable data
- May require portal navigation
- Recent changes to assessment system (2024-2025)

**Next Steps:**
1. Access OSTP portal to check for data downloads
2. Contact Oklahoma SDE for data access
3. Check if data available through alternative sources

**Sources:**
- [Assessments - Oklahoma.gov](https://oklahoma.gov/education/services/assessments.html)
- [State Testing Resources - Oklahoma.gov](https://oklahoma.gov/education/services/assessments/state-testing-resources.html)

---

### 6. OREGON (OR)

**Status:** RECOMMENDED

**Key Findings:**
- **Primary Source:** ODE Assessment Group Reports
- **URL:** https://www.oregon.gov/ode/educator-resources/assessment/pages/assessment-group-reports.aspx
- **Data:** ELA, Math, Science assessments

**Years Available:** 2015-Present (Smarter Balanced era)

**Assessments:**
- Smarter Balanced (OAKS): Grades 3-8 (ELA, Math)
- OAKS Science: Grades 5, 8, HS
- Extended Assessments: Alternate assessment
- ELPA: English proficiency for ELLs

**Recent Data (2024-25):**
- Math: 31.5% proficient
- Science: 30% proficient
- Still below pre-pandemic levels

**Complexity:** EASY-MEDIUM
- Direct download links mentioned on ODE site
- Group reports by year

**Next Steps:**
1. Access ODE Assessment Group Reports page
2. Download sample files
3. Document schema

**Sources:**
- [Student Assessment - Oregon Department of Education](https://www.oregon.gov/ode/educator-resources/assessment/pages/assessment-group-reports.aspx)

---

### 7. PENNSYLVANIA (PA)

**Status:** NEEDS FURTHER RESEARCH

**Key Findings:**
- **Primary Source:** PSSA information on PA.gov
- **Assessment Page:** https://www.pa.gov/agencies/education/programs-and-services/instruction/elementary-and-secondary-education/assessment-and-accountability/pennsylvania-system-of-school-assessment-pssa
- **PDE SAS:** https://www.pdesas.org/Page?pageId=10

**Years Available:** 2015-Present

**Assessments:**
- PSSA: Grades 3-8 (ELA, Math, Science in 4 & 8)
- Keystone Exams: High school (Algebra I, Biology, Literature)
- PASA: Pennsylvania Alternate System of Assessment

**Complexity:** MEDIUM
- PA.gov pages are informational
- Data likely through PASD (Pennsylvania Assessment and Score Database)
- May require portal access

**Next Steps:**
1. Determine if direct downloads available
2. Check PASD portal access requirements
3. Contact PDE for data access information

**Sources:**
- [Pennsylvania System of School Assessment (PSSA) - Official PA.gov Page](https://www.pa.gov/agencies/education/programs-and-services/instruction/elementary-and-secondary-education/assessment-and-accountability/pennsylvania-system-of-school-assessment-pssa)
- [PSSA - SAS](https://www.pdesas.org/Page?pageId=10)

---

### 8. RHODE ISLAND (RI)

**Status:** RECOMMENDED

**Key Findings:**
- **Primary Source:** Rhode Island Assessment Data Portal
- **URL:** https://www3.ride.ri.gov/ADP
- **Results Page:** https://ride.ri.gov/instruction-assessment/assessment/assessment-results

**Years Available:** 2017-Present

**Assessments:**
- RICAS: Grades 3-8 (ELA, Math)
- PSAT/SAT: High school
- Rhode Island State Assessments
- Alternate assessments available

**Complexity:** EASY-MEDIUM
- Public portal with customizable data views
- Data from 2017-18 onwards
- Can filter and export data

**Next Steps:**
1. Access RI Assessment Data Portal
2. Test data export functionality
3. Document export formats and schema

**Sources:**
- [Assessment Data Portal - Rhode Island](https://www3.ride.ri.gov/ADP)
- [Assessment Results Page](https://ride.ri.gov/instruction-assessment/assessment/assessment-results)

---

### 9. SOUTH CAROLINA (SC)

**Status:** RECOMMENDED

**Key Findings:**
- **Primary Source:** SCDE Test Scores Portal
- **URL:** https://ed.sc.gov/data/test-scores/
- **State Assessments:** https://ed.sc.gov/data/test-scores/state-assessments/

**Years Available:** 2015-Present

**Assessments:**
- SC READY: Grades 3-8 (ELA, Math)
- SCPASS: Grades 4, 6, 8 (Science, 6 & 8 Social Studies)
- EOCEP: End-of-Course Examination Program
- SC-Alt: Alternate assessments
- ACCESS for ELLs
- ACT, ACT Aspire, WorkKeys

**Recent Data:**
- 2025 SC READY results available
- Multiple assessments with downloadable data

**Complexity:** EASY-MEDIUM
- Centralized test scores portal
- State, district, school-level breakdowns
- Historical trend data available

**Next Steps:**
1. Access SCDE Test Scores portal
2. Download sample SC READY data
3. Document schema and implement

**Sources:**
- [Test Scores - South Carolina Department of Education](https://ed.sc.gov/data/test-scores/)
- [State Assessments - South Carolina Department of Education](https://ed.sc.gov/data/test-scores/state-assessments/)

---

### 10. SOUTH DAKOTA (SD)

**Status:** NEEDS FURTHER RESEARCH

**Key Findings:**
- **Primary Source:** SD DOE Office of Assessment
- **URL:** https://doe.sd.gov/assessment/
- **Resources:** https://doe.sd.gov/assessment/Resources.aspx
- **Test Review:** https://doe.sd.gov/assessment/TestReview.aspx

**Years Available:** 2018-Present (per 2023 report)

**Assessments:**
- SD ELA and Math: Grades 3-8 and HS
- Science assessments
- ACCESS for ELLs
- Alternate assessments
- SD-STARS: Statewide reporting system

**Complexity:** MEDIUM
- Office of Assessment page has resources
- SD-STARS system mentioned for student outcomes
- Need to determine download availability

**Next Steps:**
1. Access Office of Assessment Resources page
2. Check SD-STARS for data export options
3. Download sample files if available

**Sources:**
- [Office Of Assessment - South Dakota DOE](https://doe.sd.gov/assessment/)
- [Assessment Resources, SD Department of Education](https://doe.sd.gov/assessment/Resources.aspx)
- [2023 State Test Score Results: SOUTH DAKOTA](https://assets.ctfassets.net/9fbw4onh0qc1/6Jpa2INhtj4sI8abzuTg5f/4c4ac3f501aa86cd9d4a07c356ac2f71/CSDH_STSR_DataSeries_2023-30-SD-00_South_Dakota.pdf)

---

## Implementation Priority Ranking

### Tier 1: Ready for Implementation (EASIEST)
1. **Ohio** - Direct Excel downloads from School Report Card
2. **Oregon** - ODE Assessment Group Reports with direct downloads
3. **South Carolina** - Centralized test scores portal
4. **Rhode Island** - Assessment Data Portal with export functionality

### Tier 2: Recommended with Discovery Required (MEDIUM)
5. **New York** - NYSED Data Website (needs verification)
6. **Nevada** - Nevada Report Card (needs URL pattern discovery)
7. **Pennsylvania** - PSSA data (needs portal access verification)
8. **South Dakota** - SD-STARS system (needs export verification)
9. **Oklahoma** - OSTP portal (needs data access verification)

### Tier 3: Not Recommended (BLOCKING)
10. **New Mexico** - Authentication required, no public API

---

## Common Themes Across States

### Assessment Types (Most Common):
- **Smarter Balanced (SBAC):** NV, OR, RI
- **State-Specific Grades 3-8:** All states
- **Science Assessments:** All states (typically grades 5, 8, HS)
- **ELP Assessments:** ACCESS/WIDA in all states
- **Alternate Assessments:** DLM or state-specific alternate

### Data Access Patterns:
- **Direct Downloads:** OH, OR, SC
- **Interactive Portals:** NV, RI
- **Authentication Required:** NM
- **Unknown/Needs Research:** OK, PA, SD

### Typical Schema Elements:
- School Year
- District Code & Name
- School Code & Name
- Grade Level
- Subject (ELA, Math, Science)
- Student Group (demographics, ELL, SpED, etc.)
- Performance Level/Proficiency
- Number Tested & Number Proficient
- Percentage Proficient

---

## Next Steps for Each State

### For Recommended States:
1. **Download sample files** (3 years: earliest, middle, recent)
2. **Document schema** (column names, data types)
3. **Test URL patterns** (check if predictable)
4. **Create EXPANSION.md** with detailed findings
5. **Develop implementation plan** with todo list

### For States Needing Research:
1. **Contact state DOE** for data access information
2. **Explore portals** to find download options
3. **Check for APIs** or bulk download options
4. **Document findings** in EXPANSION.md

### For Blocked States:
1. **Document barrier** (e.g., auth required)
2. **Research workarounds** (e.g., IPRA request)
3. **Mark as NOT RECOMMENDED** in EXPANSION.md

---

## Data Quality Considerations

### Red Flags to Watch For:
- **Suppression:** Small n (<10) may show *, N/A, or <10
- **Masking:** Ranges (e.g., ">=95%") instead of exact values
- **Opt-Outs:** High opt-out rates (OR, NY notable) may affect data
- **COVID Gaps:** 2020 data may be missing or unreliable
- **Assessment Changes:** Transition years (e.g., PARCC → NM-MSSA)

### Data Validation Rules:
- Proficiency rates should be 0-100%
- State total ≈ sum of districts
- Proficient + Not Proficient = Total Tested
- No negative values
- No infinity or NaN values

---

## Estimated Implementation Effort

### Per State (Recommended Tier):
- **Discovery:** 2-4 hours (download samples, document schema)
- **Implementation:** 8-16 hours (get_raw, process, tidy, fetch)
- **Testing:** 4-8 hours (write and run tests)
- **Documentation:** 2-4 hours (EXPANSION.md, code comments)
- **Total:** 16-32 hours per state

### For All 10 States:
- **Tier 1 (4 states):** 64-128 hours
- **Tier 2 (5 states):** 80-160 hours
- **Total:** 144-288 hours (18-36 work days)

**Note:** Excludes NM (not recommended)

---

## Contact Information (State DOEs)

- **New Mexico:** adaminfo@doe.nm.gov
- **Nevada:** adaminfo@doe.nv.gov
- **New York:** [via NYSED contact form](https://www.nysed.gov/contact)
- **Ohio:** [Report Card support](https://reportcard.education.ohio.gov/)
- **Oklahoma:** [SDE contact page](https://oklahoma.gov/education/contact.html)
- **Oregon:** [ODE contact](https://www.oregon.gov/ode/contact-us)
- **Pennsylvania:** [PDE contact](https://www.pa.gov/agencies/education/)
- **Rhode Island:** [RIDE contact](https://ride.ri.gov/contact-us)
- **South Carolina:** [SCDE contact](https://ed.sc.gov/contact/)
- **South Dakota:** [SD DOE contact](https://doe.sd.gov/)

---

## Conclusion

Assessment data research completed for all 10 assigned states:

✅ **6 states recommended for implementation** (NY, OH, OR, RI, SC + NV with caveats)
⚠️ **3 states need further research** (OK, PA, SD)
❌ **1 state not recommended** (NM - blocked by authentication)

**Most Promising for Quick Wins:** Ohio, Oregon, South Carolina, Rhode Island

**Key Success Factors:**
- Direct download URLs (no portal navigation)
- Excel/CSV format (not PDF)
- Consistent schema across years
- Public access (no authentication)

**Recommended Next Actions:**
1. Prioritize Tier 1 states for implementation
2. Contact Tier 2 state DOEs for data access guidance
3. Document NM barrier in package for future reference

---

**Sources:**
All state-specific sources listed in individual state summaries above.
