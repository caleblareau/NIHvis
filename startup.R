library(shinyBS)
library(shiny)
library(shinythemes)
library(BuenColors)
library(plotly)
library(DT)

df <- read.table("NIH_funding_data.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)
df$RATE <- as.numeric(df$RATE)