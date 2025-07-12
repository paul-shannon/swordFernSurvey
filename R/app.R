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
                          width: 300px;
                          }
                       #submitButton{
                          margin-bottom: 20px;
                          }
                       ')),
      tags$table(class="inputWidget",tags$tr(tags$td(
           selectInput(inputId="userNameSelector",
                       label = NULL,
                       choices = c("Anonymous", "Ben", "Kaiis", "Paul", "PNTA", "DNR"),
                       selected = NULL,
                       multiple = FALSE,
                       selectize = TRUE,
                       width = 200,
                       size = NULL)),
                   tags$td(id="observerLabssel", class="inputLabel", "Observer"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
              textInput(inputId="siteNameID",
                       label=NULL,
                       value = "", width = 200, placeholder = NULL)),
              tags$td(class="inputLabel", "Site Name"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        textInput(inputId="location",
                  label=NULL,
                  value = "", width = 200, placeholder = NULL)),
                  tags$td(class="inputLabel", "Location (lat, long)"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
                 sliderInput("elevation", label=NULL,
                              value=100, step=1, min = 1, max = 2000,
                              width=200)),
                 tags$td(class="inputLabel", "Elevation"))),


      tags$table(class="inputWidget", tags$tr(tags$td(
          sliderInput("slope", NULL, min = 0, max = 90, step=1, value=10, width=200)),
          tags$td(class="inputLabel", "Slope"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
          sliderInput("aspect", NULL, value=0, step=1, min = 0, max = 360,
                       width=200)),
          tags$td(class="inputLabel", "Aspect"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
         sliderInput("length", NULL, value=1, step=1, min = 1, max = 100,
                      width=200)),
         tags$td(class="inputLabel", "Length"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        sliderInput("width", NULL, value=1, step=1, min = 1, max = 100,
                     width=200)),
        tags$td(class="inputLabel", "Width"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        selectInput(
          inputId="canopyTypeSelector",
          label = NULL,
          choices = c("Conifers", "Deciduous", "Mixed", "None"),
          selected = NULL,
          multiple = FALSE,
          selectize = TRUE,
          width = 200,
          size = NULL
          )),
        tags$td(class="inputLabel", "Canopy Type"))),


      tags$table(class="inputWidget", tags$tr(tags$td(
        sliderInput("canopyDensity", NULL, value=0,
                      step=1, min = 0, max = 100, width=200)),
        tags$td(class="inputLabel", "Canopy density (%)"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
         sliderInput("swordFernDensity", NULL, value=0,
                      step=1, min = 0, max = 100, width=200)),
         tags$td(class="inputLabel", "Live Sword Fern Count"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
         sliderInput("swordFernMortality", NULL, value=0,
                      step=1, min = 0, max = 100, width=200)),
         tags$td(class="inputLabel", "Dead and dying Sword Fern Count"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        sliderInput("deadFernClass1", NULL, value=0,
                     step=1, min = 0, max = 50, width=200)),
         tags$td(class="inputLabel", "Death Class 1 Count"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        sliderInput("deadFernClass2", NULL, value=0,
                     step=1, min = 0, max = 50, width=200)),
         tags$td(class="inputLabel", "Death Class 2 Count"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        sliderInput("deadFernClass3", NULL, value=0,
                     step=1, min = 0, max = 50, width=200)),
         tags$td(class="inputLabel", "Death Class 3 Count"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
        sliderInput("deadFernClass4", NULL, value=0,
                     step=1, min = 0, max = 50, width=200)),
         tags$td(class="inputLabel", "Death Class 4 Count"))),

      tags$table(class="inputWidget", tags$tr(tags$td(
              textInput(inputId="notes",
                       label=NULL,
                       value = "", width = 200, placeholder = NULL)),
              tags$td(class="inputLabel", "Notes"))),
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
     count <<- count + 1

     titles <- data.frame(user="observer",
                          siteName="siteName",
                          location="location",
                          time="time",
                          elevation="elevation",
                          width="width",
                          length="length",
                          slope="slope",
                          aspect="aspect",
                          canoy="canopyType",
                          canopyDenisty="canopyDensity",
                          fernDensity="healthyFerns",
                          fernMortality="deadAndDying",
                          deadFernClass1="dead Class 1",
                          deadFernClass2="dead Class 2",
                          deadFernClass3="dead Class 3",
                          deadFernClass4="dead Class 4",
                          notes="notes")


     totalDeadFernClassified <- input$deadFernClass1 +
                                input$deadFernClass2 +
                                input$deadFernClass3 +
                                input$deadFernClass4;
     if(totalDeadFernClassified != input$swordFernMortality){
         showModal(modalDialog("Dead dern count by class disagrees with total",
                               size="s"))

     } else {
           newData <- data.frame(user=input$userNameSelector,
                                 siteName=input$siteNameID,
                                 location=input$location,
                                 time=Sys.time(),
                                 elevation=input$elevation,
                                 width=input$width,
                                 length=input$length,
                                 slope=input$slope,
                                 aspect=input$aspect,
                                 canopy=input$canopyTypeSelector,
                                 canopyDenisty=input$canopyDensity,
                                 fernDensity=input$swordFernDensity,
                                 fernMortality=input$swordFernMortality,
                                 deadFernClass1=input$deadFernClass1,
                                 deadFernClass2=input$deadFernClass2,
                                 deadFernClass3=input$deadFernClass3,
                                 deadFernClass4=input$deadFernClass4,
                                 notes=input$notes)


           #sheet_append(uri, titles)
           sheet_append(uri, newData)
           showModal(modalDialog("Successful submission", size="s"))
           } # else
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
