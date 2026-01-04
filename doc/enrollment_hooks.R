## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 8,
  fig.height = 5,
  warning = FALSE,
  message = FALSE
)

## ----packages-----------------------------------------------------------------
library(neschooldata)
library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_minimal(base_size = 14))

## ----statewide-data-----------------------------------------------------------
enr <- fetch_enr_multi(c(2005, 2010, 2015, 2020, 2024))

statewide <- enr %>%
  filter(is_state, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  select(end_year, n_students)

statewide

## ----statewide-chart----------------------------------------------------------
ggplot(statewide, aes(x = end_year, y = n_students)) +
  geom_line(color = "#2563eb", linewidth = 1.2) +
  geom_point(color = "#2563eb", size = 3) +
  scale_y_continuous(labels = scales::comma, limits = c(0, NA)) +
  labs(
    title = "Nebraska K-12 Enrollment (2005-2024)",
    subtitle = "Total public school enrollment continues to grow",
    x = "Year",
    y = "Students"
  )

## ----top-districts-data-------------------------------------------------------
enr_2024 <- fetch_enr(2024)

top_districts <- enr_2024 %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  arrange(desc(n_students)) %>%
  head(8) %>%
  select(district_name, n_students)

top_districts

## ----top-districts-chart------------------------------------------------------
top_districts %>%
  mutate(district_name = reorder(district_name, n_students)) %>%
  ggplot(aes(x = n_students, y = district_name)) +
  geom_col(fill = "#2563eb") +
  scale_x_continuous(labels = scales::comma) +
  labs(
    title = "Top 8 Nebraska School Districts by Enrollment (2024)",
    subtitle = "Omaha and Lincoln dominate state enrollment",
    x = "Students",
    y = NULL
  )

## ----demographics-data--------------------------------------------------------
demographics <- enr %>%
  filter(is_state, grade_level == "TOTAL",
         subgroup %in% c("white", "hispanic", "black", "asian")) %>%
  select(end_year, subgroup, n_students)

demographics %>%
  pivot_wider(names_from = subgroup, values_from = n_students)

## ----demographics-chart-------------------------------------------------------
demographics %>%
  mutate(subgroup = factor(subgroup,
                           levels = c("white", "hispanic", "black", "asian"),
                           labels = c("White", "Hispanic", "Black", "Asian"))) %>%
  ggplot(aes(x = end_year, y = n_students, color = subgroup)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = c("White" = "#6b7280", "Hispanic" = "#f59e0b",
                                "Black" = "#10b981", "Asian" = "#8b5cf6")) +
  labs(
    title = "Nebraska Enrollment by Race/Ethnicity (2005-2024)",
    subtitle = "Hispanic enrollment has more than doubled while White enrollment declined",
    x = "Year",
    y = "Students",
    color = "Race/Ethnicity"
  )

## ----suburban-growth-data-----------------------------------------------------
enr_multi <- fetch_enr_multi(2010:2024)

suburban <- enr_multi %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL",
         grepl("ELKHORN|MILLARD|PAPILLION", district_name, ignore.case = TRUE)) %>%
  select(end_year, district_name, n_students)

suburban %>%
  filter(end_year %in% c(2010, 2015, 2020, 2024)) %>%
  pivot_wider(names_from = end_year, values_from = n_students)

## ----suburban-growth-chart----------------------------------------------------
ggplot(suburban, aes(x = end_year, y = n_students, color = district_name)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  scale_y_continuous(labels = scales::comma) +
  scale_color_brewer(palette = "Set1") +
  labs(
    title = "Suburban District Growth (2010-2024)",
    subtitle = "Elkhorn has nearly doubled enrollment since 2010",
    x = "Year",
    y = "Students",
    color = "District"
  )

## ----regional-data------------------------------------------------------------
regional <- enr_multi %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  filter(end_year %in% c(2010, 2024)) %>%
  mutate(size = case_when(
    n_students >= 10000 ~ "Large (10,000+)",
    n_students >= 1000 ~ "Medium (1,000-9,999)",
    n_students >= 200 ~ "Small (200-999)",
    TRUE ~ "Tiny (<200)"
  )) %>%
  group_by(end_year, size) %>%
  summarize(n_districts = n(), total_students = sum(n_students), .groups = "drop")

regional %>%
  pivot_wider(names_from = end_year, values_from = c(n_districts, total_students))

## ----regional-chart-----------------------------------------------------------
regional %>%
  mutate(size = factor(size, levels = c("Tiny (<200)", "Small (200-999)",
                                         "Medium (1,000-9,999)", "Large (10,000+)"))) %>%
  ggplot(aes(x = size, y = total_students, fill = factor(end_year))) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("2010" = "#94a3b8", "2024" = "#2563eb")) +
  labs(
    title = "Enrollment by District Size (2010 vs 2024)",
    subtitle = "Large districts grow while small and tiny districts shrink",
    x = "District Size",
    y = "Total Students",
    fill = "Year"
  ) +
  theme(axis.text.x = element_text(angle = 15, hjust = 1))

## ----omaha-data---------------------------------------------------------------
omaha <- enr_multi %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL",
         grepl("OMAHA PUBLIC", district_name, ignore.case = TRUE)) %>%
  filter(end_year %in% c(2015, 2018, 2020, 2022, 2024)) %>%
  select(end_year, n_students) %>%
  mutate(change = n_students - lag(n_students))

omaha

## ----omaha-chart--------------------------------------------------------------
ggplot(omaha, aes(x = end_year, y = n_students)) +
  geom_line(color = "#dc2626", linewidth = 1.2) +
  geom_point(color = "#dc2626", size = 3) +
  scale_y_continuous(labels = scales::comma, limits = c(0, NA)) +
  labs(
    title = "Omaha Public Schools Enrollment (2015-2024)",
    subtitle = "Enrollment has declined steadily as suburbs grow",
    x = "Year",
    y = "Students"
  )

## ----grade-level-data---------------------------------------------------------
grades <- enr_multi %>%
  filter(is_state, subgroup == "total_enrollment",
         grade_level %in% c("PK", "K", "01", "02", "03")) %>%
  filter(end_year %in% c(2015, 2020, 2024)) %>%
  select(end_year, grade_level, n_students)

grades %>%
  pivot_wider(names_from = end_year, values_from = n_students) %>%
  mutate(change_15_24 = `2024` - `2015`)

## ----grade-level-chart--------------------------------------------------------
grades %>%
  mutate(grade_level = factor(grade_level,
                              levels = c("PK", "K", "01", "02", "03"),
                              labels = c("Pre-K", "K", "1st", "2nd", "3rd"))) %>%
  ggplot(aes(x = grade_level, y = n_students, fill = factor(end_year))) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("2015" = "#94a3b8", "2020" = "#60a5fa", "2024" = "#2563eb")) +
  labs(
    title = "Early Grade Enrollment (2015-2024)",
    subtitle = "Pre-K expands while Kindergarten enrollment declines",
    x = "Grade Level",
    y = "Students",
    fill = "Year"
  )

## ----grand-island-data--------------------------------------------------------
grand_island <- enr_2024 %>%
  filter(grepl("GRAND ISLAND", district_name, ignore.case = TRUE), is_district,
         grade_level == "TOTAL",
         subgroup %in% c("white", "hispanic", "black", "asian")) %>%
  mutate(pct = round(n_students / sum(n_students) * 100, 1)) %>%
  select(subgroup, n_students, pct) %>%
  arrange(desc(pct))

grand_island

## ----grand-island-chart-------------------------------------------------------
grand_island %>%
  mutate(subgroup = factor(subgroup,
                           levels = c("hispanic", "white", "black", "asian"),
                           labels = c("Hispanic", "White", "Black", "Asian"))) %>%
  ggplot(aes(x = reorder(subgroup, -pct), y = pct, fill = subgroup)) +
  geom_col() +
  scale_fill_manual(values = c("Hispanic" = "#f59e0b", "White" = "#6b7280",
                               "Black" = "#10b981", "Asian" = "#8b5cf6")) +
  labs(
    title = "Grand Island Public Schools Demographics (2024)",
    subtitle = "Nearly half of students are Hispanic",
    x = NULL,
    y = "Percent of Enrollment"
  ) +
  theme(legend.position = "none")

## ----covid-data---------------------------------------------------------------
covid <- enr_multi %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL",
         grepl("OMAHA PUBLIC|MILLARD|ELKHORN|PAPILLION", district_name, ignore.case = TRUE),
         end_year %in% c(2019, 2021)) %>%
  select(district_name, end_year, n_students) %>%
  pivot_wider(names_from = end_year, values_from = n_students) %>%
  rename(y2019 = `2019`, y2021 = `2021`) %>%
  mutate(pct_change = round((y2021 - y2019) / y2019 * 100, 1)) %>%
  arrange(pct_change)

covid

## ----covid-chart--------------------------------------------------------------
covid %>%
  ggplot(aes(x = reorder(district_name, pct_change), y = pct_change,
             fill = pct_change > 0)) +
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = c("TRUE" = "#10b981", "FALSE" = "#dc2626")) +
  labs(
    title = "Enrollment Change During COVID (2019-2021)",
    subtitle = "Urban districts lost students while suburbs grew",
    x = NULL,
    y = "Percent Change"
  ) +
  theme(legend.position = "none")

## ----diversity-data-----------------------------------------------------------
diversity <- enr_2024 %>%
  filter(is_state, grade_level == "TOTAL") %>%
  filter(subgroup %in% c("total_enrollment", "hispanic", "white", "black", "asian")) %>%
  select(subgroup, n_students) %>%
  mutate(pct = round(n_students / max(n_students) * 100, 1))

diversity

## ----diversity-chart----------------------------------------------------------
diversity %>%
  filter(subgroup != "total_enrollment") %>%
  mutate(subgroup = factor(subgroup,
                           levels = c("white", "hispanic", "black", "asian"),
                           labels = c("White", "Hispanic", "Black", "Asian"))) %>%
  ggplot(aes(x = reorder(subgroup, -pct), y = pct, fill = subgroup)) +
  geom_col() +
  scale_fill_manual(values = c("White" = "#6b7280", "Hispanic" = "#f59e0b",
                               "Black" = "#10b981", "Asian" = "#8b5cf6")) +
  labs(
    title = "Nebraska Statewide Demographics (2024)",
    subtitle = "Hispanic students now make up nearly a quarter of enrollment",
    x = NULL,
    y = "Percent of Enrollment"
  ) +
  theme(legend.position = "none")

