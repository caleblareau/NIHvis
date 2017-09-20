source("startup.R")

shinyServer(function(input, output, session) {
  
  options(warn = -1) 
  options(shiny.error = function() { "" })

  rv <- reactiveValues(
    df = df, 
    prettydf = df
  )
  
  # Subset the master data frame based on user input
  observe({

    qdf <- df[df$GRANT == input$grantType, ]
    if(input$xaxis == "YEAR"){
      if(length(input$selectInstitutes) != 0){
        odf <- qdf[qdf$INSTITUTE %in% input$selectInstitutes,] 
      } else {
        odf <- data.frame()
      }
    } else {
      if(length(input$selectYears != 0)){
        odf <- qdf[qdf$YEAR %in% input$selectYears,] 
      } else {
        odf <- data.frame()
      }
    }
    
    rv$df <- odf
    
    print(odf)
    if(dim(odf)[1] > 0){
      # Make a nicely formatted data frame
      odf$FUNDING <- paste0("$", formatC(as.numeric(odf$FUNDING), format="f", digits=0, big.mark=","))
      odf$RATE <- paste0(as.character(odf$RATE), "%")
      rv$prettydf <- odf
    } else {
      rv$prettydf <- data.frame()
    }
    
  })
  
  output$datatable <- renderDataTable(rv$prettydf, rownames = FALSE)
  
  # Make plot
  output$plot <- renderPlotly({
    
    idf <- rv$df
    prdf <- rv$prettydf
    
    if(dim(idf)[1] == 0) return(NULL) # protect against empty plots
    
    # Make color the opposite of x axis
    if(input$xaxis == "INSTITUTE"){
      colorid <- "YEAR"
    } else {
      colorid <- "INSTITUTE"
    }
    
    # Make plot data frame
    anno <- apply(sapply(colnames(prdf), function(name){paste0(name, ": ", prdf[,name])}), 1, paste, collapse = "<br>")
    plot.df <- data.frame(x = idf[,input$xaxis],
                          y = idf[,input$yaxis],
                          color = as.factor(idf[,colorid]),
                          Annotation = anno, stringsAsFactors = FALSE)
    colnames(plot.df) <- c("x", "y","Color" , "Annotation")
    
    # Only make line plots for the year on the x axis
    if(input$xaxis == "INSTITUTE"){
      plot_ly(plot.df, x = ~x, y = ~y, mode = "markers", color = ~Color, text = ~Annotation, type = "scatter", 
              marker = list(size = 15)) %>%
        layout(title = paste0(""),
               xaxis = list(title = input$xaxis),
               yaxis = list(title = input$yaxis))
    } else {
      plot_ly(plot.df, x = ~x, y = ~y, mode = "lines", color = ~Color, text = ~Annotation, type = "scatter", 
              marker = list(size = 15)) %>%
        layout(title = paste0(""),
               xaxis = list(title = input$xaxis),
               yaxis = list(title = input$yaxis))
    }
      
  })
  
})