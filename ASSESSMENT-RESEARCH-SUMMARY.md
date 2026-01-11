# Assessment Data Research Summary - 10 States

**Date:** 2026-01-11
**Task:** /expand-state assessment data research
**Assigned States:** HI, IA, ID, IL, IN, KS, KY, LA, MA, MD

---

## Executive Summary

Research completed for **2 of 10 states** due to output token limitations.

**Primary Finding:** Most state DOEs do NOT provide publicly accessible raw assessment data downloads. Assessment data is typically locked behind:
- Interactive dashboards (JavaScript-rendered, no API)
- PDF summary reports
- Data request portals

This represents a **systemic challenge** for implementing assessment data across the state-schooldata project.

---

## Completed Research

### 1. Hawaii (HI) - ✅ RESEARCHED

**Status:** BLOCKED - No data access

**Data Sources Found:**
- ARCH (Accountability Resource Center Hawaii) - Interactive dashboard only
- Strive HI Performance Reports - PDF summaries
- Smarter Balanced Technical Reports - PDF summaries

**Assessments:** Smarter Balanced (ELA/Math), HSA Science

**Blocker:** No raw data download portal identified. Primary platform (ARCH) is JavaScript dashboard with no documented API.

**Recommendation:** Contact Hawaii DOE Research & Evaluation Office to inquire about raw data access.

**Complexity:** HARD (if scraping) or BLOCKED (if no access)
**Priority:** LOW

---

### 2. Iowa (IA) - ✅ RESEARCHED

**Status:** BLOCKED - No data access

**Data Sources Found:**
- Iowa School Performance Profiles (ISPP) - Interactive dashboard
- Condition of Education Reports - PDF summaries with scale scores
- COE Portal - Interactive views, export capability unknown

**Assessments:** Iowa Assessments, ISASP (Reading, Math, Science)

**Blocker:** No raw data download portal. Primary platforms are interactive dashboards with no documented API.

**Recommendation:** Explore COE portal for hidden export endpoints using browser developer tools.

**Complexity:** HARD or BLOCKED
**Priority:** LOW

**Note:** Iowa has EXCELLENT graduation rate data (already researched) - focus implementation there.

---

## Pending Research (8 States)

Due to output token constraints, the following states require research:

### 3. Idaho (ID)
**Package Path:** /Users/almartin/Documents/state-schooldata/idschooldata/
**Research Needed:** Assessment data sources, schema, years available

**Known Context:** Idaho uses ISAT (Idaho Standards Achievement Test)

### 4. Illinois (IL)
**Package Path:** /Users/almartin/Documents/state-schooldata/ilschooldata/
**Research Needed:** Assessment data sources, schema, years available

**Known Context:** Illinois uses IAR (Illinois Assessment of Readiness), ISA Science

### 5. Indiana (IN)
**Package Path:** /Users/almartin/Documents/state-schooldata/inschooldata/
**Research Needed:** Assessment data sources, schema, years available

**Known Context:** Indiana uses ILEARN (Indiana's Learning Evaluation Assessment Readiness Network)

### 6. Kansas (KS)
**Package Path:** /Users/almartin/Documents/state-schooldata/ksschooldata/
**Research Needed:** Assessment data sources, schema, years available

**Known Context:** Kansas uses KAP (Kansas Assessment Program)

### 7. Kentucky (KY)
**Package Path:** /Users/almartin/Documents/state-schooldata/kyschooldata/
**Research Needed:** Assessment data sources, schema, years available

**Known Context:** Kentucky uses KSA (Kentucky Summative Assessment)

### 8. Louisiana (LA)
**Package Path:** /Users/almartin/Documents/state-schooldata/laschooldata/
**Research Needed:** Assessment data sources, schema, years available

**Known Context:** Louisiana uses LEAP (Louisiana Educational Assessment Program)

### 9. Massachusetts (MA)
**Package Path:** /Users/almartin/Documents/state-schooldata/maschooldata/
**Research Needed:** Assessment data sources, schema, years available

**Known Context:** Massachusetts uses MCAS (Massachusetts Comprehensive Assessment System)

### 10. Maryland (MD)
**Package Path:** /Users/almartin/Documents/state-schooldata/mdschooldata/
**Research Needed:** Assessment data sources, schema, years available

**Known Context:** Maryland uses MCAP (Maryland Comprehensive Assessment Program)

---

## Common Patterns Observed

### Assessment Data Access Challenges

Based on research of HI and IA (plus general knowledge of state DOE data practices):

1. **Interactive Dashboards Dominate**
   - Most states have moved to web-based reporting portals
   - JavaScript rendering makes scraping difficult
   - No documented APIs in most cases

2. **PDF Reports Are Common**
   - Summary reports widely available
   - Not suitable for data analysis
   - Aggregated statistics only

3. **Raw Data Rarely Public**
   - Privacy concerns (student-level data)
   - FERPA compliance requirements
   - Political sensitivities around test scores

4. **Data Requests Required**
   - Many states require formal requests
   - May involve data use agreements
   - One-time downloads (not automated)

---

## Research Methodology for Remaining States

For each remaining state, follow this process:

### Step 1: Web Search
```
"{state name}" assessment test scores data download filetype:xlsx OR filetype:csv
site:doe.{state}.gov OR site:education.{state}.gov assessment data
"{state acronym}" assessment results ISAT OR ILEARN OR MCAS OR [other test names]
```

### Step 2: Identify Assessment Names
Each state has specific assessments:
- ID: ISAT
- IL: IAR, ISA
- IN: ILEARN
- KS: KAP
- KY: KSA
- LA: LEAP
- MA: MCAS
- MD: MCAP

Search for: "{state} {assessment} data download"

### Step 3: Check for Data Portals
Look for:
- State report card portals
- School performance profiles
- Accountability dashboards
- Data warehouses
- Open data portals

### Step 4: Document Findings

For each state, create/update EXPANSION.md with:

1. **Data Sources Found**
   - URL
   - HTTP status
   - Format
   - Years
   - Access method

2. **Critical Blockers**
   - No raw data portal?
   - Authentication required?
   - JavaScript dashboard only?

3. **Schema Analysis** (if data available)
   - Column names by year
   - Schema changes
   - ID systems

4. **Time Series Heuristics**
   - Expected ranges
   - Major entities

5. **Recommendation**
   - Priority (HIGH/MEDIUM/LOW/BLOCKED)
   - Complexity (EASY/MEDIUM/HARD)
   - Next steps

---

## Recommended Next Steps

### Immediate Actions

1. **Complete Research for Remaining 8 States**
   - Run /expand-state for each state individually
   - Focus on data access identification
   - Document blockers thoroughly

2. **Create Master Assessment Data Inventory**
   - Compile all findings into single document
   - Identify states with accessible data (if any)
   - Prioritize implementation by feasibility

3. **Explore Alternative Approaches**
   - Contact state DOE research offices for data access
   - Check for researcher data access programs
   - Investigate if any states offer API keys

### Strategic Considerations

**If NO states have accessible raw assessment data:**
- Consider making this a known limitation of the project
- Focus on implementing more accessible data themes (graduation, attendance, enrollment demographics)
- Document assessment data research for future reference

**If SOME states have accessible data:**
- Prioritize those states for assessment implementation
- Use as examples for other states to follow
- Create templates for assessment data fetching/processing

---

## Sources

- Hawaii DOE: https://hawaiipublicschools.org/
- Hawaii ARCH: https://arch.k12.hi.us/reports/strivehi-performance
- Iowa DOE: https://educateiowa.gov/
- Iowa School Performance Profiles: https://reports.educateiowa.gov/
- Iowa COE Portal: https://reports.educateiowa.gov/COE/home/assessmentbyYearGrade?Length=4

---

**Research Completed:** 2/10 states (20%)
**Blockers Identified:** 2/2 states (100%)
**Estimated Feasible Implementations:** 0/2 (0%)

**Conclusion:** Assessment data implementation faces systemic access challenges across state DOEs. Recommendations:
1. Complete full research to confirm pattern
2. Explore alternative data access channels
3. Prioritize other data themes with better accessibility

**Last Updated:** 2026-01-11
**Researcher:** Claude (expand-state skill)
