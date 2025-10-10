# Code for studying population spread over space

install.packages("spatstat")
library (spatstat)

# Use a pre-defined data: bei
# A point pattern giving the locations of 3605 trees in a tropical rain forest. 
# Accompanied by covariate data giving the elevation (altitude) and slope of elevation in the study region.

bei
plot(bei,
     pch = 19, cex = 0.5) #spread of individuals

plot(bei.extra)           #elevation and gradient

bei.extra                 #info on the data
el <- bei.extra$elev      #extract only elevation (omit gradient)
plot(el)

el <- bei.extra[[1]]
plot(el)


# density map

dmap <- density(bei)      # I think the density function interpolates from points to raster
plot(dmap)
?density

plot(el)
points(bei, pch=19, cex=0.5)
?points
