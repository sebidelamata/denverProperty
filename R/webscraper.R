
# import packages
library(rvest)
library(dplyr)

# let's read a sample web page of of the denver property records
sampleProperty <- read_html("https://www.denvergov.org/Property/realproperty/summary/0503111031031")

summaryTable <- sampleProperty %>% html_elements('#property-info-bar') %>% html_table() 

# store our values
scheduleNumber <- as.character(summaryTable[[1]][2,3])
legalDescription <- as.character(summaryTable[[1]][2,4])
propertyType <- as.character(summaryTable[[1]][2,5])
taxDistrict <- as.character(summaryTable[[1]][2,6])

summaryDF<- cbind(
  scheduleNumber,
  legalDescription,
  propertyType,
  taxDistrict
)

