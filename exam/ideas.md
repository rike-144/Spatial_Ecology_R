# Ideas for exam

## Intro

### Study area: 
- Lake Schwärzesee in Northern Brandenburg
- Lake Fresdorf in Southern Brandenburg

### Background:
Lake Fresdorf dried out completely between 2014 and 2024 and is now covered by vegetation.

### Research interest:
- What are the gradual trends we can detect between 2014 and 2024 for Lake Fresdorf?
- Are similar trends visible in Lake Schwärzesee?

## Explanation of the parameters I'll use
- NDVI
- NDWI
- why 2 classes
- why unsupervised classification is tricky


## Methods outline

**0. Get satellite map for both lakes**
- maybe just screenshot Google Earth?

**1. Download satellite data from Sentinel-2**
- two areas
- three years: 2015, 2020, 2025
- always similar date: June high temperatures but before extreme drought months, higher chance of clear weather
- 
  
**2. Load rasters into R**
- load libraries
- import raster with terra or imageRy

**3. Multitemporal analysis for Lake F**
- calculate NDWI (water index), NDVI (vegetation index)
- classification water vs non-water -> including counting and percentages
- ridgeline analysis

Output:
- water extent bar plot over time CHECK
- classification change map CHECK
- ndvi ridgeline plot (=vegetation shift/vegetation intrusion)

**4. Same analysis for Lake S**
- ...
- ...

**5. Display comparison**
- water area curve
- classification change maps side by side
- classification contingency table 2x3 (lake1/lake2 vs. water [%] year1/year2/year3
- ridgeline plots side by side

## Interpretation
- declining ndwi -> water loss
- increasing ndvi -> vegetation intrusion
- give possible reasons for the difference we see even though the lakes are neighbours

## Problems:
- water area stays similar but water depth is shrinking -> Verlandung von unten
- different hydrological conditions on the two lakes lead to different processes
- unsupervised calssification runs an independent k classification on all rasters -> thresholds may differ -> but at least a rough idea


Polygon Lake F: 
{"type":"Polygon","coordinates":[[[13.068967,52.264727],[13.068967,52.267315],[13.074996,52.267315],[13.074996,52.264727],[13.068967,52.264727]]]}

Polygon Lake K:
{"type":"Polygon","coordinates":[[[13.055449,52.270757],[13.04399,52.270757],[13.04399,52.265609],[13.055449,52.265609],[13.055449,52.270757]]]}





