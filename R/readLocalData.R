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