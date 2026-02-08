
#### Name: Friederike Ulandowski

# Spatial Ecology in R exam

## 1. Introduction
### Research topic:
**Comparison of lake water content in two inland lakes over a time period of 10 years**
<p>
<br>
</p>

### Study area:
Southern Brandenburg, Germany, ca. 30 km south of Berlin
- Lake Fresdorf: ca. 7 ha
- Lake Kähnsdorf ca. 20 ha
<p>
<br>
</p>

**Aerial view:** 

![Large area](images/Screenshot_large_area_marked.jpg)
![Zoomed area](images/Screenshot_zoomed.jpg)
<p>
<br>
</p>


### Research background: </p>
<p> 
The shallow Lake Fresdorf, 30 km south of Berlin, has dried out and been taken over by vegetation in the last 10 years, now resembling peatland more than the lake it once was. The process has been rapid, vanishing the lake within a decade, and was accelerated by the extremely dry summers of 2018, 2019 and 2020. As the lake was part of a larger chain of lakes in the region, this exam project investigates whether similarly threatening trends can be observed in the nearby Lake Kähnsdorf, only 1.5 km westwards, or if the two lakes follow different hydrological regimes. 
</p>

<p>
<br>
</p>

## 2. Methodological overview </p>

#### Data sources:
- Aerial screenshots of the study area from Google Earth
- Single raster bands (Red, Green, Blue, NIR) from Copernicus Sentinel-2 L2A for summer 2015, 2020, 2025

#### Methodological overview:
1. Download data files from https://browser.dataspace.copernicus.eu/
2. Load data into R and combine single bands to raster files
3. Compute environmental indices NDWI (water) and NDVI (vegetation)
4. Classify NDWI rasters into 2 categories (water/non-water)
5. Compute a time-series of water content [%] and water area [ha]
6. Plot water content change maps and change tables
7. Create NDWI ridgeline plots

<p>
<br>
</p>

## R code step-by-step

### 1. Downloading satellite bands from Copernicus:
- tiff-format
- high resolution
- bands 02(red), 03(green), 04(blue) and 08(NIR)
- UTM zone 33N
<p>
<br>
</p>

![Zoomed area](images/SScreenshot_Copernicus.jpg)

<p>
<br>
</p>

### 2. Preparing the workspace
```{r}
dev.off()
getwd()

library(terra)  
library(imageRy)  
library(viridis)
library(dplyr)
library(ggridges)
library(ggplot2)  
library(patchwork)
```

### 3. Loading data into R
Lake Fresdorf = "F":
```
F2015_b2 <- rast("data/LakeF_2015_B02.tiff")  
F2015_b3 <- rast("data/LakeF_2015_B03.tiff")
F2015_b4 <- rast("data/LakeF_2015_B04.tiff")
F2015_b8 <- rast("data/LakeF_2015_B08.tiff")

F2020_b2 <- rast("data/LakeF_2020_B02.tiff")  
F2020_b3 <- rast("data/LakeF_2020_B03.tiff")
F2020_b4 <- rast("data/LakeF_2020_B04.tiff")
F2020_b8 <- rast("data/LakeF_2020_B08.tiff")

F2025_b2 <- rast("data/LakeF_2025_B02.tiff")  
F2025_b3 <- rast("data/LakeF_2025_B03.tiff")
F2025_b4 <- rast("data/LakeF_2025_B04.tiff")
F2025_b8 <- rast("data/LakeF_2025_B08.tiff"){r}
```

Lake Kähnsdorf = "K":

```{r}
K2015_b2 <- rast("data/LakeK_2015_B02.tiff")  
K2015_b3 <- rast("data/LakeK_2015_B03.tiff")
K2015_b4 <- rast("data/LakeK_2015_B04.tiff")
K2015_b8 <- rast("data/LakeK_2015_B08.tiff")

K2020_b2 <- rast("data/LakeK_2020_B02.tiff")  
K2020_b3 <- rast("data/LakeK_2020_B03.tiff")
K2020_b4 <- rast("data/LakeK_2020_B04.tiff")
K2020_b8 <- rast("data/LakeK_2020_B08.tiff")

K2025_b2 <- rast("data/LakeK_2025_B02.tiff")  
K2025_b3 <- rast("data/LakeK_2025_B03.tiff")
K2025_b4 <- rast("data/LakeK_2025_B04.tiff")
K2025_b8 <- rast("data/LakeK_2025_B08.tiff")
```

Stacking the single bands into multi-layer rasters:


```{r}
F2015 <- c(F2015_b2, F2015_b3, F2015_b4, F2015_b8)
F2020 <- c(F2020_b2, F2020_b3, F2020_b4, F2020_b8)
F2025 <- c(F2025_b2, F2025_b3, F2025_b4, F2025_b8)

K2015 <- c(K2015_b2, K2015_b3, K2015_b4, K2015_b8)
K2020 <- c(K2020_b2, K2020_b3, K2020_b4, K2020_b8)
K2025 <- c(K2025_b2, K2025_b3, K2025_b4, K2025_b8)
```
<p>
<br>
</p>

### 4. Computing the NDWI - Normalized Difference Water Index 
*"The Normalized Difference Water Index (NDWI) is used to highlight open water features in a satellite image, allowing a water body to “stand out” against the soil and vegetation. [...]  Its primary use today is to detect and monitor slight changes in water content of the water bodies."* (EOS data analytics)
<p>
<br>
</p>

For lake F:
```{r}
ndwi_F_2015 <- (F2015_b3 - F2015_b8) / (F2015_b3 + F2015_b8)            # manual NDWI calculation
names(ndwi_F_2015) <- c("NDWI Lake F 2015")                             # rename layer
p1F <- im.ggplot(ndwi_F_2015) + ggtitle("NDWI Lake F 2015")             # create ggplot object

ndwi_F_2020 <- (F2020_b3 - F2020_b8) / (F2020_b3 + F2020_b8)
names(ndwi_F_2020) <- c("NDWI Lake F 2020")
p2F <- im.ggplot(ndwi_F_2020) + ggtitle("NDWI Lake F 2020")

ndwi_F_2025 <- (F2025_b3 - F2025_b8) / (F2025_b3 + F2025_b8)
names(ndwi_F_2025) <- c("NDWI Lake F 2025")
p3F <- im.ggplot(ndwi_F_2025) + ggtitle("NDWI Lake F 2025")

p1F+ p2F + p3F                                                         # multiframe NDWI plot
```
<p>
<br>
</p>

![NDWI multiframe plot lake F](images/NDWI_plots_lakeF.png)

<p>
<br>
</p>

For lake K:
```{r}
ndwi_K_2015 <- (K2015_b3 - K2015_b8) / (K2015_b3 + K2015_b8)     
names(ndwi_K_2015) <- c("NDWI Lake K 2015")
p1K <- im.ggplot(ndwi_K_2015) + ggtitle("NDWI Lake K 2015")

ndwi_K_2020 <- (K2020_b3 - K2020_b8) / (K2020_b3 + K2020_b8)
names(ndwi_K_2020) <- c("NDWI Lake K 2020")
p2K <- im.ggplot(ndwi_K_2020) + ggtitle("NDWI Lake K 2020")

ndwi_K_2025 <- (K2025_b3 - K2025_b8) / (K2025_b3 + K2025_b8)
names(ndwi_K_2025) <- c("NDWI Lake K 2025")
p3K <- im.ggplot(ndwi_K_2025) + ggtitle("NDWI Lake K 2025")

p1K+ p2K + p3K
```
<p>
<br>
</p>

![NDWI multiframe plot lake K](images/NDWI_plots_lakeK.png)

<p>
<br>
</p>

### 5. Computing the NDVI - Normalized Difference Vegetation Index 

*The well known and widely used NDVI is a simple, but effective index for quantifying green vegetation. It normalizes green leaf scattering in Near Infra-red wavelengths with chlorophyll absorption in red wavelengths. The value range of the NDVI is -1 to 1. Negative values of NDVI (values approaching -1) correspond to water.* (Sentinel Hub)
<p>
<br>
</p>

For lake F:
```{r}
ndvi_F_2015 <- im.ndvi(F2015,nir=4, red=1)                          # NDVI calculation with im.ndvi() from imageRy
names(ndvi_F_2015) <- c("NDVI Lake F 2015)                          # rename layer
v1F <- im.ggplot(ndvi_F_2015) + ggtitle("NDVI Lake F 2015")

ndvi_F_2020 <- im.ndvi(F2020,nir=4, red=1)
names(ndvi_F_2020) <- c("NDVI Lake F 2020")
v2F <- im.ggplot(ndvi_F_2020) + ggtitle("NDVI Lake F 2020")

ndvi_F_2025 <- im.ndvi(F2025,nir=4, red=1)
names(ndvi_F_2025) <- c("NDVI Lake F 2025")
v3F <- im.ggplot(ndvi_F_2025) + ggtitle("NDVI Lake F 2025")

v1F + v2F + v3F                                                     # multiframe NDWI plot
```
<p>
<br>
</p>

![NDVI multiframe plot lake F](images/NDVI_plots_lakeF.png)

<p>
<br>
</p>

For lake K:
```{r}
ndvi_K_2015 <- im.ndvi(K2015,nir=4, red=1)
names(ndvi_K_2015) <- c("NDVI Lake K 2015")
v1K <- im.ggplot(ndvi_K_2015) + ggtitle("NDVI Lake K 2015")

ndvi_K_2020 <- im.ndvi(K2020,nir=4, red=1)
names(ndvi_K_2020) <- c("NDVI Lake K 2020")
v2K <- im.ggplot(ndvi_K_2020) + ggtitle("NDVI Lake K 2020")

ndvi_K_2025 <- im.ndvi(K2025,nir=4, red=1)
names(ndvi_K_2025) <- c("NDVI Lake K 2025")
v3K <- im.ggplot(ndvi_K_2025) + ggtitle("NDVI Lake K 2025")

v1K + v2K + v3K
```
<p>
<br>
</p>

![NDVI multiframe plot lake K](images/NDVI_plots_lakeK.png)

*Note how the colour scale is consistent between the NDWI and NDVI graphics but the images seems "flipped" in colours, underlining the spectral differences between water and vegetated surfaces.*

<p>
<br>
</p>

### 6. Classifying the NDWI rasters into 2 categories (water/non-water)


```{r}
colours2 <- c("burlywood2", "aquamarine3")

ndwi_F_2015c <- im.classify(ndwi_F_2015, num_clusters=2, custom_colors=colours2) 
ndwi_F_2020c <- im.classify(ndwi_F_2020, num_clusters=2, custom_colors=colours2) 
ndwi_F_2025c <- im.classify(ndwi_F_2025, num_clusters=2, custom_colors=colours2)

ndwi_K_2015c <- im.classify(ndwi_K_2015, num_clusters=2, custom_colors=colours2)
ndwi_K_2020c <- im.classify(ndwi_K_2020, num_clusters=2, custom_colors=colours2)
ndwi_K_2025c <- im.classify(ndwi_K_2025, num_clusters=2, custom_colors=colours2)
```
<p>
<br>
</p>

*Note: The classification performed with im.classify() is unsupervised. This means that direct comparison between multiple classified rasters is limited as randomness is introduced each time it is run. As a consequence, the numeric class labels may not correspond between rasters. To make sure that classes represent the same category in all rasters ("water" vs. "non-water"), a visual check has to performed.*
<p>
<br>
</p>

Lake F:
![LakeFclassification](images/LakeF_classification_2.png)

<p>
<br>
</p>

Lake K:
![LakeKclassification](images/LakeK_classification_2.png)


*These images show a clear difference in water area between the two lakes between 2015 and 2025. While Lake K retained its overall shaped and only seems to have gotten a little smaller, Lake F's water area has shifted significatntly in both extent and form.*
<p>
<br>
</p>

### 7. Computing a time-series of water content [%] and water area [ha]

Manual option:
```{r}
freq(ndwi_F_2015c)                                                         # class 1: 1972 cells; class 2: 1169 cells
ncell(ndwi_F_2015c)                                                        # total 3149 cells

perc_F_2015 <- freq(ndwi_F_2015c) / ncell(ndwi_F_2015) * 100
perc_F_2015                                                                # class 1: 62.6 %; class 2: 37.1 %
# Repeat for all six rasters
```
<p>
<br>
</p>

Alternative: Automated in a for-loop

```{r}
rasters <- list(                    # put all 6 classified rasters in a list
  K_2015 = ndwi_K_2015c,
  K_2020 = ndwi_K_2020c,
  K_2025 = ndwi_K_2025c,
  F_2015 = ndwi_F_2015c,
  F_2020 = ndwi_F_2020c,
  F_2025 = ndwi_F_2025c
)

results <- list()                   # create an empty vector for the for-loop to fill

for (n in names(rasters)) {         # loop over every single raster,
  r <- rasters[[n]]                 # shorten "rasters[[n]]" to "n"
  
  f <- freq(r) |> as.data.frame()   # compute frequency and pass to a temporary data frame f
  total <- ncell(r)                 # compute total cells per raster
  
  f$pct <- f$count * 100 / total    # create new column pct and calculate percentage
  f$lake_year <- n                  # create new column lake_year and put the names from the list inside
  
  results[[n]] <- f                 # add the currently looped df to a list
  }

summary_tbl <- do.call(rbind, results)  # convert list to table
summary_tbl
str(summary_tbl)
```


```{r}
```
5. Compute a time-series of water content [%] and water area [ha]
6. Plot water content change maps and change tables
7. Create NDWI ridgeline plots

```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```


```{r}
```

# References:
EOS Data Analytics: https://eos.com/make-an-analysis/ndwi/

Sentinel Hub: https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/ndvi/

```{r}
```
