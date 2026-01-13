# ============================================
# PDC Master Parcels - Summary Statistics
# ============================================

library(tidyverse)

# Load the combined dataset
parcels <- read.csv("analyzed_data/pdc_master_parcels.csv")

# ============================================
# 1. ZONING TYPE BREAKDOWN
# ============================================

cat("\n========== ZONING SUMMARY ==========\n\n")

# Count by zone category (broad groupings)
zone_category_summary <- parcels %>%
  count(zone_category, name = "parcel_count") %>%
  mutate(
    percent = round(parcel_count / sum(parcel_count) * 100, 1)
  ) %>%
  arrange(desc(parcel_count))

cat("--- Parcels by Zone Category ---\n")
print(zone_category_summary)

# Count by specific zone name
zone_name_summary <- parcels %>%
  count(zone_name, name = "parcel_count") %>%
  mutate(
    percent = round(parcel_count / sum(parcel_count) * 100, 1)
  ) %>%
  arrange(desc(parcel_count))

cat("\n--- Parcels by Zone Name (Top 20) ---\n")
print(head(zone_name_summary, 20))

# Zoning by locality
zoning_by_locality <- parcels %>%
  count(locality, zone_category) %>%
  pivot_wider(
    names_from = zone_category,
    values_from = n,
    values_fill = 0
  )

cat("\n--- Zone Categories by Locality ---\n")
print(zoning_by_locality)

# ============================================
# 2. LOCATION SUMMARY
# ============================================

cat("\n\n========== LOCATION SUMMARY ==========\n\n")

# Total parcels by locality
locality_summary <- parcels %>%
  group_by(locality) %>%
  summarise(
    parcel_count = n(),
    total_acres = round(sum(acres, na.rm = TRUE), 1),
    avg_acres = round(mean(acres, na.rm = TRUE), 2),
    median_acres = round(median(acres, na.rm = TRUE), 2),
    .groups = "drop"
  ) %>%
  mutate(
    percent_parcels = round(parcel_count / sum(parcel_count) * 100, 1),
    percent_acres = round(total_acres / sum(total_acres) * 100, 1)
  ) %>%
  arrange(desc(parcel_count))

cat("--- Parcels by Locality ---\n")
print(locality_summary)

# ============================================
# 3. TOTAL VALUE SUMMARIES
# ============================================

cat("\n\n========== VALUE SUMMARY ==========\n\n")

# Overall value statistics
overall_values <- parcels %>%
  summarise(
    total_parcels = n(),
    total_value_sum = sum(total_value, na.rm = TRUE),
    total_land_value = sum(land_value, na.rm = TRUE),
    total_improvement_value = total_value_sum - total_land_value,
    avg_total_value = mean(total_value, na.rm = TRUE),
    median_total_value = median(total_value, na.rm = TRUE),
    min_total_value = min(total_value, na.rm = TRUE),
    max_total_value = max(total_value, na.rm = TRUE)
  )

cat("--- Overall Value Statistics ---\n")
cat("Total Assessed Value:    $", format(overall_values$total_value_sum, big.mark = ","), "\n")
cat("Total Land Value:        $", format(overall_values$total_land_value, big.mark = ","), "\n")
cat("Total Improvement Value: $", format(overall_values$total_improvement_value, big.mark = ","), "\n")
cat("Average Parcel Value:    $", format(round(overall_values$avg_total_value, 0), big.mark = ","), "\n")
cat("Median Parcel Value:     $", format(round(overall_values$median_total_value, 0), big.mark = ","), "\n")
cat("Min Parcel Value:        $", format(overall_values$min_total_value, big.mark = ","), "\n")
cat("Max Parcel Value:        $", format(overall_values$max_total_value, big.mark = ","), "\n")

# Value by locality
value_by_locality <- parcels %>%
  group_by(locality) %>%
  summarise(
    parcel_count = n(),
    total_value_sum = sum(total_value, na.rm = TRUE),
    land_value_sum = sum(land_value, na.rm = TRUE),
    avg_total_value = round(mean(total_value, na.rm = TRUE), 0),
    median_total_value = round(median(total_value, na.rm = TRUE), 0),
    .groups = "drop"
  ) %>%
  mutate(
    percent_of_total = round(total_value_sum / sum(total_value_sum) * 100, 1)
  ) %>%
  arrange(desc(total_value_sum))

cat("\n--- Value by Locality ---\n")
print(value_by_locality)

# Value by zone category
value_by_zone <- parcels %>%
  group_by(zone_category) %>%
  summarise(
    parcel_count = n(),
    total_value_sum = sum(total_value, na.rm = TRUE),
    avg_total_value = round(mean(total_value, na.rm = TRUE), 0),
    median_total_value = round(median(total_value, na.rm = TRUE), 0),
    .groups = "drop"
  ) %>%
  mutate(
    percent_of_total = round(total_value_sum / sum(total_value_sum) * 100, 1)
  ) %>%
  arrange(desc(total_value_sum))

cat("\n--- Value by Zone Category ---\n")
print(value_by_zone)

## Residential properties make up the largest share of the tax base (65% of total value), even though individual residential parcels are worth less on average than commercial or industrial.
## Commercial and industrial parcels are fewer in number but higher value per parcel - there are only 2,500 commercial parcels, but each one averages $480,000 compared to $100,000 for residential.
## The gap between average and median tells you about the distribution. If the average is much higher than the median (like in Commercial: $480k avg vs $320k median), it means a few high-value properties are pulling the average up.

# Value by locality AND zone category
value_by_locality_zone <- parcels %>%
  group_by(locality, zone_category) %>%
  summarise(
    parcel_count = n(),
    total_value = sum(total_value, na.rm = TRUE),
    avg_value = round(mean(total_value, na.rm = TRUE), 0),
    .groups = "drop"
  ) %>%
  arrange(locality, desc(total_value))

cat("\n--- Value by Locality and Zone Category ---\n")
print(value_by_locality_zone)

# ============================================
# 4. SAVE SUMMARY TABLES TO CSV
# ============================================

write.csv(zone_category_summary, "analyzed_data/summary_zone_category.csv", row.names = FALSE)
write.csv(locality_summary, "analyzed_data/summary_locality.csv", row.names = FALSE)
write.csv(value_by_locality, "analyzed_data/summary_value_by_locality.csv", row.names = FALSE)
write.csv(value_by_zone, "analyzed_data/summary_value_by_zone.csv", row.names = FALSE)

cat("\n\n========== SUMMARY TABLES SAVED ==========\n")
cat("Files saved to analyzed_data/ folder:\n")
cat("  - summary_zone_category.csv\n")
cat("  - summary_locality.csv\n")
cat("  - summary_value_by_locality.csv\n")
cat("  - summary_value_by_zone.csv\n")