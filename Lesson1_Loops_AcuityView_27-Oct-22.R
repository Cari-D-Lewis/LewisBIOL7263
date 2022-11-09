##### 27-Oct-22 Tanner Mierow Lecture on Acuity View
# download the necessary packages
# cannot install the packages all together in a single line, for whatever reason
### on MAC you have to download xquartz; already done using homebrew
install.packages("AcuityView")
install.packages("imager")
install.packages("fftwtools")
install.packages("magrittr")

# load the installed packages into the environment
library(AcuityView)
library(imager)
library(fftwtools)
library(magrittr)

# set the working directory
setwd("/Users/carilewis/Desktop/Dissertation/Bioinformatics/Data_Wrangling/LewisBIOL7263/Assignments/")

# load in a test image
img <- load.image('ASP1-F1_Bed_Bug.jpg')

# what are the image characteristics?
dim(img)

# we need to make the aspect ratio a square
img <- resize(img, 5792, 5792)

# check the new aspect ratio
dim(img)

# calculate the visual acuity using the AcuityView R package
# detailed info at: https://eleanorcaves.weebly.com/acuityview-software.html
# create a variable for eyeResolutionX that measures how well an organism sees
## CHAGE CPD VALUE FOR EACH ORGANISM
CPD = 0.76 # for a reduviidae

MRA <- 1/CPD
AcuityView(photo = img, # image file
           distance = 2, # distance = distance from viewer to object; same units as realWidth
           realWidth = 2, # realWidth = the real-life width of the image
           eyeResolutionX = MRA, # visual resolution in the X plane
           eyeResolutionY = NULL, # visual resolution in the Y plane; don't change
           plot = T, # shows the plot AND saves it
           output = "bedbug_to_reduviidae.jpg") # output image name

##### HOMEWORK ON ONLINE PORTFOLIO #####

##### Emily Adamic Lecture on Loops in R
# class example problem
all_words = c("bikes", "biology", "coffee", "serendipity")

# create a loop that calculates the number of characters in each word and print
# the output to the screen for each iteration
for (word in all_words) {
  cat("There are", nchar(word), "characters in the word", all_words, ".\n")
}

# second in-class example
# loop throught the given number vector and store the even numbers in a vector,
# store the odd numbers in a different vector, and skip the NAs
all_nums = c(10,12,28,34,NA,NA,11,11)
even_nums = c()
odd_nums = c()

for(n in all_nums){
  if(is.na(n) == T){
    next
  }
  if((n %% 2) == 0){
    even_nums = c(even_nums, n)
  }
  else{
    odd_nums = c(odd_nums, n)
  }
}

##### HOMEWORK ON ONLINE PORTFOLIO #####