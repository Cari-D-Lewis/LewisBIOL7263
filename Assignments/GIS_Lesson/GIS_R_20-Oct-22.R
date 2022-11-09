##### GIS in R Notes 20-Oct-22 #####
# install.packages(c("sp","rgdal","raster","rgeos","geosphere","dismo"))
# load the packages into the R environment
library(sp) # classes for vector data (polygons, points, lines)
library(rgdal) # basic operations for spatial data
library(raster) # handles rasters
library(rgeos) # methods for vector files
library(geosphere) # more methods for vector files
library(dismo) # species distribution modeling tools

# set the working directory
setwd("/Users/carilewis/Desktop/Dissertation/Bioinformatics/Data_Wrangling/LewisBIOL7263/Assignments/GIS_Lesson/")

#load a raster
bio1<- raster("WORLDCLIM_Rasters/wc2.1_10m_bio_1.tif")
plot(bio1)

# convert the plot to F
bio1_f <- bio1*9/5+32
plot(bio1_f)

# can view the plot data
bio1 # useful when determining the coordinate system

# creating stacks
clim_stack <- stack(list.files("WORLDCLIM_Rasters/", full.names = TRUE, pattern = ".tif"))

# look at the stack
plot(clim_stack, nc = 4) # nc plots five columns of the 19 rasters
## for some reason, rasters 7, 8 and 9 are missing

my_clim_stack <- stack(
  raster('WORLDCLIM_Rasters/wc2.1_10m_bio_2.tif'),
  raster('WORLDCLIM_Rasters/wc2.1_10m_bio_4.tif'),
  raster('WORLDCLIM_Rasters/wc2.1_10m_bio_17.tif')
)
#Look up the variable on https://www.worldclim.org/data/bioclim.html and rename the variable with a more descriptive name.  
names(my_clim_stack) <- c("mean_diurnal_range", "temperature_seasonality", "precip_driest_quarter")

plot(my_clim_stack)

# are the variables correlated?
pairs(my_clim_stack) #pairs is a base R function that plots univariate distribution and bivariate relationships

# map points and countries
countries <- shapefile("Country_Shapefiles/ne_10m_admin_0_countries.shp")
countries

# there are issues with the interactive map in the R Plots window, so open a new one
dev.new()

# add borders to the raster data
plot(countries, col="goldenrod", border="darkblue")

# plot climate raster and country borders
plot(my_clim_stack[[3]])
plot(countries, add=TRUE) # add countries shapefile

# click on 10 different places in the interactive map to put them into a new dataframe
my_sites <- as.data.frame(click(n=10))

names(my_sites) <- c('longitude', 'latitude')
my_sites

# now extract the climate values for each point
env <- as.data.frame(extract(my_clim_stack, my_sites))
env
## NOTE: loading tidyverse with the other packages was messing this up!

# join environmental data and your site data
my_sites <- cbind(my_sites, env)
my_sites

myCrs <- projection(my_clim_stack) # get projection info

# make into points file
my_sites_shape <- SpatialPointsDataFrame(coords=my_sites, data=my_sites, proj4string=CRS(myCrs))
my_sites_shape

plot(my_clim_stack[[2]])
plot(countries, add=TRUE)
points(my_sites_shape, pch=16) # show sites on the map