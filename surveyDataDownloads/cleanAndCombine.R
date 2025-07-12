library(jsonlite)
library(sp)
library(parzer)
library(RUnit)
library(yaml)
options(digits=10)
#--------------------------------------------------------------------------------
photoURLs <- yaml.load(readLines("~/github/swordFernSurvey/photos/photo.yaml"))
#--------------------------------------------------------------------------------
standardizeLatLong <- function(s)
{
   dms <- grepl("′", s)
   s <- sub("N", "", s)
   s <- sub("W", "", s)

   if(!dms){
      s <- trimws(sub(",", "", s))
      s <- trimws(gsub("°", "", s))
      tokens <- strsplit(s, split=" +")[[1]]
      lat <- as.numeric(tokens[1])
      lon <- -1 * abs(as.numeric(tokens[2]))
      return(list(lat=lat, lon=lon))
      }

    #--------------------
    # must be dms format
    #--------------------

   s <- trimws(sub(",", "", s))
   tokens <- strsplit(s, split=" +")[[1]]
   lat.dms <- tokens[1]
   lon.dms <- tokens[2]
   lat <- parse_lat(lat.dms)
   lon <- -1 * parse_lon(lon.dms)  # true for all of our data
   return(list(lat=lat, lon=lon))

} # standardizeLatLong
#--------------------------------------------------------------------------------
# the variety of location strings seen thus far
# "47.51223° N, 122.09036° W"
# "47°31′40″ N  121°59′31″ W"

test_standardizeLatLong <- function()
{
  printf("--- test_standardizeLatLong")

  loc.1 <- "47.51223° N, 122.09036° W"
  x <- standardizeLatLong(loc.1)
  checkEqualsNumeric(x$lat, 47.51223, tol=1e-6)
  checkEqualsNumeric(x$lon, -122.0904, tol=1e-6)

  loc.1a <- "47.51223°  122.09036° "   # remove N and W
  x <- standardizeLatLong(loc.1a)
  checkEqualsNumeric(x$lat, 47.51223, tol=1e-6)
  checkEqualsNumeric(x$lon, -122.0904, tol=1e-6)

  loc.2 <- '47°31′40″ N  121°59′31″ W'
  x <- standardizeLatLong(loc.2)
  checkEqualsNumeric(x$lat, 47.52778, tol=1e-6)
  checkEqualsNumeric(x$lon, -121.9919, tol=1e-6)

  loc.2a <- '47°31′40″ ,  121°59′31″ '  # remove N and W
  x <- standardizeLatLong(loc.2a)
  checkEqualsNumeric(x$lat, 47.52778, tol=1e-6)
  checkEqualsNumeric(x$lon, -121.9919, tol=1e-6)

  x.all <- lapply(tbl2$location, standardizeLatLong)

  for(x in x.all){
     printf("lat: %f  lon: %f", x$lat, x$lon)
     checkTrue(x$lat > 46)
     checkTrue(x$lat < 49.0)
     checkTrue(x$lon < -121.8)
     checkTrue(x$lon > -122.5)
     } # for x

} # test_standardizeLatLong
#--------------------------------------------------------------------------------
standardizeUWTable <- function(tbl)
{
   loc.all <- lapply(tbl$location, standardizeLatLong)
   lat.all <- unlist(lapply(loc.all, function(x) x$lat))
   lon.all <- unlist(lapply(loc.all, function(x) x$lon))

   time.tokens <-  strsplit(tbl$time, split=" +")
   date <- unlist(lapply(time.tokens, "[", 1))
   time <- unlist(lapply(time.tokens, "[", 2))

   tbl.std <- tbl
   tbl.std$lat <- lat.all
   tbl.std$lon <- lon.all
   tbl.std$date <- date
   tbl.std$time <- time
   tbl.std$area <- tbl.std$width * tbl.std$length

   tbl.std$siteName <- gsub("#", "", tbl$siteName)

   coi <- c("observer", "siteName", "lat", "lon", "date", "time", "elevation",
            "area", "width",
            "length", "slope", "aspect", "canopyType", "canopyDensity",
            "healthyFernCount", "sickOrDeadFernCount", "dead.Class.1", "dead.Class.2",
            "dead.Class.3", "dead.Class.4", "notes")
   return(tbl.std[, coi])


} # standardizeUWTable
#--------------------------------------------------------------------------------
test_standardizeUWTable <- function()
{
    printf("--- test_standardizeUWTable")

    tbl3 <- standardizeUWTable(tbl2)
    xyz <- 99

} # test_standardizeUWTable
#--------------------------------------------------------------------------------
runTests <- function()
{
   test_standardizeLatLong()
   test_standardizeUWTable()

} # runTests
#--------------------------------------------------------------------------------
addPhotoURLs <- function(tbl, photoURLs)
{
  photos <- list()

  xyz <- "addPhotoToURLs"
  for(r in seq_len(nrow(tbl))){
      siteName <- tbl$siteName[r]
      if(siteName %in% names(photoURLs)){
          files <- photoURLs[[siteName]]
          urls <- paste(sprintf("%s%s", photoURLs$base,
                                photoURLs[[siteName]]), collapse=" | ")
         } # siteName found
      else{
         urls <- ""
         }
     printf("url size: %d", nchar(urls))
     photos[[siteName]] <- urls
     } # for

   tbl$photos <- unlist(photos, use.names=FALSE)

   return(tbl)

} # addPhotoURLs
#--------------------------------------------------------------------------------
files <- sort(list.files(pattern="*.tsv"))
tbls <- list()
for(f in files){
   if(f == "uwObs.tsv") next  # we create this here as the output
   stopifnot(file.exists(f))
   printf("--- reading %s", f)
   tbl <- read.table(f, sep="\t", comment="", header=TRUE, strip.white=TRUE)
   colnames(tbl)[6:7] <- c("width", "length")
   colnames(tbl)[12:13] <- c("healthyFernCount", "sickOrDeadFernCount")
   tbls[[f]] <- tbl
   } # for f

tbl <- do.call(rbind, tbls)
rownames(tbl) <- NULL
tbl <- standardizeUWTable(tbl)

#printf("before detecting dups: %d rows", nrow(tbl))
   # look for duplicates: identical siteName and date
#print(which(duplicated(tbl[, c("siteName", "date")])))
dups <- which(duplicated(tbl[, c("siteName", "date")]))
#printf("length of dups: %d", length(dups))
if(length(dups) > 0){
   #printf("before removing dups: %d rows", nrow(tbl))
   tbl <- tbl[-dups,]
   #printf("after removing dups: %d rows", nrow(tbl))
   }
# tbl <- unique(tbl)
#printf("before standardizing tbl: %d rows", nrow(tbl))

#printf("before adding photos: %d rows", nrow(tbl))
tbl <- addPhotoURLs(tbl, photoURLs)

printf("writing %d rows, %d columns to uwObs.tsv and uwObs.json", nrow(tbl), ncol(tbl))
write.table(tbl, file="uwObs.tsv", sep="\t", col.names=TRUE, quote=FALSE)
jsonText <- toJSON(tbl)
writeLines(jsonText, "uwObs.json")
printf("DO THIS: cp uwObs.json ../map/current/")

