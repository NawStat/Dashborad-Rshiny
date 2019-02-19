###install missing packages
if(!require(shiny)) { install.packages("shiny"); require(shiny)}
if(!require(rworldmap)) { install.packages("shinyBS"); require(rworldmap)}
if(!require(fmsb)) { install.packages("fmsb"); require(fmsb)}
if(!require(DT)) { install.packages("DT"); require(DT)}
if(!require(DT)) { install.packages("DT"); require(shinythemes)}

shinyUI (fluidPage(
  theme = shinythemes::shinytheme("flatly"),
 navbarPage( h4( "Global Innovation Index", style="color:#ff6666;"), 
          tabPanel(
            h4("Cartography", style=" font-weight:bold;#000000"),
            sidebarLayout(
              sidebarPanel(
                    selectInput("datasetCarte", "Select a year",  c('2017','2016','2015','2014','2013')),
                    selectInput("columns","Select indicator",choices=vchoices),
                    selectInput("color","Select color",c( 'rainbow','heat','terrain','topo')) ,
                    downloadButton("downMap", label="Download wold's map", class = "butt"),
                    tags$head(tags$style(".butt{background-color:#ff6666;} .butt{color: white;}")),
                    h6("note:", style="font-weight:bold;color:#ff6666;"),
                    h6("Don't forget the extantion .png when you are downloading the  plot!")
                    
                    ),
                   ### try side bar 
              mainPanel(
                h2("World Maps", style = " text-align: center; font-family: 'Lobster', cursive;
                          font-weight: 500; line-height: 1.1; 
                   color:#2eb82e;"),
                plotOutput("Cart", height="550px", width="1000px")
              )
              
            )
                       
            ),          
          tabPanel(h4("Compare between countries", style=" font-weight:bold"),
                   sidebarLayout(
                     sidebarPanel(h4("Pick Columns from Various Dataframes", style= "font-family: 'Lobster', cursive;
                          font-weight: 500; line-height: 1.1; text-align: center;
                                     color:   #ff6666;"),
                       selectInput("dataRadar", "Select a year",  c('2017','2016','2015','2014','2013')),
                       selectInput("Col","Select  indicators",choices=vchoices, multiple = TRUE),
                       selectInput("count","Select countries",choices=vcountry, multiple = TRUE),
                       downloadButton("downRadar", label="Download Radar Chart", class = "butt"),
                       tags$head(tags$style(".butt{background-color:#ff6666;} .butt{color: white;}")),
                       h6("note:", style="font-weight:bold;color:#ff6666;"),
                       h6("Don't forget the extantion .png when you are downloading the  plot!"),
                       downloadButton("downloadMiniData", label="Download selected data", class = "butt"),
                       tags$head(tags$style(".butt{background-color:#ff6666;} .butt{color: white;}"))
                       
                     ),
                     mainPanel(
                       tabsetPanel(
                         tabPanel(
                          h4("Radar Chart", style = "font-family: 'Lobster', cursive;
                          font-weight: 500; line-height: 1.1; text-align: center; 
                          color:  #2eb82e;"),
                          plotOutput("radar", height="700px", width="700px")),
                       
                         tabPanel(
                          h4("The dataset that you selected", style = "font-family: 'Lobster', cursive;
                          font-weight: 500; line-height: 1.1; text-align: center; 
                          color:  #2eb82e;"),
                          dataTableOutput('miniTable'))
                     )
                   )
                   )), 
          tabPanel(h4("Explore Data", style=" font-weight:bold"), 
                   h4("EXPLORE THE INTERACTIVE DATABASE OF THE GII INDICATORS", style="background-color:#b0ffd1"),
                   selectInput("dataset", "Select a year",  c('2017','2016','2015','2014','2013')),
                   
                   uiOutput('columns'),
                   h6("note:", style="font-weight:bold;color:#ff6666;"),
                   h6("You can fin Sources and Definitions of dataset's variables, in section About the application."),
                   # Button
                   downloadButton("downloadData", label="Download Data", class = "butt"),
                   tags$head(tags$style(".butt{background-color:#ff6666;} .butt{color: white;}")),
                   dataTableOutput('myTable')),
          tabPanel(h4("About", style=" font-weight:bold"),
                   sidebarLayout(
                     sidebarPanel(
                       img(src="naw.jpg", height = 180, width = 120, align="left"),
                       img(src="in.png", height = 30, width = 30, align="left"), 
                       a(href="https://www.linkedin.com/in/nawres-jguirim-8ba059b3/", " Nawres Jguirim"),br(),
                       br(),img(src="mail.png", height = 35, width = 35, align="left"),
                       h5("nawress.jguirim@gmail.com" , style="font-weight: bold;"),br(),
                       img(src="uni.png", height = 30, width = 30, align="left"), 
                       a(href="http://www.essai.rnu.tn/accueil.htm", "  Engineering School of Statistics: ESSAI"),
                       br(),br()
                       
                       
                     ),
                     mainPanel( tabsetPanel(
                       tabPanel(
                         "About the Application",
                         h3("This Dashoard",style =  "font-family: 'Lobster', cursive;
                                font-weight: 500; line-height: 1.1;color:   #ff6666;"     ),
                         "The aim of this dashborad is to:", 
                         tags$li("Facilitate the visualisation of GII informations."), 
                         tags$li("Compare between countries."),
                         tags$li("Explore more than 100 scio-economic political  world's indicator."),br(),
                         "Also it allows the users to download: ",
                         tags$li("Database depending on his choice(countries, year , indicators)."),
                         tags$li(" A custumesed  Radar Chart and the wold's map."),br(),
                         h5("To dowload the original data: ", style="font-weight: bold; color:#004d00"),
                         a(href="https://www.globalinnovationindex.org/analysis-indicator", "Check this link"),
                         br(),
                         h3("Data base indicators",style =  "font-family: 'Lobster', cursive;
                          font-weight: 500; line-height: 1.1;color:   #ff6666;"     ),
                         "We have stored in this app  114 socio-economic-political indicators, generally about : ", 
                         tags$li("HUMAN CAPITAL AND RESEARCH") ,
                         tags$li("INFRASTRUCTURE"),
                         tags$li("MARKET SOPHISTICATION"),
                         tags$li("BUSINESS SOPHISTICATION"),
                         tags$li("KNOWLEDGE AND TECHNOLOGY OUTPUTS"),
                         tags$li("CREATIVE OUTPUTS"),br(),
                         
                         "To know more about Sources and Definitions of dataset used in this applicaion, you can find its description in this  pdf :",br(),
                         downloadButton("downPdf", label="Download the PDF", class = "butt"),
                         tags$head(tags$style(".butt{background-color:#ff6666;} .butt{color: white;}"))
                         
                         ),
                       tabPanel(
                         "About GII",
                         img(src="gii.jpg", height = 150, width = 150, align="right"),
                         
                         br(),
                         h3("Global Innovation index",style =  "font-family: 'Lobster', cursive;
                                font-weight: 500; line-height: 1.1;color:   #ff6666;"     ),
                         " The Global Innovation Index (GII) aims to capture the multi-dimensional facets of 
                                innovation and provide the tools that can assist in tailoring policies to promote long-term
                                output growth, improved productivity, and job growth." ,br(),"The GII helps to create an environment
                                in which innovation factors are continually evaluated." ,br()," It provides a key tool and a rich database of detailed metrics for economies, which in 2017 encompasses 127 economies,
                                representing 92.5% of the world's population and 97.6% of global GDP.",
                         h5("To know more: Check this link", style="font-weight: bold; color:#004d00"),
                         a(href="https://www.globalinnovationindex.org/home", "Check this link"),
                         h5("To dowload the annual reports:", style="font-weight: bold; color:#004d00"),
                         a(href="https://www.globalinnovationindex.org/gii-2017-report","Check this link")
                         
                         
                         
                         
                         
                         
                                
                       )
                     )) 
                   )
                   
                           
                   
                   )
          
      )
    )
    
)
