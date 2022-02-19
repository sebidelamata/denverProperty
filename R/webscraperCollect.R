#' Iteratevely runs webscraper function through vector of parcel ids
#'
#' @export
#' 

webscraperCollect <- function(){
# read in our vector of parcel ids
parcelVector <- readRDS(
  ".//data//parcelVector.Rds"
)

# run our webscraper script to return a single row stored in a list object
scrapedPropertyData <- webscraper("0503111031031")

return(scrapedPropertyData)

}
