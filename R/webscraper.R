
# import packages
library(rvest)
library(dplyr)

# let's read a sample web page of of the denver property records
sampleProperty <- read_html("https://www.denvergov.org/Property/realproperty/summary/0503111031031")

sampleTable <- sampleProperty %>% html_elements('#property-info-bar') %>% html_table()

glimpse(sampleTable)