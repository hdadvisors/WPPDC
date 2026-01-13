# ============================================
# Geodatabase Cleaning Script
# Purpose: Load, clean, and standardize RLB geodatabase layers
#          Prepare join fields to match parcel data
# ============================================

library(sf)
library(tidyverse)

# ============================================
# STEP 1: Check available layers
# ============================================

st_layers("raw_data/Regional_Land_Bank.gdb")

# ============================================
# STEP 2: Load each layer
# ============================================

danville_rlb <- st_read("raw_data/Regional_Land_Bank.gdb", layer = "RLB_Danville_Parcels")
henry_rlb <- st_read("raw_data/Regional_Land_Bank.gdb", layer = "RLB_Henry_Parcels")
martinsville_rlb <- st_read("raw_data/Regional_Land_Bank.gdb", layer = "RLB_Martinsville_Parcels")
pittsylvania_rlb <- st_read("raw_data/Regional_Land_Bank.gdb", layer = "RLB_Pittsylvania_Parcels")
patrick_rlb <- st_read("raw_data/Regional_Land_Bank.gdb", layer = "RLB_Patrick_Parcels")
franklin_rlb <- st_read("raw_data/Regional_Land_Bank.gdb", layer = "RLB_Franklin_Parcels")

# ============================================
# STEP 3: Transform all to same CRS and drop Z dimension
# ============================================

# Using EPSG:3857 (WGS 84 / Pseudo-Mercator) for consistency
# Drop Z/M dimensions to avoid export errors (some layers have empty Z values)
danville_rlb <- st_transform(danville_rlb, 3857) %>% st_zm(drop = TRUE, what = "ZM")
henry_rlb <- st_transform(henry_rlb, 3857) %>% st_zm(drop = TRUE, what = "ZM")
martinsville_rlb <- st_transform(martinsville_rlb, 3857) %>% st_zm(drop = TRUE, what = "ZM")
pittsylvania_rlb <- st_transform(pittsylvania_rlb, 3857) %>% st_zm(drop = TRUE, what = "ZM")
patrick_rlb <- st_transform(patrick_rlb, 3857) %>% st_zm(drop = TRUE, what = "ZM")
franklin_rlb <- st_transform(franklin_rlb, 3857) %>% st_zm(drop = TRUE, what = "ZM")

# ============================================
# STEP 4: Create standardized join fields
# ============================================

# Danville - joins on account_id
danville_geom <- danville_rlb %>%
  mutate(
    locality = "Danville",
    account_id = as.character(ACCOUNT),
    address_clean = toupper(trimws(ADDRESS))
  ) %>%
  select(locality, account_id, address_clean)

# Henry - joins on address_clean
henry_geom <- henry_rlb %>%
  mutate(
    locality = "Henry County",
    account_id = as.character(ACCTNUMB),
    address_clean = toupper(trimws(PropAddr))
  ) %>%
  select(locality, account_id, address_clean)

# Martinsville - joins on address_clean
martinsville_geom <- martinsville_rlb %>%
  mutate(
    locality = "Martinsville",
    account_id = as.character(ACCTTEXT),
    address_clean = toupper(trimws(PROPADDR))
  ) %>%
  select(locality, account_id, address_clean)

# Pittsylvania - joins on account_id
pittsylvania_geom <- pittsylvania_rlb %>%
  mutate(
    locality = "Pittsylvania County",
    account_id = as.character(ASSESSED_G),
    address_clean = toupper(trimws(Property_A))
  ) %>%
  select(locality, account_id, address_clean)

# Patrick - joins on account_id
patrick_geom <- patrick_rlb %>%
  mutate(
    locality = "Patrick County",
    account_id = as.character(SMAPNUM),
    address_clean = toupper(trimws(E911_Str_1))
  ) %>%
  select(locality, account_id, address_clean)

# Franklin - joins on address_clean
franklin_geom <- franklin_rlb %>%
  mutate(
    locality = "Franklin County",
    account_id = as.character(PIN),
    address_clean = toupper(trimws(FULLADDR))
  ) %>%
  select(locality, account_id, address_clean)

# ============================================
# STEP 5: Combine all geometry layers
# ============================================

all_rlb_geom <- bind_rows(
  danville_geom,
  henry_geom,
  martinsville_geom,
  pittsylvania_geom,
  patrick_geom,
  franklin_geom
)

# ============================================
# STEP 6: Summary
# ============================================

cat("\n========== RLB GEODATABASE SUMMARY ==========\n")
cat("Total parcels with geometry:", nrow(all_rlb_geom), "\n\n")

all_rlb_geom %>%
  st_drop_geometry() %>%
  count(locality) %>%
  print()

cat("\nCRS:", st_crs(all_rlb_geom)$input, "\n")

# ============================================
# STEP 7: Save cleaned geodatabase
# ============================================

# Save as GeoPackage (preserves long field names better than shapefile)
st_write(all_rlb_geom, "analyzed_data/rlb_geometry_clean.gpkg", delete_dsn = TRUE)

cat("\n✓ Saved to: analyzed data/rlb_geometry_clean.gpkg\n")

# ============================================
# JOIN KEY REFERENCE
# ============================================
# Danville:      joins on account_id
# Pittsylvania:  joins on account_id
# Patrick:       joins on account_id
# Henry:         joins on address_clean
# Martinsville:  joins on address_clean
# Franklin:      joins on address_clean
