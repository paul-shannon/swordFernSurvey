library(geosphere)
options(digits=12)
centerLat <- 47.5592064
centerLon <- -122.2497865
#--------------------------------------------------------------------------------
toLatLon <- function(plotNumber, angle, distanceInFeet)
{
   #centerLon = subset(tbl.plots, plot==plotNumber)$lon
   #centerLat = subset(tbl.plots, plot==plotNumber)$lat
   center <- c(centerLon, centerLat)

   distanceInMeters = distanceInFeet/3.28084
   destPoint(center, angle, distanceInMeters)
}
#--------------------------------------------------------------------------------
tbl <- read.table("coordinates.tsv", sep="\t", header=TRUE, as.is=TRUE)
lon <- vector(mode="numeric", length=nrow(tbl))
lat <- vector(mode="numeric", length=nrow(tbl))
for (r in 1:nrow(tbl)){
    x <- toLatLon(tbl$fern[r],  tbl$angle[r], tbl$distance[r])
    lon[r] <- as.numeric(x[1, 'lon'])
    lat[r] <- as.numeric(x[1, 'lat'])
    printf("r: %d   %f   %f", r, lon[r], lat[r])
    }

rownames(tbl) <- NULL
tbl$lat <- lat
tbl$lon <- lon
dim(tbl)
head(tbl)
write.table(tbl, file="ferns.tsv", sep="\t", quote=FALSE, row.names=FALSE)
