# ============================================
# PDC Master Parcels - Summary Statistics & Mapping
# Using HDA Style Guide
# ============================================

library(tidyverse)
library(sf)
install.packages("devtools")
devtools::install_github("hdadvisors/hdatools")
library(hdatools)

# ============================================
# LOAD DATA
# ============================================

# Load the CSV dataset (for tabular analysis)
parcels <- read.csv("analyzed_data/pdc_master_parcels.csv")

# Load the spatial dataset (for mapping)
parcels_spatial <- st_read("analyzed_data/pdc_parcels_spatial.gpkg")

cat("Loaded", nrow(parcels), "parcels from CSV\n")
cat("Loaded", nrow(parcels_spatial), "parcels with geometry\n\n")

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

# ============================================
# 5. SPATIAL ANALYSIS
# ============================================

cat("\n\n========== SPATIAL ANALYSIS ==========\n\n")

# Calculate area from geometry (in acres)
parcels_spatial <- parcels_spatial %>%
  mutate(
    geom_area_sqm = as.numeric(st_area(geom)),
    geom_area_acres = geom_area_sqm / 4046.86  # convert sq meters to acres
  )

# Compare calculated area to reported acres
area_comparison <- parcels_spatial %>%
  st_drop_geometry() %>%
  summarise(
    reported_acres_total = sum(acres, na.rm = TRUE),
    calculated_acres_total = sum(geom_area_acres, na.rm = TRUE),
    difference = reported_acres_total - calculated_acres_total,
    pct_difference = round((difference / reported_acres_total) * 100, 1)
  )

cat("--- Area Comparison (Reported vs Calculated from Geometry) ---\n")
cat("Reported total acres:   ", round(area_comparison$reported_acres_total, 1), "\n")
cat("Calculated total acres: ", round(area_comparison$calculated_acres_total, 1), "\n")
cat("Difference:             ", round(area_comparison$difference, 1), " (", area_comparison$pct_difference, "%)\n")

# Spatial summary by locality
spatial_by_locality <- parcels_spatial %>%
  group_by(locality) %>%
  summarise(
    parcel_count = n(),
    total_geom_acres = round(sum(geom_area_acres), 1),
    .groups = "drop"
  )

cat("\n--- Spatial Summary by Locality ---\n")
print(spatial_by_locality)


# ============================================
# INTERACTIVE MAP (Leaflet)
# ============================================
install.packages("leaflet")
library(leaflet)
library(tigris)

# Get Virginia county boundaries
options(tigris_use_cache = TRUE)
va_counties <- counties(state = "VA", cb = TRUE) %>%
  st_transform(4326)

# Filter to just the PDC region counties/cities
pdc_localities <- c("Danville city", "Henry County", "Martinsville city", 
                    "Pittsylvania County", "Patrick County", "Franklin County")

pdc_boundaries <- va_counties %>%
  filter(NAMELSAD %in% pdc_localities)

# Transform parcels to WGS84 (required for leaflet)
parcels_wgs84 <- st_transform(parcels_spatial, 4326)

# Create palette with explicit matching
zone_levels <- c(
  "Agricultural",
  "Commercial", 
  "Economic Development",
  "Government/Special",
  "Industrial",
  "Office/Commercial",
  "Other",
  "Residential",
  "Unzoned"
)

zone_colors_ordered <- c(
  "#8baeaa",   # Agricultural - HDA Green
  "#e9ab3f",   # Commercial - HDA Yellow
  "#c75b42",   # Economic Development - Darker Coral
  "#5a8a84",   # Government/Special - Darker Green
  "#e76f52",   # Industrial - HDA Coral
  "#d4a03a",   # Office/Commercial - Darker Yellow
  "#bdc3c7",   # Other - Light Gray
  "#445ca9",   # Residential - HDA Blue
  "#95a5a6"    # Unzoned - Gray
)

# Create palette function with explicit order
zone_pal <- colorFactor(
  palette = zone_colors_ordered,
  levels = zone_levels,
  na.color = "#cccccc"
)


# Create interactive map
map_interactive <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  
  # Add county/city boundaries first (so parcels appear on top)
  addPolygons(
    data = pdc_boundaries,
    fillColor = "transparent",
    fillOpacity = 0,
    color = "#333333",
    weight = 1,
    opacity = 1,
    label = ~NAMELSAD
  ) %>%
  
  # Add parcels
  addPolygons(
    data = parcels_wgs84,
    fillColor = ~zone_pal(zone_category),
    fillOpacity = 0.7,
    color = "white",
    weight = 1,
    popup = ~paste(
      "<strong>", address, "</strong><br>",
      "Locality: ", locality, "<br>",
      "Zoning: ", zone_name, "<br>",
      "Category: ", zone_category, "<br>",
      "Acres: ", round(acres, 2), "<br>",
      "Total Value: $", format(total_value, big.mark = ",")
    )
  ) %>%
  
  addLegend(
    position = "bottomright",
    pal = zone_pal,
    values = parcels_wgs84$zone_category,
    title = "Zone Category"
  )

# Display the map
map_interactive

# Save as HTML file
saveWidget(map_interactive, "analyzed_data/map_interactive_parcels.html", selfcontained = TRUE)
cat("✓ Saved: map_interactive_parcels.html\n")

# ============================================
# SPATIAL CONCENTRATION ANALYSIS
# ============================================

library(sf)
library(tidyverse)

# ============================================
# 1. CLUSTERING ANALYSIS - Find parcel clusters
# ============================================

# Get centroids of all parcels
parcel_centroids <- parcels_spatial %>%
  st_centroid()

# Calculate distances between parcels to identify clusters
# Using DBSCAN clustering (density-based)
install.packages("dbscan")
library(dbscan)

# Extract coordinates
coords <- parcel_centroids %>%
  st_coordinates()

# Run DBSCAN clustering
# eps = distance threshold in meters (500m = ~0.3 miles)
# minPts = minimum parcels to form a cluster
clusters <- dbscan(coords, eps = 500, minPts = 5)

# Add cluster IDs back to data
parcels_spatial$cluster <- clusters$cluster

# Summarize clusters
cluster_summary <- parcels_spatial %>%
  st_drop_geometry() %>%
  filter(cluster > 0) %>%  # Exclude noise (cluster = 0)
  group_by(cluster, locality) %>%
  summarise(
    parcel_count = n(),
    total_acres = round(sum(acres, na.rm = TRUE), 1),
    total_value = sum(total_value, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(parcel_count))

cat("\n========== PARCEL CLUSTERS ==========\n")
cat("Clusters with 5+ parcels within 500m of each other:\n\n")
print(cluster_summary)

# ============================================
# 2. HEATMAP / DENSITY - Visual concentration
# ============================================

# Create convex hulls around each cluster for visualization
cluster_hulls <- parcels_spatial %>%
  filter(cluster > 0) %>%
  group_by(cluster) %>%
  summarise(
    parcel_count = n(),
    total_acres = round(sum(acres, na.rm = TRUE), 1),
    total_value = sum(total_value, na.rm = TRUE),
    geometry = st_convex_hull(st_union(geom))
  ) %>%
  ungroup()

# ============================================
# 3. ADD CLUSTERS TO INTERACTIVE MAP
# ============================================

# Transform for leaflet
cluster_hulls_wgs84 <- st_transform(cluster_hulls, 4326)
parcels_wgs84 <- st_transform(parcels_spatial, 4326)

# Color palette for clusters
cluster_pal <- colorNumeric(
  palette = "YlOrRd",
  domain = cluster_hulls_wgs84$parcel_count
)

# Create map with cluster visualization
map_clusters <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  
  # County boundaries
  addPolygons(
    data = pdc_boundaries,
    fillColor = "transparent",
    fillOpacity = 0,
    color = "#333333",
    weight = 2,
    opacity = 1,
    label = ~NAMELSAD
  ) %>%
  
  # Cluster hulls (concentration areas)
  addPolygons(
    data = cluster_hulls_wgs84,
    fillColor = ~cluster_pal(parcel_count),
    fillOpacity = 0.3,
    color = "#e76f52",
    weight = 2,
    popup = ~paste(
      "<strong>Cluster ", cluster, "</strong><br>",
      "Parcels: ", parcel_count, "<br>",
      "Total Acres: ", total_acres, "<br>",
      "Total Value: $", format(total_value, big.mark = ",")
    )
  ) %>%
  
  # Individual parcels
  addPolygons(
    data = parcels_wgs84,
    fillColor = ~zone_pal(zone_category),
    fillOpacity = 0.7,
    color = "white",
    weight = 1,
    popup = ~paste(
      "<strong>", address, "</strong><br>",
      "Locality: ", locality, "<br>",
      "Zoning: ", zone_name, "<br>",
      "Category: ", zone_category, "<br>",
      "Acres: ", round(acres, 2), "<br>",
      "Total Value: $", format(total_value, big.mark = ",")
    )
  ) %>%
  
  addLegend(
    position = "bottomright",
    pal = zone_pal,
    values = parcels_wgs84$zone_category,
    title = "Zone Category"
  ) %>%
  
  addLegend(
    position = "bottomleft",
    pal = cluster_pal,
    values = cluster_hulls_wgs84$parcel_count,
    title = "Cluster Size"
  )

map_clusters

# Save
saveWidget(map_clusters, "analyzed_data/map_parcel_clusters.html", selfcontained = TRUE)
cat("✓ Saved: map_parcel_clusters.html\n")

