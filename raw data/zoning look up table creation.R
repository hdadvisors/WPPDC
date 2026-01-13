library(tidyverse)

## Zoning ordinances have hyphenated districts, but the parcel data is not. Therefore, save the lookup table in a way that can be used with parcel data.

# Danville zoning lookup table
danville_zoning <- data.frame(
  locality = "Danville",
  zone_code = c("SR", "TR", "SR", "NTR", "OTR", "AR", "MR", "MHP",
                "TOC", "NC", "CBC", "TWC", "HRC", "PSC",
                "LEDI", "CP1", "MI",
                "HPO", "AO", "FPO", "PSCO", "CE", "RDO"),
  zone_name = c("Sandy River Residential",
                "Threshold Residential",
                "Suburban Residential",
                "Neo-Traditional Residential",
                "Old Town Residential",
                "Attached Residential",
                "Multi-family Residential",
                "Manufactured Home Park",
                "Transitional Office",
                "Neighborhood Commercial",
                "Central Business Commercial",
                "Tobacco Warehouse Commercial",
                "Highway Retail Commercial",
                "Planned Shopping Center Commercial",
                "Light Economic Development",
                "Cyber Park One",
                "Manufacturing",
                "Historic Preservation Overlay",
                "Airport Overlay",
                "Floodplain Overlay",
                "Planned Shopping Center Overlay",
                "Casino Entertainment",
                "River District Overlay"),
  zone_category = c("Residential", "Residential", "Residential", "Residential",
                    "Residential", "Residential", "Residential", "Residential",
                    "Office/Commercial", "Commercial", "Commercial", "Commercial",
                    "Commercial", "Commercial",
                    "Industrial", "Industrial", "Industrial",
                    "Overlay", "Overlay", "Overlay", "Overlay", "Special", "Overlay"),
  stringsAsFactors = FALSE
)

# Save it
write.csv(danville_zoning, "analyzed data/danville_zoning_lookup.csv", row.names = FALSE)

# Franklin County zoning lookup table 
franklin_zoning <- data.frame(
  locality = "Franklin County",
  zone_code = c("A1", "RE", "R1", "R2", "RC1", "C1", "RMF", "RPD",
                "B1", "B2", "GB",
                "M1", "M2",
                "PCD", "REP",
                "SML", "SM", "POS", "NZ"),
  zone_name = c("Agricultural District",
                "Residential Estates District",
                "Residential Suburban Subdivision District R-1",
                "Residential Suburban Subdivision District R-2",
                "Residential Combined Subdivision District",
                "Residential Combined Subdivision District",  # C1 same as RC-1
                "Residential Multifamily District",
                "Residential Planned Development District",
                "Business District, Limited",
                "Business District, General",
                "Business District, General",  # GB same as B-2
                "Industrial District, Light Industry",
                "Industrial District, Heavy Industry",
                "Planned Commercial Development",
                "Regional Enterprise Park District",
                "Smith Mountain Lake Surface District",
                "Smith Mountain",
                "Parks/Open Space",
                "Not Zoned"),
  zone_category = c("Agricultural", 
                    "Residential", "Residential", "Residential", "Residential", 
                    "Residential", "Residential", "Residential",
                    "Commercial", "Commercial", "Commercial",
                    "Industrial", "Industrial",
                    "Commercial", "Industrial",
                    "Overlay/Special", "Overlay/Special", "Parks/Open Space", 
                    "Unzoned"),
  stringsAsFactors = FALSE
)

# Save it
write.csv(franklin_zoning, "analyzed data/franklin_zoning_lookup.csv", row.names = FALSE)


# Henry County zoning lookup table 
henry_zoning <- data.frame(
  locality = "Henry County",
  zone_code = c("A1", "RR", "MR", "SR",
                "B3", "B2", "B1",
                "I2", "I1",
                "GS",
                "CO", "AO"),
  zone_name = c("Agricultural District",
                "Rural Residential District",
                "Mixed Residential District",
                "Suburban Residential District",
                "Office and Professional District",
                "Neighborhood Commercial District",
                "General Commercial District",
                "Limited Industrial District",
                "Industrial District",
                "Government and Special Use District",
                "Conservation Overlay District",
                "Airport Overlay District"),
  zone_category = c("Agricultural",
                    "Residential", "Residential", "Residential",
                    "Commercial", "Commercial", "Commercial",
                    "Industrial", "Industrial",
                    "Government/Special",
                    "Overlay", "Overlay"),
  stringsAsFactors = FALSE
)

# Save it
write.csv(henry_zoning, "analyzed data/henry_zoning_lookup.csv", row.names = FALSE)

# Martinsville City zoning lookup table (This one USES hyphens)

martinsville_zoning <- data.frame(
  locality = "Martinsville",
  zone_code = c("R-E", "R-N", "R-C", "R-T", "C-N", "C-UB", "C-C", "ED-MA",
                "ED-G", "ED-I"),
  zone_name = c("Estate Residential District", 
                "Neighborhood Residential District",
                "City Residential District",
                "Residential Transitional District",
                "Neighborhood Commercial District",
                "Uptown Business District",
                "Corridor Commercial District",
                "Economic Development District-Medical and Academic",
                "Economic Development District-General",
                "Economic Development District-Intensive"),
  zone_category = c("Residential", "Residential", "Residential", "Residential",
                    "Commercial", "Commercial", "Commercial",
                    "Economic Development", "Economic Development", "Economic Development"),
  stringsAsFactors = FALSE
)

# Save it
write.csv(martinsville_zoning, "analyzed data/martinsville_zoning_lookup.csv", row.names = FALSE)

# Patrick County does not have zoning 

# Pittsylvania County zoning lookup table

pittsylvania_zoning <- data.frame(
  locality = "Pittsylvania County",
  zone_code = c("A-1", "RE", "R-1", "RC-1", "RMF", "RPD", "MHP",
                "B-1", "B-2",
                "M-1", "M-2",
                "C-1",
                "DZ"),
  zone_name = c("Agricultural District",
                "Residential Estates District",
                "Residential Suburban Subdivision District",
                "Residential Combined Subdivision District",
                "Residential Multi-Family District",
                "Residential Planned Unit Development District",
                "Residential Manufactured Housing Park District",
                "Business District, Limited",
                "Business District, General",
                "Industrial District, Light Industry",
                "Industrial District, Heavy Industry",
                "Conservation District",
                "Unknown/Other"),
  zone_category = c("Agricultural",
                    "Residential", "Residential", "Residential", 
                    "Residential", "Residential", "Residential",
                    "Commercial", "Commercial",
                    "Industrial", "Industrial",
                    "Conservation",
                    "Other"),
  stringsAsFactors = FALSE
)

# Save it
write.csv(pittsylvania_zoning, "analyzed data/pittsylvania_zoning_lookup.csv", row.names = FALSE)

# ============================================
# PART 2: Combine all lookup tables
# ============================================
library(dplyr)

all_zoning_lookup <- bind_rows(
  danville_zoning,
  henry_zoning,
  martinsville_zoning,
  pittsylvania_zoning,
  franklin_zoning
)

# Save master lookup table
write.csv(all_zoning_lookup, "analyzed data/pdc_zoning_lookup.csv", row.names = FALSE)
