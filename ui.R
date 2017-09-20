source("startup.R")

tags$style(type="text/css",
           ".shiny-output-error { visibility: hidden; }",
           ".shiny-output-error:before { visibility: hidden; }"
)
shinyUI(navbarPage(HTML("NIH Fellowship Rates"),

         
tabPanel("Visualization",
         fluidRow(
           headerPanel(HTML("<h1><b><P ALIGN=Center>NIH Fellowship Statistics</b></h1>")),
           shiny::tags$br(),shiny::tags$br(), shiny::tags$br(), HTML("<h4><b><P ALIGN=Center>Updated 20 September 2017</b></h4>"),
           shiny::tags$br(),shiny::tags$br(),
           
           # Plot config
           
           fluidRow(
             column(1, shiny::tags$br()), 
             column(10,
                bsCollapse(id = "colorConfig", open = c("ColorPanel"), multiple = TRUE,
                bsCollapsePanel(title = HTML("<h4><b>Plot Configuration</b></h4>"), value = "ColorPanel", style = "info", 
                  fluidRow(
                    column(4, 
                      selectInput("grantType", "Select Grant Type:", choices = c("F31", "F32"), selected = "F31"),
                      selectInput("xaxis", "Compare values by:", choices = c("INSTITUTE", "YEAR"), selected = "YEAR"),
                      selectInput("yaxis", "Show statistics for:", choices = c("APPLICATIONS", "FUNDED", "RATE", "FUNDING"), selected = "RATE")
                    ),
                    column(4, 
                      conditionalPanel('input.xaxis == "YEAR"', 
                         selectInput("selectInstitutes", "Select Institute:", choices = sort(unique(df$INSTITUTE)), selected = "NCI",
                                     selectize = TRUE, multiple = TRUE)           
                      ),
                      conditionalPanel('input.xaxis == "INSTITUTE"', 
                         selectInput("selectYears", "Select Year:", choices =  unique(df$YEAR), selected = "2016",
                                     selectize = TRUE, multiple = TRUE)
                      ) 
                  ),
                column(4,tags$br())
                )
              ))
            )
           ),
           column(1, shiny::tags$br())
           ),
           
           # Plot output
           
           fluidRow(
             column(1, shiny::tags$br()), 
             column(10,
                bsCollapse(id = "plot1", open = c("plot1"), multiple = TRUE,
                bsCollapsePanel(title = HTML("<h4><b>Interactive Plot</b></h4>"), value = "plot1", style = "info", 
                     plotlyOutput("plot")           
                ))
                    ),
             column(1, shiny::tags$br())
             ),
             
         # Data table
          fluidRow(
             column(1, shiny::tags$br()), 
             column(10,
                bsCollapse(id = "dt1", open = c("dt1"), multiple = TRUE,
                bsCollapsePanel(title = HTML("<h4><b>Table of Displayed Data</b></h4>"), value = "dt1", style = "info", 
                     dataTableOutput('datatable')         
                ))
             ),
             column(1, shiny::tags$br())
             )
  ),
                                      

# FOOTER
theme = shinytheme("flatly"),
footer = HTML(paste0('<P ALIGN=Center>NIH Fellowship Visualization Tool &copy; Caleb Lareau. <A HREF="mailto:caleblareau@g.harvard.edu">Contact</A>')),
collapsible = TRUE, 
fluid = TRUE,
windowTitle = "NIH Fellowship Rates"))


