# global.R 
library(shiny)
library(shinyWidgets)
library(polished)
library(tidyverse)
library(readxl)
library(leaflet)

# Configure the global sessions when the app initially starts up.
polished::global_sessions_config(
    app_name = "giraffe_map_shiny",
    api_key = "v1GDJ310gbQGvLFOboOmpD3HPAP4FHtZS0"
)
