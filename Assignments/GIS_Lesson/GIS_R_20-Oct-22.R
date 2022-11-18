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

# check the plot projections
projection(my_sites_shape)
projection(countries)

# add a column to countries data frame with a unique number
countries$id <- 1:nrow(countries)

# see which countries points fall into
my_countries <- over(my_sites_shape, countries)
head(as.data.frame(my_countries)) # let's look at data frame portion

my_countries <- countries[countries$id %in% my_countries$id, ] #select my countries from the country shape file by id #
# now let's plot just my countries
plot(my_countries)
points(my_sites_shape, col='red', pch=16)

# convert shapefile to raster
my_countries_mask <- rasterize(my_countries, my_clim_stack[[2]])
my_countries_mask <- my_countries_mask * 0 + 1 # make all values 1

my_clim_sites <- my_clim_stack[[2]] * my_countries_mask
plot(my_clim_sites)

bg <- as.data.frame(randomPoints(my_clim_stack, n=10000)) # 10,000 random sites
names(bg) <- c('longitude', 'latitude')
head(bg)

plot(my_clim_stack[[1]])
points(bg, pch='.') # plot on map

# extract enviro variables for the random points
bgEnv <- as.data.frame(extract(my_clim_stack, bg))
head(bgEnv)

bg <- cbind(bg, bgEnv)
head(bg)

pres_bg <- c(rep(1, nrow(my_sites)), rep(0, nrow(bg)))

train_data <- data.frame(
  pres_bg=pres_bg,
  rbind(my_sites, bg)
)

head(train_data)

my_model <- glm(
  pres_bg ~ mean_diurnal_range*temperature_seasonality*precip_driest_quarter + I(mean_diurnal_range^2) + I(temperature_seasonality^2) + I(precip_driest_quarter^2),
  data=train_data,
  family='binomial',
  weights=c(rep(1, nrow(my_sites)), rep(nrow(my_sites) / nrow(bg), nrow(bg)))
)

summary(my_model)

my_world <- predict(
  my_clim_stack,
  my_model,
  type='response'
)

my_world

plot(my_world)
plot(countries, add=TRUE)
points(my_sites_shape, col='red', pch=16)

writeRaster(my_world, 'My_Climate_Niche/my_world', format='GTiff', overwrite=TRUE, progress='text')

# threshold your "preferred" climate
my_world_thresh <- my_world >= quantile(my_world, 0.75)
plot(my_world_thresh)

# convert all values not equal to 1 to NA...
# using "calc" function to implement a custom function
my_world_thresh <- calc(my_world_thresh, fun=function(x) ifelse(x==0 | is.na(x), NA, 1))

# get random sites
my_best_sites <- randomPoints(my_world_thresh, 10000)
my_best_env <- as.data.frame(extract(my_clim_stack, my_best_sites))

# plot world's climate
smoothScatter(x=bgEnv$temperature_seasonality, y=bgEnv$precip_driest_quarter, col='lightblue')
points(my_best_env$temperature_seasonality, my_best_env$precip_driest_quarter, col='red', pch=16, cex=0.2)
points(my_sites$temperature_seasonality, my_sites$precip_driest_quarter, pch=16)
legend(
  'bottomright',
  inset=0.01,
  legend=c('world', 'my niche', 'my locations'),
  pch=16,
  col=c('lightblue', 'red', 'black'),
  pt.cex=c(1, 0.4, 1)
  
)

## NOTES PULLED FROM THE COURSE LESSON ONLINE WRITTEN BY DR. TOOMEY