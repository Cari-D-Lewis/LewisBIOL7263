##### rentrez Caleb Paslay 10-Nov-22 #####
# install the necessary packages
install.packages("glue")
install.packages("rentrez")


# load the necessary packages
library(rentrez)
library(tidyverse)
library(ggplot2)
library(glue)

# Caleb wanted to compile information about the viruses known to infect pepper for his research
# Was looking up the individual genome for the alfalfa mosaic virus and where each sequence file
# was reported from by hand, scrolling through all the files. Rentrez interacts with NCBI and PubMed
# to streamline searching for specific things from the web. Utility is to fetch and summarize information
# and plotting the data.

# Caleb's lesson
# call the databases entrez interacts with
entrez_dbs()

# call the nuccore database summary information
entrez_db_summary("nuccore")

# can also use the searchable function to specify parameters to search for
entrez_db_searchable("nuccore")

# show the cross references between databases
entrez_db_links() # useful, but not using today

# provides brief overviews or summaries 
entrez_search()

# provides "Full" records of search terms
entrez_fetch()

# BUILDING A SEARCH
# create an object to hold the search data
amv_search <- entrez_search(db = "nuccore", 
                            term = "alfalfa mosaic virus")

amv_search

# change the number of IDs searched (20 is default, 10000 is max; can be batched if needed)
amv_search2 <- entrez_search(db = "nuccore", 
                            term = "alfalfa mosaic virus",
                            retmax = 100) # useful when specifying specific search terms to pull ALL the available search items

# specify that the search term is for a specific organism
amv_search3 <- entrez_search(db = "nuccore", 
                            term = "alfalfa mosaic virus[ORGN]", # specify the organism
                            retmax = 100) 

# refine the search even further using boolean operators (and, or, not) and published data range
amv_search4 <- entrez_search(db = "nuccore", 
                             term = "alfalfa mosaic virus[ORGN] and 2000:2016[PDAT]", # add boolean AND and published date range
                             retmax = 100) 

# create a search summary
entrez_summary(db = "nuccore", id = 195547167)

entrez_summary(db= "nuccore", id = amv_search$ids)

# create a new search for the brca gene for example use
brca_1 <- entrez_search(db = "pubmed", 
                        term = "brca gene[TITL] AND human", 
                        retmax = 100) # set the retmax higher to include all the hits

# create the summary object
amv_multi_sum <- entrez_summary(db = "nuccore", id = amv_search$ids)
brca_multi_sum <- entrez_summary(db = "pubmed", id = brca_1$ids)

# extract elements from the summary using the 
extract_from_esummary(amv_multi_sum,
                      "title",
                      simplify = TRUE)

# slen = sequence length
multi_extract <- extract_from_esummary(amv_multi_sum, 
                                       c("title","slen","organism"),
                                       simplift = TRUE)

# view the summary data for the elements specified
view(multi_extract)

# extract from the brca_1 gene database summary
multi_brca_extract <- extract_from_esummary(brca_multi_sum,
                                            c("title","pubtype","pubdate","authors"),
                                            simplify = TRUE)

# view the summary
view(multi_brca_extract)

## FETCHING ARGUMENTS
# example code
entrez_fetch(db = "nuccore", id = <from the search>, rettype = "fasta")

# fetch from the amv_search all the fasta sequence files
amv_fetch <- entrez_fetch(db = "nuccore", 
                          id = amv_search$ids, # must specify IDs
                          rettype = "fasta")

class(amv_fetch)

nchar(amv_fetch)

write(amv_fetch, file = "my_amv_transcripts.fasta")

# fetch from the brca object
brca_fetch <- entrez_fetch(db= "pubmed", 
                           id = brca_1$ids, 
                           rettype = "abstract")

# write a file of all the paper abstracts that match with human brca gene
write(brca_fetch, file = "my_brca_abstracts.txt")


## PLOTTING PUBLICATIONS OVER TIME FOR A SPECIFIC FIELD
# create an object for searching in glue
year <- 1950:2022
alfalfa_search <- glue("alfalfa mosaic virus[TITL] AND {year}[PDAT]")

# create a second search to compare change over time in publications
tomato_search <- glue("tomato yellow leaf curl virus[TITL] AND {year}[PDAT]")

search_counts <- tibble(year = year,
                        alfalfa_search = alfalfa_search,
                        tomato_search = tomato_search) %>%
  mutate(AMV = map_dbl(alfalfa_search,
                       ~entrez_search(db = "pubmed",
                                      term = .x)$count),
         tomato = map_dbl(tomato_search, ~entrez_search(db = "pubmed",
                                                        term = .x)$count))

# plot the number of publications for AMV and tomato viruses from 1950 to 2022
search_counts %>%
  select(year, AMV, tomato) %>%
  pivot_longer(-year) %>%
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line(size = 1)+
  geom_smooth()+
  theme_bw()

# can pull all the publications published over time
all_search <- glue("{year}[PDAT]")

