# West Piedmont Planning District Commission (WPPDC) Parcel Analysis

## Overview

This repository contains an interactive analysis of parcels across the West Piedmont Planning District Commission region, supporting the Regional Land Bank Working Group's strategic planning efforts.

## Analysis Summary

The analysis examines parcels across six localities in the WPPDC region:
- Danville city
- Henry County
- Martinsville city
- Pittsylvania County
- Patrick County
- Franklin County

### Key Features

**Summary Statistics:**
- Geographic distribution of parcels by locality
- Zoning category breakdowns with interactive visualizations
- Assessed value analysis by location and zone type
- Comparative analysis across jurisdictions

**Interactive Components:**
- Hover-enabled charts showing detailed parcel information
- Interactive map centered on Danville with parcel-level details
- Filterable visualizations by zone category and locality

### Data Included

- Total parcel count and acreage
- Zoning classifications (standardized across jurisdictions)
- Assessed values (total, land, and improvement values)
- Geographic boundaries and spatial data

## Files

- `pdc_parcel_analysis.qmd` - Main Quarto document for analysis
- `pdc_master_parcels.csv` - Tabular parcel data
- `pdc_parcels_spatial.gpkg` - Spatial parcel data (GeoPackage format)

## Rendering the Analysis

To render the HTML report:

```bash
quarto render pdc_parcel_analysis.qmd
```

### Requirements

- R (4.0+)
- Quarto
- R packages: `tidyverse`, `sf`, `leaflet`, `tigris`, `knitr`, `kableExtra`, `ggiraph`, `hdatools`

## Confidentiality

This analysis was conducted in conjunction with land bank recommendations and research for the WPPDC. **This analysis is not for public distribution** and is intended for internal use by the Regional Land Bank Working Group and WPPDC stakeholders only.

## Contact

**HDAdvisors**

For questions about this analysis, contact the West Piedmont Planning District Commission or HDAdvisors.

---

*Analysis Date: 2025*
