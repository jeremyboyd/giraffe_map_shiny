# TODO: Figure out how to automatically read in data from Google or GitHub or
# somewhere. See code below for Google sheets. But doesn't seem to work when
# served as a Polished app.

# global.R 
library(shiny)
library(shinyWidgets)
library(polished)
library(tidyverse)
library(readxl)
library(leaflet)
library(googlesheets4)

# Configure the global sessions when the app initially starts up.
polished::polished_config(
    app_name = "giraffe_map_shiny",
    api_key = "v1GDJ310gbQGvLFOboOmpD3HPAP4FHtZS0"
)

# This code does a manual authorization for Google and specifies that the token
# will be stored in the secrets folder in the project directory. Once the token
# is obtained authorization should be automatic.
# options(gargle_oauth_cache = "secrets")
# gs4_auth()
# list.files("secrets")
# gs4_deauth()

# Authorize using token stored in secrets
# gs4_auth(cache = "secrets", email = "asputnam@gmail.com")
