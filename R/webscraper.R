
# import packages
library(rvest)
library(dplyr)

DenverPropertyDF <- list()

# let's read a sample web page of of the denver property records
summaryPage <- read_html("https://www.denvergov.org/Property/realproperty/summary/0503111031031")

# let's grab the intro data (minus the owner's name for privacy and decency reasons)
introTable <- summaryPage %>% html_elements('#property-info-bar') %>% html_table() 

# store our values
DenverPropertyDF$scheduleNumber <- as.character(introTable[[1]][2,3])
DenverPropertyDF$legalDescription <- as.character(introTable[[1]][2,4])
DenverPropertyDF$propertyType <- as.character(introTable[[1]][2,5])
DenverPropertyDF$taxDistrict <- as.character(introTable[[1]][2,6])

# now grab our summary table
summaryTable <- sampleProperty %>% html_elements('#property_summary') %>% html_table() 

# store our values
# building style
DenverPropertyDF$style <- as.character(summaryTable[[1]][1,2])

# number of bedrooms
DenverPropertyDF$numberBedrooms <- as.numeric(summaryTable[[1]][2,2])

# effective year built (we are going to assume the first of the year 
# so we can store it as a date and out of convenience, so did the tax guys)
DenverPropertyDF$effectiveYearBuilt <- as.Date(
  ISOdate(
    as.numeric(summaryTable[[1]][3,2]),
    1,
    1
  )
)

# lot size (in acres, it seems small values are simply listed as zero)
DenverPropertyDF$lotSize <- as.numeric(summaryTable[[1]][4,2])

# mill levy tax rate
DenverPropertyDF$millLevy <- as.character(summaryTable[[1]][5,2])

# square feet of property
DenverPropertyDF$propertySqFt <- as.numeric(summaryTable[[1]][1,4])

# number of full baths on property (toilet and shower/bath)
DenverPropertyDF$fullBaths <- as.numeric(
  substr(summaryTable[[1]][2,4],
         1,
         1
         )
)

# number of half baths on property (toilet only)
DenverPropertyDF$halfBaths <- as.numeric(
  substr(summaryTable[[1]][2,4],
         3,
         3
  )
)

# basement dummy column
DenverPropertyDF$basement <- as.numeric(
  substr(summaryTable[[1]][3,4],
         1,
         1
  )
)

# finished basement dummy column
DenverPropertyDF$finishedBasement <- as.numeric(
  substr(summaryTable[[1]][3,4],
         3,
         3
  )
)

# zoning code
DenverPropertyDF$zoningCode <- as.character(summaryTable[[1]][4,4])

# shows the last sale document type (eg "WD" written deed "QC" quit claim)
DenverPropertyDF$documentType <- as.character(as.character(summaryTable[[1]][5,4]))

# let's read a the chain of title page for the property on the denver property records
chainOfTitlePage <- read_html("https://www.denvergov.org/property/realproperty/chainoftitle/0503111031031")

# let's grab the intro data (minus the owner's name for privacy and decency reasons)
titleTable <- chainOfTitlePage %>% html_elements('#no-more-tables') %>% html_table() 

# # last price this property was sold for
# lastSalePrice <- as.character(titleTable[[2]][2,5])

for(entry in 1:(nrow(titleTable[[2]])/2)){
  print(titleTable[[2]][entry*2,])
  # date recorded for the last sale of this property
  DenverPropertyDF[[paste("lastSaleDate", entry, sep="")]] <- as.Date(
    as.character(titleTable[[2]][entry*2,4]), 
    format = "%m/%d/%y"
    )

  # last price this property was sold for
  DenverPropertyDF[[paste("lastSalePrice", entry, sep="")]] <- as.character(titleTable[[2]][entry*2,5])
  
}

# # date recorded for the last sale of this property
# lastSaleDate <- as.Date(
#   as.character(titleTable[[2]][2,4]), 
#   format = "%m/%d/%y"
#   )

# our summary data frame
summaryDF<- data.frame(
  scheduleNumber,
  legalDescription,
  propertyType,
  taxDistrict,
  style,
  numberBedrooms,
  effectiveYearBuilt,
  lotSize,
  millLevy,
  propertySqFt,
  fullBaths,
  halfBaths,
  basement,
  finishedBasement,
  zoningCode,
  documentType,
  lastSalePrice,
  lastSaleDate
)

DenverPropertyDF <- do.call("data.frame", DenverPropertyDF)