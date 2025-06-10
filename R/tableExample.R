
library(shiny)
library(googlesheets4)
library(rsconnect)
library(quarto)
library(waldo)
#--------------------------------------------------------------------------------
count <- 99
styleString = "#inline label{display: table-cell; text-align: center; vertical-align: middle; } #inline .form-group { display: table-row;}"
#--------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Sword Fern Survey"),
  mainPanel(

      tags$style(HTML('table{
                         border: 0px solid red;}
                       td {
                          width: 100px;
                          height: 50px;
                          }
                       .inputWidget{
                         margin-left: 0px;
                         }
                       .inputLabel{
                          padding-left: 20px;
                          padding-bottom: 10px;
                          color: black;
                          font-size: 16px;
                          width: 200px;
                          }
                       #obs{
                         color: green;
                         padding-left: 100px;
                         padding-top: 0px;
                         }
                       ')),
      tags$table(class="inputWidget",tags$tr(tags$td(
           selectInput(inputId="userNameSelector",
                       label = NULL,
                       choices = c("Anonymous", "Ben", "Kaiis", "Paul"),
                       selected = NULL,
                       multiple = FALSE,
                       selectize = TRUE,
                       width = NULL,
                       size = NULL)),
                   tags$td(id="observerLabssel", class="inputLabel", "Observer"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
              textInput(inputId="siteNameID",
                       label=NULL,
                       value = "", width = NULL, placeholder = NULL)),
              tags$td(class="inputLabel", "Site Name"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        textInput(inputId="location",
                  label=NULL,
                  value = "", width = NULL, placeholder = NULL)),
                  tags$td(class="inputLabel", "Location (lat, long)"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
                 numericInput("elevation", label=NULL, value=100, step=10, min = 1, max = 2000)),
                 tags$td(class="inputLabel", "Elevation"))),


      tags$table(class="inputWidget", tags$tr(tags$td(
          numericInput("slope", NULL, value=0, step=5, min = 0, max = 90)),
          tags$td(class="inputLabel", "Slope"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
          numericInput("aspect", NULL, value=0, step=5, min = 0, max = 360)),
          tags$td(class="inputLabel", "Aspect"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
         numericInput("pacesLength", NULL, value=0, step=1, min = 1, max = 500)),
         tags$td(class="inputLabel", "Length (paces)"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        numericInput("pacesWidth", NULL, value=0, step=1, min = 1, max = 500)),
        tags$td(class="inputLabel", "Width (paces)"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        selectInput(
          inputId="canopyTypeSelector",
          label = NULL,
          choices = c("Conifers", "Deciduous", "Mixed", "None"),
          selected = NULL,
          multiple = FALSE,
          selectize = TRUE,
          width = NULL,
          size = NULL
          )),
        tags$td(class="inputLabel", "Canopy Type"))),


      tags$table(class="inputWidget", tags$tr(tags$td(
        numericInput("canopyDensity", NULL, value=0,
                      step=10, min = 0, max = 100)),
        tags$td(class="inputLabel", "Canopy density (%)"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
         numericInput("swordFernDensity", NULL, value=0,
                      step=5, min = 1, max = 100)),
         tags$td(class="inputLabel", "Sword Fern density (%)"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
         numericInput("swordFernMortality", NULL, value=0,
                      step=5, min = 1, max = 100)),
         tags$td(class="inputLabel", "Sword Fern mortality (%)"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        numericInput("deadFernClass", NULL, value=0,
                     step=1, min = 1, max = 8)),
         tags$td(class="inputLabel", "Max Death Class"))),

     actionButton("submitButton", "Submit")
     ) # mainPanel

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

