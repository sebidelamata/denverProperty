#' Iteratevely runs webscraper function through vector of parcel ids
#'
#' @export
#' 

webscraperCollect <- function(){

# read in our vector of parcel ids
parcelVector <- readRDS(
  ".//data//parcelVector.Rds"
)

# we need to do some data cleaning to our parcel vector
for(parcel in 1:length(parcelVector)){
  
  # first lets make it a character
  parcelVector[parcel] <- as.character(parcelVector[parcel])
  
  # next we need to make the parcel id 13 chars in length, by adding "0"s
  # to the end until it is 13 characters long
  parcelVector[parcel] <- paste0(
    paste(
      rep(
        "0",
        times = 13 - nchar(parcelVector[parcel])
      ),
      collapse = ""
    ),
    parcelVector[parcel]
  )
  
}

# initialize scrapedPropertyData list
scrapedPropertyData <- list()

# iterate through the parcel ids and run the webscraper function with that parcel id
for(parcel in 1:length(parcelVector[1:10])){
  print(scrapedPropertyData)
  # run our webscraper script to return a single row stored in a list object
  scrapedData <- webscraper(parcelVector[parcel])
  scrapedPropertyData[[parcel]] <- scrapedData
  
}

#return(scrapedPropertyData)

}
