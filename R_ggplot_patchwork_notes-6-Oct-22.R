##### 6-Oct-22 ggplot2 notes #####
# there are different components of a ggplot layer, see online notes
# load the packages
install.packages("ggthemes", "patchwork")

require(tidyverse)
require(ggthemes)
require(patchwork)

# generic ggplot template
# pl <- ggplot(data = <data>, mapping = eas(<mapping>))

# use the "+" to add layers to the ggplot
# can specify an aesthetic within the geom_function
# can add a theme layer to specify the font and things
# can add a coordinate function that specifies the axes within the plot, scale, etc.

# pl <- ggplot(data = <data>, mapping = eas(<mapping>)) + <geom_function>(aes(<mapping>),
#             stat = <stat>, position = <position>) + <theme>(<axes>, font, etc.) +
#             <coordinate_function> + <facet_function>

# to plot the output you have to call the ggplot object
#ggsave(plot = pl, filename = "file_name", width = #, height = #, units = "in, cm",
#       device = "pdf, jpg, svg")

# quick plotting with qplot function; useful to take a quick look at data

# example qplot using the mpg dataset in ggplot
mpg

# generate a histogram
qplot(x = mpg$cty)  #output givees a default of 30 "bins" in the histogram

# add some color to this plot
qplot(x = mpg$cty, fill = I("goldenrod"), color = I("black")) # I = identity
# need I() so the plot will use the color palette and NOT look for a variable name instead
# fill = filling the color, can use other variable names
# fill = bar color
# color = outline color

# default is a histogram, can specify a different shape
qplot(x = mpg$cty, geom = "density", color = I("goldenrod"))

# simple scatter plot with regression line
qplot(x = mpg$cty, y = mpg$hwy, geom=c("point", "smooth"), method = "lm")
# point = scatter plot
# smooth = line
# method = linear model
# output plot is a scatter and shows a correlation between city and hwy mpg
# gray outline behind line = confidence interval

# color points by a variable
qplot(x = mpg$cty, y = mpg$hwy, color = mpg$class, geom = "point")
# creates a scatter plot with points colored by vehicle class, illustrates how
# mpg changes with class

# regression is now applied to each class
qplot(x = mpg$cty, y = mpg$hwy, color = mpg$class, geom = c("point", "smooth"), 
      method = "lm")
# output has a separate regression for each class instead of an overall regression line

# basic boxplot
qplot(x = mpg$fl, y = mpg$cty, geom = "boxplot", fill = I("green"))
# shows fuel type versus mpg
# in a boxplot: the bold line = the median; the box = 50% of observations; 
#               whiskers = 1.5 std dev; points = outliers

# simple barplot
qplot(x = mpg$fl, geom = "bar")
# output gives "counts" for a discrete variable (fule type)

# barplot with specified means
mpg_summary <- mpg %>%
  group_by(class) %>%
  summarize(mean_hwy = mean(hwy))

qplot(x=mpg_summary$class, y = mpg_summary$mean_hwy, geom = "col")
# height of the bar represents the mean of the groups

# create a ggplot object "p" that contains all the info to create the plot
p <- qplot(x=mpg_summary$class, y = mpg_summary$mean_hwy, geom = "col")

# can manipulate plots with additional functions
# flip the axes with coord_flip()
p + coord_flip()

################################################################################
##### full ggplotting commands! ######
# themes and fonts

# create the ggplot object
p1 <- ggplot(data = mpg, mapping = aes(x = hwy, y = cty)) +
  geom_point()

# call the ggplot object
p1

# a more concise way of using ggplot; understood variables don't have to be specified as above
p_concise <- ggplot(mpg, aes(hwy, cty)) +
  geom_point(color = "green")

# call the ggplot object
p_concise

# change themes!
p1 + theme_bw()
# theme_bw() changes the background, lines, and points

p1 + theme_classic()
# theme_classic() provides a simple, clean graphic

p1 + theme_dark()
# useful for light points to make them pop

p1 + theme_void()
# removes everything except data; useful to create objects for powerpoint animations and presentations

# to change the background black, use theme()
p1 + theme(panel.background = element_rect(fill = "black"), plot.background = element_rect(fill = "black"))

# modify the font used in the plot
p1 + theme_classic(base_size = 25, base_family = "sans")

# control specific axis elements through theme()
p1 + labs(x = "Highway Gas Mileage (mpg)", y = "City Gas Mileage (cty)") + theme_classic() + 
  theme(axis.title.x = element_text(size = 15, angle = 45, vjust = 0.5))
# vjust = verticle adjustment
# angle = change the angle the titles are at
# hard coding all these elements for a plot can become tedious; sometimes easier to do adjust in other programs

# other minor modifications we can make to the same type of plot
p2 <- ggplot(data = mpg) +
  aes(x = hwy, y = cty) +
  geom_point(size = 7, shape = 25, color = "brown", fill = "hotpink") +
  labs(title = "Beautiful Gas Figure", subtitle = "Important Research", x = "Highway Gas Mileage",
       y = "City Gas Mileage") +
  xlim(0,50) +
  ylim(0,50)

## NOTE: in the above code, color does not have to be specified with I() since it's NOT within an aes()
# xlim() and ylim() force ggplot to include axes limits that it would otherwise crop by default
# colors() returns a list of all the colors in the base R palette

################################################################################
##### modifying the aesthetic of plots
p1 <- ggplot( data = mpg) +
  aes(hwy, cty, color = class) +
  geom_point(size = 3)

p1

# can map by shape instead of color, although can ONLY handle 6 discrete variables
p1 <- ggplot( data = mpg) +
  aes(hwy, cty, shape = class) +
  geom_point(size = 3)

p1

# map class to size of the points; not advised for discrete variables
p2 <- ggplot( data = mpg) +
  aes(hwy, cty, size = class) +
  geom_point()

p2

# map point size based on the engine size, much better use of the feature
p3 <- ggplot( data = mpg) +
  aes(hwy, cty, size = displ) +
  geom_point()

p3

# map different engine sizes by color
p3 <- ggplot( data = mpg) +
  aes(hwy, cty, color = displ) +
  geom_point(size = 3)

p3

# mapping the same aesthetic to two different geoms
p4 <- ggplot(data = mpg) +
  aes(hwy, cty, color = drv) +
  geom_point(size = 2) +
  geom_smooth(method = "lm")

p4

# mapping regression line to all the points
p5 <- ggplot(data = mpg) +
  aes(hwy, cty) +
  geom_point(aes(color = drv), size = 2) +
  geom_smooth(method = "lm")

p5

# can flip the aesthetic
p6 <- ggplot(data = mpg) +
  aes(hwy, cty) +
  geom_point(size = 2) +
  geom_smooth(aes(color = drv), method = "lm")

p6

################################################################################
##### patchwork for generating multiple plots
# set up a couple of plots to work with, copy from the online notes
#scatter plot
g1 <- ggplot(data=mpg) +
  aes(x=hwy,y=cty) + 
  geom_point() + 
  geom_smooth()
g1
# bar chart
g2 <- ggplot(data=mpg) +
  aes(x=fl,fill=I("maroon4"),color=I("black")) +
  geom_bar(stat="count") + 
  theme(legend.position="none")
g2
# histogram
g3 <- ggplot(data=mpg) +
  aes(x=hwy,fill=I("slateblue"),color=I("black")) + 
  geom_histogram()
g3
# box plot
g4 <- ggplot(data=mpg) +
  aes(x=fl,y=cty,fill=fl) + 
  geom_boxplot() + 
  theme(legend.position="none")

g4

# combine the plots with patchwork
# placing plots side-by-side horizontally
g1 + g2

# placing the plots vertically
g1 + g2 + g3 + plot_layout(ncol = 1)

# controlling relative size of the plots
g1 + g2 + plot_layout(ncol = 1, heights = c(1,4)) # plots at a 1:4 ratio of height
## NOTE: can do the same with widths

# add spacers between the plots
g1 + plot_spacer() + g2 + plot_spacer() + g3 + plot_layout(ncol = 5)

# nesting plots uses {} to define groups of plots
g1 + {
  g2 + {
    g3 + g4 + plot_layout(ncol=1)
  }
} + plot_layout(ncol=1)

# / and | to specify the layout of plots as well
(g1 | g2 | g3)/g4

# can chagnge the layout
(g1 | g2)/(g3 | g4)

# can add annotations to the plot groups
g1 + g2 + plot_annotation('This is a title', caption = 'made with patchwork')

# add tag annotations to specific panels
g1 / (g2 | g3) + plot_annotation(tag_levels = 'a')

# move the axes around
g3a <- g3 + scale_x_reverse()
g3b <- g3 + scale_y_reverse() 
g3c <- g3 + scale_x_reverse() + scale_y_reverse()

(g3 | g3a)/(g3b | g3c)

# flip coordinates using coord_flip()
(g3 + coord_flip() | g3a + coord_flip())/(g3b + coord_flip() | g3c + coord_flip())

# facetting variables to generate multiple plots
# create another simple plot to work with
m1 <- ggplot(data=mpg) + 
  aes(x=hwy,y=cty) + 
  geom_point() 

# adds a facetting layer onto the plot to break up the data by fuel type and class
m1 +  facet_grid(class~fl)

# modify the default axes scale
m1 +  facet_grid(class~fl, scales = "free_y") # sets the y axis based on the data for each row

m1 +  facet_grid(class~fl, scales = "free") # frees the axes for the data in each plot

m1 +  facet_grid(.~class, scales = "free_y") # .~ makes the data into columns

m1 +  facet_grid(class~., scales = "free_y") # ~. makes the data into rows

# facet_wrap is another way to modify the data
m1 +  facet_wrap(~class) # separate plots that wrap based on the data

# wrap the plots by class and fuel type
m1 + facet_wrap(~class + fl)

# can keep the plots with no data
m1 + facet_wrap(~class + fl, drop=FALSE)

# frees up the scale of each plot so it fits each dataset
m1 + facet_wrap(~class, ncol = 2, scales ="free")

# use facet layering with other aesthetic options
m1 <- ggplot(data=mpg) +                                         
  aes(x=displ,y=cty,color=drv) + 
  geom_point()

m1 + facet_grid(.~class)

##### 13-Oct-22 Lecture - Beyond Bar Graphs (paper) & Inkscape #####
# required to read a paper before class on the issues with data representation
# with small sample sizes and better ways on how to present data using paired
# and/or continuous datasets

# use the mpg dataset
require(tidyverse)

mpg

# create factor levels by car type to make plotting easier
mpg_fact <- mpg %>%
  mutate(class = factor(class, levels = c("2seater","subcompact","compact",
                                          "midsize","minivan","pickup","suv")))

# view the new factor
glimpse(mpg_fact)

# make a traditional bar plot of the means and standard error
p1 <- ggplot(mpg_fact, aes(x = class, y = hwy)) +
  stat_summary(fun = mean, geom = "col", width = 0.5, color = "red", fill = "white")+
  stat_summary(geom = "errorbar", width = 0.3) + # by default, geom_errorbar will calculate a mean and stderr
  ylim(0,45) +
  coord_flip()

# view the plot
p1

# explore some other options for presenting the data
# create a boxplot to see what other information we can get from the data
p2 <- ggplot(mpg_fact, aes(class, hwy)) +
  geom_boxplot(color = "red") +
  ylim(0,45) +
  coord_flip()

# view the data
p2

# gives quartile ranges, but doesn't tell us how the points are distributed

# create a violin plot to vview the density of the data
p3 <- ggplot(mpg_fact, aes(class, hwy)) +
  geom_violin(draw_quantiles = c(0.25,0.5,0.75)) +
  stat_summary(fn = mean, geom = "crossbar", width = 0.4, color = "red") + # add the mean to the plots
  ylim(0,45) +
  coord_flip()

# view the violin plot
p3

# show all the data points; geom_point overlaps points, so you can't see the sample size
p4 <- ggplot(mpg_fact, aes(class, hwy)) +
  geom_point() +
  ylim(0,45) +
  coord_flip()

p4

# show all the datapoints with geom_jitter
p5 <- ggplot(mpg_fact, aes(class, hwy)) +
  geom_jitter(width = 0.3, alpha = 0.4, size = 1.6) + # alpha makes the points transparent; scatters the points so they're not all overlapping
  ylim(0,45) +
  coord_flip()

p5

# add error bars
p6 <- ggplot(mpg_fact, aes(class, hwy)) +
  geom_jitter(width = 0.3, alpha = 0.4, size = 1.6) +
  stat_summary(fn = mean, geom = "crossbar", width = 0.4, color = "red") +
  stat_summary(geom = "errorbar", width = 0.3) +
  ylim(0,45) +
  coord_flip()

p6

# put the different graphs together with patchwork
require(patchwork)

# create a patchwork figure group
(p1 + p2)/(p3 + p6)

# plot points and violin in same plot
p7 <- ggplot(mpg_fact, aes(class, hwy)) +
  geom_violin(position = position_nudge(x = 0.5, y = 0), draw_quantiles = c(0.25,0.5,0.75), width = 0.4) +
  geom_jitter(width = 0.3, alpha = 0.4, size = 1.6) +
  stat_summary(fn = mean, geom = "crossbar", width = 0.4, color = "red") +
  stat_summary(geom = "errorbar", width = 0.3) +
  ylim(0,45) +
  coord_flip()

p7

# paired or repeated observations; data points need to be linked since they're measures of the same thing, but over different time scales or other measure
# generate the paired observation data from the online vingette
ID<-c("A","B","C","D","E","F","G","A","B","C","D","E","F","G")
Obs<-c("before","before","before","before","before","before","before","after","after","after","after","after","after","after")
Measure<-c(runif(1:7),runif(1:7)*4)

RepEx<-tibble(ID,Obs,Measure) #make these observations into a tibble

RepEx<-RepEx %>% 
  mutate(Obs = factor(Obs, levels = c("before","after"))) #order the levels of observation as a factor

# make another plot 
p8 <- ggplot(RepEx, aes(Obs, Measure)) +
  geom_point(alpha = 0.4, size = 4, aes(color = ID)) +
  geom_line(aes(color = ID, group = ID), alpha = 0.4, size = 2)

p8

# example of BAD DATA REPRESENTATION
# create a bar plot of this data
p9 <- ggplot(RepEx, aes(x = Obs, y = Measure)) +
  stat_summary(fun = mean, geom = "col", width = 0.5, color = "red", fill = "white")+
  stat_summary(geom = "errorbar", width = 0.3)

p9

# this bar plot doesn't tell you about the relationship between before and after measures

## NOTE: use theme_set(<theme>) to change the default the theme