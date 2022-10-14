##### Assignment 5 R Script 14-Oct-22 #####
# Using tidyr and dplyr for data management and cleaning
# load the required packages and set the working direstory
setwd("/Users/carilewis/Desktop/Dissertation/Bioinformatics/Data_Wrangling/LewisBIOL7263/Assignments")
require(tidyverse)

# Import the data parts 1 and 2
Part1 <- read_csv("https://github.com/mbtoomey/Biol_7263/blob/main/Data/assignment6part1.csv?raw=true")

Part2 <- read_csv("https://github.com/mbtoomey/Biol_7263/blob/main/Data/assignment6part2.csv?raw=true")

#view the datasets
read_csv(glimpse(Part1), skip = 1)
glimpse(Part2)

##### Problem 1
# pivot the tibbles so variable names are columns and each sample has its own row
Part1_tib <- Part1 %>% pivot_longer(cols = !ID, # break up the sample name into 3 columns
                                    names_to = c("Sample", "Sex", "Experiment"), # set the new column names
                                    names_sep = "_") %>% # new column variable deliminator
  pivot_wider(names_from = ID, values_from = value) # create two columns for body length and age

Part2_tib <- Part2 %>% pivot_longer(col = !ID, # break up the sample name into a column
                       names_to = c("Sample"), # set the new column name
                       names_pattern = "(Sample1?.)..*") %>% # new column (variable)
  pivot_wider(names_from = ID, values_from = value) # create a column for mass

# merge the tibbles using Sample fields
write_csv(Part1_tib %>%
  inner_join(Part2_tib, by = "Sample"), # will only join by a common field
  "Results/Assign5_Merge.csv") # export to the Results folder

################################################################################
##### Problem 2
# load the new tibble and create a residual mass variable
Assign5 <- read_csv("Results/Assign5_Merge.csv")

Assign5 <- mutate(Assign5, resid_mass = mass/body_length)

# group the samples by Experiment type
Assign5 <- group_by(Assign5, Experiment)

# calculate the stddev of the resid_mass by Experiment type
Exp_SD <- summarize(Assign5, mean_rmass=mean(resid_mass, na.rm=TRUE), 
          SD_rmass=sd(resid_mass, na.rm=TRUE))

# ungroup and regroup by sex
ungroup(Assign5)

Assign5 <- group_by(Assign5, Sex)

# calculate the stddev of the residual_mass by sex
Sex_SD <- summarize(Assign5, mean_rmass=mean(resid_mass, na.rm=TRUE), 
                    SD_rmass=sd(resid_mass, na.rm=TRUE))

# combine the tibbles
write_csv(Exp_SD %>%
            full_join(Sex_SD), # will only join by a common field
          "Results/Assign5_SD_ExpXSex.csv") # export to the Results folder