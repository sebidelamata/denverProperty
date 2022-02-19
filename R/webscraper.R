#' Scrapes denver property website for data for a single parcel
#' 
#' @import rvest
#' @import dplyr
#' 
#' @param parcelID A string containing the parcel ID for the property
#' @param rowNumber A number containing the row number for this property parcel
#' 
#' @example webscraper("0503111031031", 1) 
#'  
#' @export


# create an empty list to hold our unstructured data (we will convert this into a data frame later)
denverPropertyDF <- list()

# let's read a sample web page of of the denver property records
summaryPage <- rvest::read_html("https://www.denvergov.org/Property/realproperty/summary/0503111031031")

# let's grab the intro data (minus the owner's name for privacy and decency reasons)
introTable <- summaryPage %>% 
  rvest::html_elements('#property-info-bar') %>% 
  rvest::html_table() 

# store our values
# schedule number is the primary id for how proerties are stored on the site
denverPropertyDF$scheduleNumber <- as.character(introTable[[1]][2,3])

# legal description is how the address is listed by the city (not street address)
denverPropertyDF$legalDescription <- as.character(introTable[[1]][2,4])

# property type describes if it is residential single family etc
denverPropertyDF$propertyType <- as.character(introTable[[1]][2,5])

# tax district for the property
denverPropertyDF$taxDistrict <- as.character(introTable[[1]][2,6])

# now grab our summary table
summaryTable <- summaryPage %>% 
  rvest::html_elements('#property_summary') %>% 
  rvest::html_table() 

# store our values
# building style
denverPropertyDF$style <- as.character(summaryTable[[1]][1,2])

# number of bedrooms
denverPropertyDF$numberBedrooms <- as.numeric(summaryTable[[1]][2,2])

# effective year built (we are going to assume the first of the year 
# so we can store it as a date and out of convenience, so did the tax guys)
denverPropertyDF$effectiveYearBuilt <- as.Date(
  ISOdate(
    as.numeric(summaryTable[[1]][3,2]),
    1,
    1
  )
)

# lot size (in acres, it seems small values are simply listed as zero)
denverPropertyDF$lotSize <- as.numeric(summaryTable[[1]][4,2])

# mill levy tax rate
denverPropertyDF$millLevy <- as.character(summaryTable[[1]][5,2])

# square feet of property
denverPropertyDF$propertySqFt <- as.numeric(summaryTable[[1]][1,4])

# number of full baths on property (toilet and shower/bath)
denverPropertyDF$fullBaths <- as.numeric(
  substr(summaryTable[[1]][2,4],
         1,
         1
         )
)

# number of half baths on property (toilet only)
denverPropertyDF$halfBaths <- as.numeric(
  substr(summaryTable[[1]][2,4],
         3,
         3
  )
)

# basement dummy column
denverPropertyDF$basement <- as.numeric(
  substr(summaryTable[[1]][3,4],
         1,
         1
  )
)

# finished basement dummy column
denverPropertyDF$finishedBasement <- as.numeric(
  substr(summaryTable[[1]][3,4],
         3,
         3
  )
)

# zoning code
denverPropertyDF$zoningCode <- as.character(summaryTable[[1]][4,4])

# let's read a the chain of title page for the property on the denver property records
chainOfTitlePage <- rvest::read_html("https://www.denvergov.org/property/realproperty/chainoftitle/0503111031031")

# let's grab the intro data (minus the owner's name for privacy and decency reasons)
titleTable <- chainOfTitlePage %>% 
  rvest::html_elements('#no-more-tables') %>% 
  rvest::html_table() 

# create a for loop to create a varying number of columns based on the number of previous sales
lapply(1:(nrow(titleTable[[2]])/2), function(entry){
  
  # date recorded for the last sale of this property
  denverPropertyDF[[paste("lastSaleDate", entry, sep="")]] <<- as.Date(
    as.character(titleTable[[2]][entry*2,4]), 
    format = "%m/%d/%Y"
    )

  # last price this property was sold for
  denverPropertyDF[[paste("lastSalePrice", entry, sep="")]] <<- as.numeric(
    gsub(
      "[$,]",
      "",
      as.character(titleTable[[2]][entry*2,5])
      )
  )
  
  # instrument this property was sold through (wd = written deed, qc = quitclaim)
  denverPropertyDF[[paste("lastContractInstrument", entry, sep="")]] <<- as.character(titleTable[[2]][entry*2,3])
  }
)

# convert our list to a structured data frame
denverPropertyDF <- do.call("data.frame", denverPropertyDF)