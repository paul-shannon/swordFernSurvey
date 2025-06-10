library(googlesheets4)

id <- "1SOcC2jadAb9MXHNezAXO3YqQ8mLaktqmEZtbfQ7x9XY"

uri <- sprintf("%s/%s",
               "https://docs.google.com/spreadsheets/d", id)
#gs4_auth()
gs4_auth(
  email = "paul.thurmond.shannon@gmail.com",
  path = NULL,
  scopes = "https://www.googleapis.com/auth/spreadsheets",
  cache = gargle::gargle_oauth_cache(),
  use_oob = gargle::gargle_oob_default(),
  token = NULL
  )

as.data.frame(read_sheet(uri, range="Sheet1!1:2"))
as.data.frame(read_sheet(uri, range="Sheet1"))

sheet_append(uri,
             data.frame(data="2019-01-15", lat=47.55111, lon=-122.25999, elevation=800, slope=30))
