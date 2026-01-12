library(tidyverse)

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

