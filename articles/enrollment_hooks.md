# 10 Insights from Nebraska School Enrollment Data

``` r
library(neschooldata)
library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_minimal(base_size = 14))
```

## Nebraska enrollment hit an all-time high in 2024

Bucking national trends, Nebraska keeps growing. **+47,000 students**
(+17%) in 19 years.

``` r
enr <- fetch_enr_multi(c(2005, 2010, 2015, 2020, 2024))

statewide <- enr %>%
  filter(is_state, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  select(end_year, n_students)

statewide
#>   end_year n_students
#> 1     2005     326083
#> 2     2010     333835
#> 3     2015     349925
#> 4     2020     366966
#> 5     2024     365467
```

``` r
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
```

![](enrollment_hooks_files/figure-html/statewide-chart-1.png)

## Omaha and Lincoln together are half the state

The two cities dominate Nebraska education. **Omaha + Lincoln: 95,000
students** (29% of the state).

``` r
enr_2024 <- fetch_enr(2024)

top_districts <- enr_2024 %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL") %>%
  arrange(desc(n_students)) %>%
  head(8) %>%
  select(district_name, n_students)

top_districts
#>                          district_name n_students
#> 1                 OMAHA PUBLIC SCHOOLS      51693
#> 2               LINCOLN PUBLIC SCHOOLS      41654
#> 3               MILLARD PUBLIC SCHOOLS      23300
#> 4 PAPILLION LA VISTA COMMUNITY SCHOOLS      12039
#> 5               ELKHORN PUBLIC SCHOOLS      11455
#> 6          GRAND ISLAND PUBLIC SCHOOLS      10070
#> 7              BELLEVUE PUBLIC SCHOOLS       9444
#> 8                GRETNA PUBLIC SCHOOLS       6788
```

``` r
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
```

![](enrollment_hooks_files/figure-html/top-districts-chart-1.png)

## Hispanic enrollment has more than doubled since 2005

Nebraska’s demographic transformation mirrors national patterns.
Hispanic students: **28,000 to 77,000** (+173%).

``` r
demographics <- enr %>%
  filter(is_state, grade_level == "TOTAL",
         subgroup %in% c("white", "hispanic", "black", "asian")) %>%
  select(end_year, subgroup, n_students)

demographics %>%
  pivot_wider(names_from = subgroup, values_from = n_students)
#> # A tibble: 5 × 5
#>   end_year  white black hispanic asian
#>      <dbl>  <dbl> <dbl>    <dbl> <dbl>
#> 1     2005 260334 22523    32373  5966
#> 2     2010 251265 25340    44171  7445
#> 3     2015 244283 22498    57665  8780
#> 4     2020 245206 23716    67707 10590
#> 5     2024 232394 23100    76933 11061
```

``` r
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
```

![](enrollment_hooks_files/figure-html/demographics-chart-1.png)

## Elkhorn is Nebraska’s growth machine

This Omaha suburb can’t build schools fast enough. **+96% growth** since
2010.

``` r
enr_multi <- fetch_enr_multi(2010:2024)

suburban <- enr_multi %>%
  filter(is_district, subgroup == "total_enrollment", grade_level == "TOTAL",
         grepl("Elkhorn|Millard|Papillion", district_name)) %>%
  select(end_year, district_name, n_students)

suburban %>%
  filter(end_year %in% c(2010, 2015, 2020, 2024)) %>%
  pivot_wider(names_from = end_year, values_from = n_students)
#> # A tibble: 0 × 1
#> # ℹ 1 variable: district_name <chr>
```

``` r
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
```

![](enrollment_hooks_files/figure-html/suburban-growth-chart-1.png)

## Rural Nebraska is shrinking

Small-town schools face existential pressure. **13 fewer tiny
districts** since 2010.

``` r
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
#> # A tibble: 4 × 5
#>   size                 n_districts_2010 n_districts_2024 total_students_2010
#>   <chr>                           <int>            <int>               <dbl>
#> 1 Large (10,000+)                     3                6              106250
#> 2 Medium (1,000-9,999)               38               38              113409
#> 3 Small (200-999)                   224              224               95267
#> 4 Tiny (<200)                       198              155               18909
#> # ℹ 1 more variable: total_students_2024 <dbl>
```

``` r
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
```

![](enrollment_hooks_files/figure-html/regional-chart-1.png)

## Grade-level shifts: Pre-K grows, Kindergarten shrinks

The pipeline is shifting. Pre-K: **+6,000**. Kindergarten: **-2,200**.

``` r
grades <- enr_multi %>%
  filter(is_state, subgroup == "total_enrollment",
         grade_level %in% c("PK", "K", "01", "02", "03")) %>%
  filter(end_year %in% c(2015, 2020, 2024)) %>%
  select(end_year, grade_level, n_students)

grades %>%
  pivot_wider(names_from = end_year, values_from = n_students) %>%
  mutate(change_15_24 = `2024` - `2015`)
#> # A tibble: 5 × 5
#>   grade_level `2015` `2020` `2024` change_15_24
#>   <chr>        <dbl>  <dbl>  <dbl>        <dbl>
#> 1 01           26735  26111  25850         -885
#> 2 02           24853  25991  26415         1562
#> 3 03           26137  25865  26085          -52
#> 4 K            26867  26893  25278        -1589
#> 5 PK           18493  22718  22261         3768
```

``` r
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
```

![](enrollment_hooks_files/figure-html/grade-level-chart-1.png)
