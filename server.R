###install missing packages
if(!require(shiny)) { install.packages("shiny"); require(shiny)}
if(!require(rworldmap)) { install.packages("shinyBS"); require(rworldmap)}
if(!require(fmsb)) { install.packages("fmsb"); require(fmsb)}
if(!require(DT)) { install.packages("DT"); require(DT)}
if(!require(DT)) { install.packages("DT"); require(shinythemes)}


###importing 
d2017 <- read.csv("data/2017.csv",header = T,fileEncoding="latin1", sep=";")
d2016 <- read.csv("data/2016.csv",header = T,sep=";")
d2015 <- read.csv("data/2015.csv",header = T, sep=";")
d2014 <- read.csv("data/2014.csv",header = T,fileEncoding="latin1", sep=";")
d2013 <- read.csv("data/2013.csv",header = T, fileEncoding="latin1", sep=";")
for( i in  2 : ncol(d2015)) { d2015[, i]= as.numeric(d2015[,i])}
for( i in  2 : ncol(d2016)) { d2016[, i]= as.numeric(d2016[,i])}
for( i in  2 : ncol(d2014)) { d2014[, i]= as.numeric(d2014[,i])}
for( i in  2 : ncol(d2013)) { d2013[, i]= as.numeric(d2013[,i])}
for( i in  2 : ncol(d2017)) { d2017[, i]= as.numeric(d2017[,i])}

rownames(d2017)=d2017$X
rownames(d2016)=d2016$X
rownames(d2015)=d2015$X
rownames(d2014)=d2014$X
rownames(d2013)=d2013$X
vchoices <- names(d2017[,-1])
vcountry= rownames(d2017)


                         
shinyServer(function(input, output) {
 
   ############### Reactive data ###############
  datasetInput <- reactive({
   switch(input$dataset,
           "2017" = d2017,
          "2016" = d2016,
           "2015" = d2015,
           "2014" = d2014,
           "2013" = d2013) })
  datasetInputCarte <- reactive({
    switch(input$datasetCarte,
           "2017" = d2017,
           "2016" = d2016,
           "2015" = d2015,
           "2014" = d2014,
           "2013" = d2013) })
  datasetInputRadar <- reactive({
    switch(input$dataRadar,
           "2017" = d2017,
           "2016" = d2016,
           "2015" = d2015,
           "2014" = d2014,
           "2013" = d2013) })
  
  ############### plot maping ############### 
  plotInputMap = function() { sPDF <- joinCountryData2Map(datasetInputCarte()
                                                       , joinCode = "NAME"
                                                       , nameJoinColumn = "X")
  
  mapParams <- mapPolys(sPDF, nameColumnToPlot=input$columns , 
                        mapRegion='world',catMethod= "fixedWidth",
                        missingCountryCol='dark grey', numCats=8, 
                        colourPalette=input$color,
                        addLegend=F,
                        oceanCol='light blue')
  mtext("[Grey Color: No Data Available]",side=1,line=-1)
  do.call(addMapLegend
          ,c(mapParams
             ,legendLabels="all"
             ,legendWidth=0.5
             ,legendIntervals="data"
             ,legendMar = 2 ))}
  
    output$Cart <- renderPlot({
      plotInputMap()
    } )

    ############### download map   ###############
    output$downMap <- downloadHandler(
      filename = "Shinyplot.png",
      content = function(file) {
        png(file,width = 900, height = 900, units = "px")
        print(plotInputMap())
        dev.off()
      }
    )
    
  ############### table output  ###############
  output$myTable <- DT::renderDataTable(
    datatable(
      datasetInput(), rownames = FALSE,  filter = 'top',
      extensions = 'Buttons', options = list(dom = 'Bfrtip', buttons = I('colvis'),pageLength = 5 ,autoWidth = TRUE)
    ))
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    })
  
  
  ############### table de comparaison ###############
  Dataframe2 <- reactive({
    datasetInputRadar()[input$count,input$Col]
  })
  output$miniTable <- DT::renderDataTable(Dataframe2() )  
  
  ############### download csv of selected mini data ###############
  output$downloadMiniData <- downloadHandler(
    filename = "SelectedData.png",
    content = function(file) {
      write.csv(Dataframe2(), file, row.names = FALSE)
    })
  
  
  ############### radarchart ############### 
  plotInputRadar = function() {  d= Dataframe2()
  minMax=rbind.data.frame(rep(127,length(input$Col)) , rep(0,length(input$Col)))
  colnames(minMax)=colnames(d)
  d=rbind.data.frame(minMax, d)
  radarchart(  d,pcol=rainbow(length(input$count)), pangle=2,pfcol= rainbow(length(input$count)), 
               pdensity=15,plwd=2 , plty=1, seg=5,
               cglcol="grey", cglty=3, axislabcol="grey",axistype=4,
               caxislabels=seq(0,127,20), cglwd=0.8,
               vlcex=0.8)
  legend(x=0.7, y=0.7,legend = input$count,
         bty = "n", pch=10 ,
         col=rainbow(length(input$count)) , text.col = "grey", cex=1.3, pt.cex=3)    
  }
  output$radar=renderPlot({
    plotInputRadar()  
  })
  
  ## download radarchart plot ##
  output$downRadar <- downloadHandler(
    filename = "Shinyplot.png",
    content = function(file) {
      png(file,width = 900, height = 900, units = "px")
      print(plotInputRadar())
      dev.off()
    }
  )
  
  ############### Download columns  discreption ###############
  output$downPdf <- downloadHandler(
    filename = "description.pdf",
    content = function(file) {
      file.copy("www/selection.pdf", file)
    }
  ) 
  
}
)
