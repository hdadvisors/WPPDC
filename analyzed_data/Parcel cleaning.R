# ============================================
# Load and combine parcel data
# ============================================

library(tidyverse)
library(readxl)

# Load each parcel dataset (adjust file paths and column names as needed)
danville_parcels <- read_excel("raw_data/danvilleparcels.xlsx")
henry_parcels <- read_excel("raw_data/Henryparcels.xlsx")
martinsville_parcels <- read_excel("raw_data/Martinsvilleparcels.xlsx")
pittsylvania_parcels <- read_excel("raw_data/Pittsylvaniaparcels.xlsx")
patrick_parcels <- read_excel("raw_data/Patrickparcels.xlsx")
franklin_parcels <- read_excel("raw_data/Franklinparcels.xlsx")

# Add locality column if not already present
danville_parcels <- danville_parcels %>% mutate(locality = "Danville City")
henry_parcels <- henry_parcels %>% mutate(locality = "Henry County")
martinsville_parcels <- martinsville_parcels %>% mutate(locality = "Martinsville City")
pittsylvania_parcels <- pittsylvania_parcels %>% mutate(locality = "Pittsylvania County")
patrick_parcels <- patrick_parcels %>% mutate(locality = "Patrick County")


# ============================================
# Standardize columns across datasets
# ============================================

# Standardize Danville (joins on account_id)
danville_clean <- danville_parcels %>%
  mutate(
    locality = "Danville",
    account_id = as.character(ACCOUNT),
    address_clean = toupper(trimws(ADDRESS)),
    OBJECTID = as.numeric(OBJECTID),
    zoning = ZONING,
    owner = OWNER1,
    address = ADDRESS,
    acres = as.numeric(ACRES),
    land_value = as.numeric(LAND),
    total_value = as.numeric(TOTAL),
    year_built = as.numeric(YEARBUILT)
  ) %>%
  select(locality, account_id, address_clean, OBJECTID, zoning, owner, address, 
         acres, land_value, total_value, year_built)

# Standardize Henry (joins on address_clean)
henry_clean <- henry_parcels %>%
  mutate(
    locality = "Henry County",
    account_id = as.character(ACCTNUMB),
    address_clean = toupper(trimws(PropAddr)),
    OBJECTID = as.numeric(OBJECTID),
    zoning = ZoneType,
    owner = OwnrName,
    address = PropAddr,
    acres = as.numeric(TotlAcre),
    land_value = as.numeric(TotlLVal),
    total_value = as.numeric(TotlMVal),
    year_built = as.numeric(YearBilt)
  ) %>%
  select(locality, account_id, address_clean, OBJECTID, zoning, owner, address, 
         acres, land_value, total_value, year_built)

# Standardize Martinsville (joins on address_clean)
martinsville_clean <- martinsville_parcels %>%
  mutate(
    locality = "Martinsville",
    account_id = as.character(ACCTTEXT),
    address_clean = toupper(trimws(PROPADDR)),
    OBJECTID = as.numeric(OBJECTID),
    zoning = ZONETYPE,
    owner = OWNRNAME,
    address = PROPADDR,
    acres = as.numeric(TOTLACRE),
    land_value = as.numeric(TOTLLVAL),
    total_value = as.numeric(TOTLMVAL),
    year_built = as.numeric(YEARBILT)
  ) %>%
  select(locality, account_id, address_clean, OBJECTID, zoning, owner, address, 
         acres, land_value, total_value, year_built)

# Standardize Pittsylvania (joins on account_id)
pittsylvania_clean <- pittsylvania_parcels %>%
  mutate(
    locality = "Pittsylvania County",
    account_id = as.character(ASSESSED_G),
    address_clean = toupper(trimws(Property_A)),
    OBJECTID = as.numeric(OBJECTID_1),
    zoning = PC_ZONE_CO,
    owner = Current_Ow,
    address = Property_A,
    acres = as.numeric(Acreage),
    land_value = as.numeric(Land_Value),
    total_value = as.numeric(Total_Tax_),
    year_built = NA_real_
  ) %>%
  select(locality, account_id, address_clean, OBJECTID, zoning, owner, address, 
         acres, land_value, total_value, year_built)

# Standardize Patrick (joins on account_id)
patrick_clean <- patrick_parcels %>%
  mutate(
    locality = "Patrick County",
    account_id = as.character(SMAPNUM),
    address_clean = toupper(trimws(E911_Str_1)),
    OBJECTID = as.numeric(OBJECTID),
    zoning = NA_character_,
    owner = Owner_Name,
    address = E911_Str_1,
    acres = as.numeric(Acres),
    land_value = as.numeric(Land_Value),
    total_value = as.numeric(Total_Valu),
    year_built = NA_real_
  ) %>%
  select(locality, account_id, address_clean, OBJECTID, zoning, owner, address, 
         acres, land_value, total_value, year_built)

# Standardize Franklin (joins on address_clean)
franklin_clean <- franklin_parcels %>%
  mutate(
    locality = "Franklin County",
    account_id = as.character(PIN),
    address_clean = toupper(trimws(FULLADDR)),
    OBJECTID = as.numeric(OBJECTID_1),
    zoning = zoning,
    owner = owner_name,
    address = FULLADDR,
    acres = as.numeric(acreage),
    land_value = as.numeric(land_value),
    total_value = as.numeric(total_asse),
    year_built = NA_real_
  ) %>%
  select(locality, account_id, address_clean, OBJECTID, zoning, owner, address, 
         acres, land_value, total_value, year_built)

# ============================================
# Combine all parcels
# ============================================


all_parcels <- bind_rows(
  danville_clean,
  henry_clean,
  martinsville_clean,
  pittsylvania_clean,
  patrick_clean,
  franklin_clean
)

# ============================================
# Join zoning lookup
# ============================================
pdc_zoning_lookup <- read_csv("analyzed_data/pdc_zoning_lookup.csv")

all_parcels_decoded <- all_parcels %>%
  left_join(pdc_zoning_lookup, by = c("locality" = "locality", 
                                      "zoning" = "zone_code"))

# Handle Patrick County (no zoning)
all_parcels_decoded <- all_parcels_decoded %>%
  mutate(
    zone_name = if_else(locality == "Patrick County", "No Zoning", zone_name),
    zone_category = if_else(locality == "Patrick County", "Unzoned", zone_category)
  )

# ============================================
# PART 5: Check for unmatched codes
# ============================================

# See if any zoning codes didn't match
unmatched <- all_parcels_decoded %>%
  filter(is.na(zone_name) & locality != "Patrick County") %>%
  count(locality, zoning) %>%
  arrange(desc(n))

print(unmatched)

# ============================================
# Save final output
# ============================================

cat("\n========== PARCEL SUMMARY ==========\n")
cat("Total parcels:", nrow(all_parcels_decoded), "\n\n")

all_parcels_decoded %>%
  count(locality) %>%
  print()

# ============================================
# STEP 7: Save final output
# ============================================

write.csv(all_parcels_decoded, "analyzed_data/pdc_master_parcels.csv", row.names = FALSE)

cat("\n✓ Saved to: analyzed_data/pdc_master_parcels.csv\n")

# ============================================
# JOIN KEY REFERENCE (for geodatabase script)
# ============================================
# Danville:      joins on account_id (ACCOUNT)
# Pittsylvania:  joins on account_id (ASSESSED_G)
# Patrick:       joins on account_id (SMAPNUM)
# Henry:         joins on address_clean (PropAddr)
# Martinsville:  joins on address_clean (PROPADDR)
# Franklin:      joins on address_clean (FULLADDR)
