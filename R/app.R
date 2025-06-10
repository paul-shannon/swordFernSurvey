library(shiny)
library(googlesheets4)
library(rsconnect)
library(quarto)
library(waldo)
#--------------------------------------------------------------------------------
count <- 99
#--------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Sword Fern Survey"),
  mainPanel(
     renderTable(head(mtcars)),

     selectInput(
     inputId="userNameSelector",
     label = "Who?",
     choices = c("Ben", "Kaiis", "Paul"),
     selected = NULL,
     multiple = FALSE,
     selectize = TRUE,
     width = NULL,
     size = NULL
     ),
     textInput(inputId="siteNameID",
               label="Site Name ",
               value = "", width = NULL, placeholder = NULL),
     textInput(inputId="location",
               label="Location (lat, long)",
               value = "", width = NULL, placeholder = NULL),
     numericInput("elevation", "Elevation", value=100, step=10, min = 1, max = 2000),
     numericInput("slope", "Slope", value=0, step=5, min = 0, max = 90),
     numericInput("aspect", "Aspect", value=0, step=5, min = 0, max = 360),
     numericInput("pacesLength", "Length (paces)", value=0, step=1, min = 1, max = 500),
     numericInput("pacesWidth", "Width (paces)", value=0, step=1, min = 1, max = 500),
     selectInput(
       inputId="canopyTypeSelector",
       label = "Canopy",
       choices = c("Conifers", "Deciduous", "Mixed", "None"),
       selected = NULL,
       multiple = FALSE,
       selectize = TRUE,
       width = NULL,
       size = NULL
       ),
     numericInput("canopyDensity", "Canopy density (%)", value=0,
                  step=10, min = 0, max = 100),
     numericInput("swordFernDensity", "Sword Fern density (%)", value=0,
                  step=5, min = 1, max = 100),
     numericInput("swordFernMortality", "Sword Fern mortality (%)", value=0,
                  step=5, min = 1, max = 100),
     numericInput("deadFernClass", "Max Death Class", value=0,
                  step=1, min = 1, max = 8),
     actionButton("submitButton", "Submit")
     )
  ) # fluidPage
#--------------------------------------------------------------------------------
server <- function(input, output) {

   options(
      gargle_oauth_cache = ".secrets",
      gargle_oauth_email = TRUE
      )
   gs4_auth(
     email = gargle::gargle_oauth_email(),
     path = NULL,
     subject = NULL,
     scopes = "spreadsheets",
     cache = gargle::gargle_oauth_cache(),
     use_oob = gargle::gargle_oob_default(),
     token = NULL
     )


  observeEvent(input$submitButton, {
     print("button click!")
     id <- "1SOcC2jadAb9MXHNezAXO3YqQ8mLaktqmEZtbfQ7x9XY"
     uri <- sprintf("%s/%s",
                    "https://docs.google.com/spreadsheets/d", id)
    # gs4_auth(
    #    email = "paul.thurmond.shannon@gmail.com",
    #    path = NULL,
    #    scopes = "https://www.googleapis.com/auth/spreadsheets",
    #    cache = gargle::gargle_oauth_cache(),
    #    use_oob = gargle::gargle_oob_default(),
    #    token = NULL
    #    )

     #gs4_deauth()
     #gs4_auth(cache=".secrets")
     count <<- count + 1

     titles <- data.frame(user="observer",
                          siteName="siteName",
                          location="location",
                          time="time",
                          elevation="elevation",
                          widthInPaces="width(paces)",
                          lengthInPaces="length(paces)",
                          slope="slope",
                          aspect="aspect",
                          canoy="canopyType",
                          canopyDenisty="canopyDensity",
                          fernDensity="fernDensity",
                          fernMortality="fernMortality",
                          deadFernClass="deadFernClass")
     newData <- data.frame(user=input$userNameSelector,
                           siteName=input$siteNameID,
                           location=input$location,
                           time=Sys.time(),
                           elevation=input$elevation,
                           widthInPaces=input$pacesWidth,
                           lengthInPaces=input$pacesLength,
                           slope=input$slope,
                           aspect=input$aspect,
                           canopy=input$canopyTypeSelector,
                           canopyDenisty=input$canopyDensity,
                           fernDensity=input$swordFernDensity,
                           fernMortality=input$swordFernMortality,
                           deadFernClass=input$deadFernClass)

     #sheet_append(uri, titles)
     sheet_append(uri, newData)
     showModal(modalDialog(
              "Successful submission"
              ))
     })

} # server
#--------------------------------------------------------------------------------
deploy <- function()
{
   require(devtools)
   options(rsconnect.check.certificate = FALSE)
   Sys.unsetenv("GITHUB_PAT")
   install_github("tidyverse/googlesheets4", force=TRUE)
   Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")


   deployApp(account="paulshannon", appName="fernSurvey",
             appFiles=c("app.R", ".secrets"))

} # deploy
#----------------------------------------------------------------------------------------------------

app <- shinyApp(ui, server)

