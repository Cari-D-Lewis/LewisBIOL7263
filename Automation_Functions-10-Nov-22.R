##### Automation in R: creating functions and interactive code
# The goals of this lesson are to teach the basics of creating functions and how 
# to write interactive code to automate repetative tasks

# setwd() and install the necessary packages
library(tidyverse)
library(rlang)

## Problem 1 ##
# Using the ebird data set from previous lessons, write a function that will take the scientific name as input and create a new file containing all the observation info for that bird. Name the output files with the scientific names for the following species:

# download the ebird data set
Matt_ebird <- read_csv("https://github.com/mbtoomey/Biol_7263/blob/main/Data/MBT_ebird.csv?raw=true")

# write the function sections
bird <- function(BIRD){ # define the input argument
  b <- filter(Matt_ebird, scientific_name == BIRD) # create the body of the function
  file_name <- paste0(sub(" ", "_", BIRD),".csv") # create the file name variable
  write_csv(b, file_name) # write the output csv file
  cat("File", file_name,"created.") # confirm the function output the final list
} # close the function

# use the function for each bird species
bird("Anser caerulescens")

bird("Antrostomus carolinensis")

bird("Setophaga americana")

## Problem 2 ##
# Write a second function that will take a file name as input and output the *date* that species was observed the **most** AND the **least** for each of the files created in Problem 1. Save the output for each species into a single file in your results folder and include the link in your R Markdown file. 

# create the output file with headers
write_csv(head(bird_list,0), "Max-min_Bird_Obs.csv", col_names = TRUE)

# create the function and body
max_minOb <- function(FILE_NAME){ # input a csv file
  bird <- read_csv(FILE_NAME) # read the csv to a new variable
  bird_list <- head(arrange(bird, by = desc(count)),1)
  bird_list <- rbind(bird_list, head(arrange(bird, by = count),1))
  write_csv(bird_list, "Max-min_Bird_Obs.csv", col_names = F, append = TRUE)
  cat(FILE_NAME, " added to output .csv file.")
}

# use the function for each bird species
max_minOb("Anser_caerulescens.csv")

max_minOb("Antrostomus_carolinensis.csv")

max_minOb("Setophaga_americana.csv")

## Problem 3 ##
# Write a function that will complete Problems 1 and 2 in a single function, but with the following species names as argument values.

# create the output file with headers
write_csv(head(Matt_ebird,0), "Max-min_Bird_Obs-P3.csv", col_names = TRUE)

nest <- function(SPECIES){
  b <- filter(Matt_ebird, scientific_name == SPECIES) # create the body of the function
  file_name <- paste0(sub(" ", "_", SPECIES),".csv") # create the file name variable
  write_csv(b, file_name) # write the output csv file
  cat("File", file_name,"created.") # confirm the function output the final list
  bird <- read_csv(file_name) # read the csv to a new variable
  bird_list <- head(arrange(bird, by = desc(count)),1) # find the 
  bird_list <- rbind(bird_list, head(arrange(bird, by = count),1))
  write_csv(bird_list, "Max-min_Bird_Obs-P3.csv", col_names = F, append = TRUE)
  cat(file_name, " added to output .csv file.")
}

# use the function for each bird species
nest("Branta canadensis")

nest("Spatula discors")

nest("Anas platyrhynchos")

## Challenge Problem ##
# Write a loop that uses your function from Problem 3 and a list of bird names to completely automate the process!
# create a list of bird names
birds <- c("Anser caerulescens", "Antrostomus carolinensis", "Setophaga americana", "Branta canadensis", "Spatula discors", "Anas platyrhynchos")

for (sp in birds){
  nest(sp)
}
  
