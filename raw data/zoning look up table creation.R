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

# Franklin County zoning lookup table (codes without hyphens)
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
write.csv(franklin_zoning, "analyzed_data/franklin_zoning_lookup.csv", row.names = FALSE)