##### 22-Sep-22 Intro to R, readr, dplyr and wrangling #####
# don't be a dumbass, annotate your scripts :) our future self will thank you
# Toomey provides a header example that we need to use on all our R scripts
# copy and paste the header at the end of the snippets section in Tools ->
# Global Options -> Code -> Edit Snippets

# mainly went through how to assign variables, preferred naming architecture,
# and follows the Intro to R vignette from the website
# Toomey doesn't like using "." in variable names
# double = decimal point variable

# c() is the "combine" command to create a vector
z <- c(1,2,3,4,5)
print(z)

# see the type of vector you've created; produces "double" meaning numeric
typeof(z)

# call the 4th element in the vector
z[4]

# flattening vectors into a single vector
y <- c(c(4,6), c(23,107))

print(y)

# character strings can be input using '' OR ""
b <- c("bedbug", "swallow bug", "wasp", 'praying mantis')
rpint(b)

# logical vector is in all caps
l <- c(TRUE, TRUE, FALSE, TRUE)
typeof(l)

# 3 properties to a vector: type, length, and name
# when working with datasets, will have to "wrangle" the type of data to work
# with different packages
typeof(z)
is.numeric(z)
length(z)
names(z)  # there are no names, but we can assign them

names(z) <- c("first","second","fifth","eighth","tenth")

z2 <- c(first=1, second=2)

# remove the names
names(z) <- NULL

# missing data and NA values behave uniquely
m <- c(3.4, 12.1, 1.01, NA) #will still be type = double
typeof(m)

# what is the type of NA?
typeof(m[4])  # wtih other elements, takes on the type of the other elements

m2 <- NA
typeof(m2)  # return a vector of logicals

## student question:
# what is the difference between typeof() and class()?
class(m)  #numeric
class(m2) #logical

# don't know the answer; didn't find it

# managing NA values in datasets
mean(m)
na.omit(m)

# multiple options to deal with NAs
mean(m, na.rm = T)  # can use if na.rm is part of the function
mean(na.omit(m))
mean(m[!is.na(m)])  # pulls all the values that are NOT NAs

# dealing with NaN, -Inf, Inf
g <- 0/0  # dividing by 0
g

i <- 1/0  # imaginary numbers
i

# NULL is an object that is nothing; used to create empty variables
n <- NULL
typeof(n)
class(n)
length(n)

############################################################
##### Coercion - rules of priority for data management #####
# logical < integer < double < character, in order of increasing priority
a <- c(2, 2.0)
typeof(a)

c <- c('yellow', 'blue')
typeof(c)

# combining a and c creates a character vector
e <- c(a,c)
typeof(e)

# Logicals get coerced into integers allowing for useful calculations
# create a dataset from a random uniform distribution -> runif()
a <- runif(10)  #10 values in the dataset

# are any values > 0.2?
a > 0.2

# how many are > 0.2?
sum(a >0.2)

# what is the mean of the values that are > 0.2?
mean(a > 0.2)

# using a normal distribution of 1000 random data points, how many are above 2
# standard deviations? i.e. how many data points are outside the 95% CI?
mean(rnorm(1000) > 2)

#########################
##### vectorization #####
# create a vector
z <- c(10,20,30)

# add 1 to each element of the vector
z+1

# create a second vector
y <- c(1,2,3)

# adds the first element of z with the first element of y, the second elements, etc.
z + y

# applies the operation to each element
z^2

# operations will recycle vectors that are of different lengths
# create a short vector
x <- c(1,2)

# produces a warning message that the vectors are not the same length; recycles
# the first element of x since it is shorter than z and adds it to the 3rd element
# of z
z + x

##### Data Import and Export with readr #####
# make a data folder within your R project for Assignment 4
# right click data link -> Save Link As -> .csv file
library(tidyverse)

## NOTE: rad.csv WILL NOT read headers by default; read_csv WILL read headers by default
# load the ebird data
Matt_ebird <- read_csv("Desktop/Dissertation/Bioinformatics/Data_Wrangling/LewisBIOL7263/Data/MBT_ebird.csv")

# can also download from the website, dependingn on how accessible the file is
# DONT HAVE TO DO BOTH
Matt_ebird, read_csv("https://github.com/mbtoomey/Biol_7263/blob/main/Data/MBT_ebird.csv?raw=true")

# Toomey prefers to save data as .csv files; there are other formats and read
# functions available, see notes online

# to exclude headers
Matt_ebird <- read_csv("Desktop/Dissertation/Bioinformatics/Data_Wrangling/LewisBIOL7263/Data/MBT_ebird.csv",
                       col_names = F)

# specify your own headers
Matt_ebird <- read_csv("Desktop/Dissertation/Bioinformatics/Data_Wrangling/LewisBIOL7263/Data/MBT_ebird.csv",
                       col_names = c("first_column", "second_column"))

# look at the columns as rows, to see the full range of variables in a large dataset
glimpse(Matt_ebird)

## NOTE: readr will use default rules when importing data, however data types can
## specified when importing

# data can be exported as multiple types of datasets, see online notes

#####################################
##### Wrangling Data with dplyr #####
# Example script written in class:

require(tidyverse)

# load the sample dataset
mtcars

# make the dataset a tibble; loses row names by default, so have to specify
as_tibble(mtcars, rownames = "make_model")

# selecting collumns -> variables using the starwars dataset
# load the data
data("starwars")

# print the top 6 rows
head(starwars)

# print the last 6 rows
tail(starwars)

# transform the variables so variable names are vertical
glimpse(starwars)

# select the variables we want to work with
starwars_cut1 <- select(starwars, name:species) #excludes the lists at the end of the data

# confirm the selection worked
glimpse(starwars_cut1)

# additional ways to specify desired variables
starwars_cut2 <- select(starwars, 1:11) # uses column index number
starwars_cut3 <- select(starwars, !c(films, vehicles, starships)) # selects all the variables that are NOT=! under the variable names "films", "vehicles", or "starships"
starwars_cut4 <- select(starwars, !where(is.list))  # excludes all the variables that are NOT=! lists

##NOTE: select() also has a variety of helper functions such as column names that contain text/numbers, ends_with text/numbers, starts_with certain text/numbers, matches specific text/numbers, etc.; see online notes

# select helper function example
starwars_color <- select(starwars, name, contains("color"))

# arrange() reorders the rows based on the value in a specific collumn
# default is the smallest value first
arrange(starwars_cut1, by = height)

# use desc() function to reverse the order
## NOTE: missing values are moved to the end of the list
arrange(starwars_cut1, by = desc(height))

# filter() to select observations by their values
## NOTE: this will also exclude missing values since they don't meet the criteria
filter(starwars_cut1, mass == 77) # observations where mass is exactly equal to 77
filter(starwars_cut1, mass >= 77) # mass is greater than or equal to 77
filter(starwars_cut1, mass != 77) # mass is NOT 77

# to include missing values
filter(starwars_cut1, mass != 77 | is.na(mass)) # finds observations where mass is NOT 77 AND is missing a value

# specifying multiple conditions
# & = AND
# | = OR
## additional notes on webpage
filter(starwars_cut1, eye_color == "blue" & hair_color == "blond")

# slice() is another tool used to "slice" sections of the data, such as the top or bottom
# cut the top 5 rows of the dataset
slice_head(starwars_cut1, n=5)

# randomly pull 5 observations from the larger table
slice_sample(starwars_cut1, n=5)

# slice the largest observation from a specified variable
slice_max(starwars_cut1, mass)

# slice the smallest observation from a specified variable
slice_min(starwars_cut1, mass)

# mutate() creates new variables from existing variables
## NOTE: THIS WILL OVERWRITE EXISTING VARIABLES IF NAMED THE SAME NAME
## NOTE: ADDED TO EXISTING DATASET

# add residual mass variable to current dataset
starwars_cut1 <- mutate(starwars_cut1, resid_mass = mass/height)

glimpse(starwars_cut1)

# make a new dataset with the new variable
starwars_resid <- transmute(starwars_cut1, name=name, resid_mass = mass/height)

# rank the observations by heft using the mass variable
starwars_heft <- transmute(starwars_cut1, name=name, heft=min_rank(mass))

# sort the data points by the assigned rank
arrange(starwars_heft, heft)

#summarize() collapses values into summary stats for the variables
summarize(starwars_cut1, mean_mass=mean(mass, na.rm=TRUE), 
          SD_mass=sd(mass, na.rm=TRUE)) # summarizes all the observations

# grouping the summarize() function for specific groups of the observations
starwars_cut1 <- group_by(starwars_cut1, species)

glimpse(starwars_cut1)

# rerun the summarize() command after grouping by species
summarize(starwars_cut1, mean_mass=mean(mass, na.rm=TRUE), 
          SD_mass=sd(mass, na.rm=TRUE)) # summarizes all the observations BY GROUP
# gives stats based on species

# ungroup the dataset
ungroup(starwars_cut1)

# Piping commands to combine actions
# do everything we just did with piping
starwars_cut1 %>% # first specify the whole dataset and pipe=%>% into commands
  filter(mass >0) %>% # filter by mass, greater then 0 (removes NAs)
  group_by(species) %>% # group the data by species
  summarize(mean_mass = mean(mass), SD_mass=sd(mass)) # create summary stats

# remove species that are observed only once
starwars_cut1 %>%
  filter(mass >0) %>%
  group_by(species) %>%
  mutate(count=n()) %>% # create a count variable in the dataset based on group 
  filter(count > 1) %>% # filter the count variable to only include those with > 1 observations
  summarize(mean_mass = mean(mass), SD_mass=sd(mass))

## NOTE: can group by whatever variable FIRST to then add the count variable
## Example: can group by hair color, which will then create a count based on hair color