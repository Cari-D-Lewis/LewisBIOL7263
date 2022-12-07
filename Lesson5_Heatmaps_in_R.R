##### Student Lessons 1-Dec-22 #####
##### Gene Expression Heatmap with DR. Madison Herboldt
# download the necessary packages
library(stats)
library(ggplot2)

# download the dataset
pheromone_data <- read.csv("https://madisonherrboldt.github.io/HerrboldtBIOL7263/My_Lesson_Heatmaps/pheromone_data.csv")

# in order to use the heatmap() function, we need to transform the csv file into a numeric data frame
# this also allows us to make sure we keep our rownames
pheromone_data1 <- as.matrix(pheromone_data[,-1])
rownames(pheromone_data1) <- pheromone_data[,1]

# default settings
heatmap(pheromone_data1)

# modify the aesthetics
heatmap(pheromone_data1, 
        Colv = NA, #get rid of column clustering
        Rowv = NA, #get rid of row clustering
        margins = c(7,5), #change the margins so we can fit in the column names with the axis title
        cexCol = 1, #change the size of the column names
        main = "Pheromone Gene Expression", #add a title
        xlab = "Groups", #add an x axis label
        ylab = "Gene") #add a y axis label

# can also change the color
heatmap(pheromone_data1, 
        Colv = NA, #get rid of column clustering
        Rowv = NA, #get rid of row clustering
        margins = c(7,5), #change the margins so we can fit in the column names with the axis title
        cexCol = 1, #change the size of the column names
        col = terrain.colors(10), #changing the color palette and selecting how many colors to use
        main = "Pheromone Gene Expression", #add a title
        xlab = "Groups", #add an x axis label
        ylab = "Gene") #add a y axis label

### heatmaps in ggplot2
# using the provided data that has been modified to a "long" format
pheromone_data2 <- read.csv("https://madisonherrboldt.github.io/HerrboldtBIOL7263/My_Lesson_Heatmaps/pheromone_data2.csv")

# make a basic heatmap
ggplot(pheromone_data2, #give it the data
       aes(x = Sample, y = Gene, fill = Expression)) + #set our x and y and what data we want to "fill" our heatmap with
  geom_tile() #the heatmap plot function

# customize the ggplot
ggplot(pheromone_data2, aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile(colour="black", linewidth=0.5)+ #here we are adding outlines around our tiles
  #we can change the colour and thickness of this outline
  scale_fill_gradient(low = "black", high = "green")+ #change the color gradient
  theme_grey(base_size=12)+ #change our theme and make our base size font 12
  theme(axis.ticks = element_blank(), #get rid of the tick marks
        #get rid of all the background ggplot2 aesthetics
        plot.background = element_blank(), 
        panel.background = element_blank(),
        panel.border = element_blank())

# format title, labels, and legend
ggplot(pheromone_data2, aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile(colour="black", linewidth=0.5)+ 
  scale_fill_gradient(low = "black", high = "green")+
  theme_grey(base_size=12)+
  ggtitle(label = "Pheromone Gene Expression") + #add a plot title
  theme(plot.title = element_text(face="bold"), #make the plot title bold
        legend.title = element_text(face = "bold"), #make the legend title bold
        axis.title = element_text(face="bold"), #make the axis titles bold
        axis.text.y =element_text(color = "black"), #make the axis labels black instead of grey
        axis.text.x =element_text(angle = 270, hjust = 0, color = "black"), #change the angle of the axis labels,
        #the position, and the color
        axis.ticks= element_blank(),
        plot.background=element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank())

# group by tissue type (gland) where expression was measured
ggplot(pheromone_data2, aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile(colour="black", linewidth=0.5)+ 
  scale_fill_gradient(low = "black", high = "green")+
  theme_grey(base_size=12)+
  facet_grid(~ Gland) + #here we are faceting by gland
  ggtitle(label = "Pheromone Gene Expression") +
  scale_x_discrete(labels=c('D.brim', 'E.tyn M', 'E.tyn P', 'P.alb', 'D.brim', 'E.tyn M', 'E.tyn P', 'P.alb'))+ #here we are changing the x axis labels
  theme(plot.title = element_text(face="bold"),
        legend.title = element_text(face = "bold"),
        axis.title = element_text(face="bold"),
        axis.title.x = element_blank(),
        axis.text.y =element_text(color = "black"),
        axis.text.x =element_text(color = "black"),
        axis.ticks=element_blank(),
        plot.background=element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank())

# only display the columns for which we have data
ggplot(pheromone_data2, aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile(colour="black", linewidth=0.5)+ 
  scale_fill_gradient(low = "black", high = "green")+
  theme_grey(base_size=12)+
  facet_grid(~ Gland, switch = "x", scales = "free_x", space = "free_x") + #switch moves the facet labels to the bottom
  #applying "free_x" removes the columns for which there is no data and
  #applying "free_x" to space makes the columns the same width
  ggtitle(label = "Pheromone Gene Expression") +
  scale_x_discrete(labels=c('D.brim', 'E.tyn M', 'E.tyn P', 'P.alb', 'D.brim', 'E.tyn M', 'E.tyn P', 'P.alb'))+
  theme(plot.title = element_text(face="bold"),
        strip.placement = "outside", #this places the facet label outside the x axis labels
        strip.text = element_text(face = "bold"), #this bolds the text in the facet label
        legend.title = element_text(face = "bold"),
        axis.title = element_text(face="bold"),
        axis.title.x = element_blank(),
        axis.text.y =element_text(color = "black"),
        axis.text.x =element_text(color = "black"),
        axis.ticks=element_blank(),
        plot.background=element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank())

# homework assignment:
# Take the following dataset and create a heatmap using ggplot2 that is faceted by tissue type. 
# Customize the heatmap and make sure all the axis labels/titles are correct and that you can read them all. 
# Make sure to add a plot title. Feel free to customize the color and whatever else you see fit. 
# Create an R Markdown file with a link to your script as well as an imbedded image of your heatmap.

##### Packages in R by Elise Delaporte
# download the necessary packages
install.packages(c("devtools", "roxygen2"))
library("devtools") # for 'create_package' function now, and other functions later
library("roxygen2") # automatically generates some of the package documentation for you

# Download these files and place them into a new folder titled “RPackagePractice”
# set the working directory!
create_package("rateLawOrders")

### FOLLOWED THE INSTRUCTIONS ONLINE TO CREATE PACKAGE SCRIPTS ###
# these following functions must be run while your working directory is set to the package folder (i.e. rateLawOrders in this case)
document() # from devtools package, updates the package's documentation
check() # from devtools package, checks package for errors

### REVIEW THIS ONLINE ###

##### Spatial Data in R by Olivia Pletcher
# install and download the necessary packages
install.packages("spatstat")
install.packages("maptools")
install.packages("lattice")

library(spatstat)
library(maptools)
library(lattice)

# this is the data we will be using
data("japanesepines")
data("redwoodfull")
data("cells")

# create a basic plot for the different datasets
plot(japanesepines, main = "Japanese Pines", axes = TRUE)
plot(redwoodfull, main = "redwood", axes = TRUE)
plot(cells, main = "cells", axes = TRUE)

# these data are in point pattern data sets and we need to convert them into spatial points
spjpines <- as(japanesepines, "SpatialPoints")
spred <- as(redwoodfull, "SpatialPoints")
spcells <- as(cells, "SpatialPoints")

# return the data to original scale
# NOTE: they are NOT DIRECTLY comparable
plot(spjpines, main = "japanese pines", axes = TRUE)
plot(spred, main = "redwood", axes = TRUE)
plot(spcells, main = "cells", axes = TRUE)

summary(spjpines)#max of 5.7
summary(spred)#max of 1
summary(spcells)#max of 1

# use elide to standardize the scales
spjpines1 <- elide(spjpines, scale=TRUE, unitsq=TRUE)
summary(spjpines1)#now the max = 1

# now create a comparable dataframe to hold the data
dpp<-data.frame(rbind(coordinates(spjpines1),coordinates(spred), 
                      coordinates(spcells)))
print(dpp)

# differentiate between the three different datasets
njap<-nrow(coordinates(spjpines1))
nred<-nrow(coordinates(spred))
ncells<-nrow(coordinates(spcells))

dpp<-cbind(dpp,c(rep("JAPANESE",njap), rep("REDWOOD", nred), rep("CELLS", ncells))) 
names(dpp)<-c("x", "y", "DATASET")

print(dpp)

# now we can visualize the standardized data as a whole
print(xyplot(y~x|DATASET, data=dpp, pch=19, aspect=1))

### Testing for complete spatial randomness (CSR)
# using a g function to test distance to nearest neighbor
# FOLLOW UP ON THE EXPLANATION OF THIS TEST

# create a theoretical "random" dataset to test the null hypothesis
# null hypothesis = randomly distributed data
r <- seq(0, sqrt(2)/6, by = 0.001)

envjap <- envelope(as(spjpines1, "ppp"), fun=Gest, r=r, nrank=2, nsim=99)

envred <- envelope(as(spred, "ppp"), fun=Gest, r=r, nrank=2, nsim=99)

envcells <- envelope(as(spcells, "ppp"), fun=Gest, r=r, nrank=2, nsim=99)

# combine the data for each dataset
Gresults <- rbind(envjap, envred, envcells) 
Gresults <- cbind(Gresults, 
                  y=rep(c("JAPANESE", "REDWOOD", "CELLS"), each=length(r)))
summary(Gresults)

# plot the data
print(xyplot(obs~theo|y, data=Gresults, type="l", 
             panel=function(x, y, subscripts)
             {
               lpolygon(c(x, rev(x)), 
                        c(Gresults$lo[subscripts], rev(Gresults$hi[subscripts])),
                        border="gray", col="gray"
               )
               
               llines(x, y, col="black", lwd=2)
             }
))

# RESULTS
# Redwoods show clustered pattern (values of G above the envelopes)
# Cells shows a more regular pattern (values of G below the envelopes)
# Japanese Pines seem to fit in the null envelope of Complete Spatial Randomness

### scond order properties
# Second-order properties measure the strength and type of the interactions between events of the point process
# We want to measure strength and types of interactions between points
# K-function measures the number of events found up to a given distance of any particular event

# create a random dataset to mimic the null, randomizd data
Kenvjap <- envelope(as(spjpines1, "ppp"), fun=Kest, r=r, nrank=2, nsim=99) #we are still using the standardized pine plot(spjpines1)

Kenvred <- envelope(as(spred, "ppp"), fun=Kest, r=r, nrank=2, nsim=99)

Kenvcells <- envelope(as(spcells, "ppp"), fun=Kest, r=r, nrank=2, nsim=99)

# combine the data into a single dataset
Kresults<-rbind(Kenvjap, Kenvred, Kenvcells)

Kresults<-cbind(Kresults, 
                y=rep(c("JAPANESE", "REDWOOD", "CELLS"), each=length(r)))
summary(Kresults)

# plot the interactions between points in a dataset
print(xyplot((obs-theo)~r|y, data=Kresults, type="l", 
             ylim= c(-.06, .06), ylab=expression(hat(K) (r)  - pi * r^2),
             panel=function(x, y, subscripts)
             {
               Ktheo<- Kresults$theo[subscripts]
               
               lpolygon(c(r, rev(r)), 
                        c(Kresults$lo[subscripts]-Ktheo, rev(Kresults$hi[subscripts]-Ktheo)),
                        border="gray", col="gray"
               )
               
               llines(r, Kresults$obs[subscripts]-Ktheo, lty=2, lwd=1.5, col="black")   
             }
))

# damn, I need to work on my statistics knowledge...
