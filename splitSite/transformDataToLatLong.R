library(geosphere)
options(digits=12)
library(jsonlite)
centerLat <- 47.5561
centerLon <- -122.2533
#--------------------------------------------------------------------------------
toLatLon <- function(angle, distanceInFeet)
{
   center <- c(centerLon, centerLat)

   distanceInMeters = distanceInFeet/3.28084
   destPoint(center, angle, distanceInMeters)

} # toLatLon
#--------------------------------------------------------------------------------
f <- "fromBen.tsv"
tbl <- read.table(f, sep="\t", nrow=-1, header=TRUE)
lon <- vector(mode="numeric", length=nrow(tbl))
lat <- vector(mode="numeric", length=nrow(tbl))
for (r in 1:nrow(tbl)){
    x <- toLatLon(tbl$angle[r], tbl$distance[r])
    lon[r] <- as.numeric(x[1, 'lon'])
    lat[r] <- as.numeric(x[1, 'lat'])
    printf("r: %d   %f   %f", r, lon[r], lat[r])
    }

rownames(tbl) <- NULL
tbl$lat <- lat
tbl$lon <- lon
tbl$status
dim(tbl)
head(tbl)
write.table(tbl, file="ferns.tsv", sep="\t", quote=FALSE, row.names=FALSE)
jsonText <- toJSON(tbl, digits=10) #, dataframe="values")
writeLines(jsonText, "ferns.json")

