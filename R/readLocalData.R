#' read local data into Rds objects
#' 
#' @return Two objects: a) a dataframe holding residential characteristics for all 
#' properties, and b) a vector containing strings of all the property parcel ids for denver

# this csv can be downloaded from the denver property website and gives us some data, plus a list of parcel
# ids that we can use to iterate through our webscraping script for each property id
localData <- read.csv("C:\\Users\\sebid\\Downloads\\real_property_residential_characteristics.csv")

saveRDS(
  localData,
  "..\\data\\residentialCharacteristics.rds"
)

parcelVector <- as.character(localData$PARID)

saveRDS(
  parcelVector,
  "..\\data\\parcelVector.rds"
)