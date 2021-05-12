# Author: Jeremy Boyd (jeremyboyd@pm.me)
# Description: Shiny app that allows users to interact with a map of giraffe
# populations.

# Read in data
df <- read_xlsx("Giraffe_all_Jan2021.xlsx") %>%
    
    # Convert "generic" and "Hybrid" to "Generic"
    mutate(UDFSubspecies = if_else(UDFSubspecies %in% c("generic", "Hybrid"),
                                   "Generic", UDFSubspecies)) %>%
    
    # Rename location to institution
    rename(Institution = `Current Location`)

# Table for generics
generic <- df %>%
    filter(UDFSubspecies == "Generic") %>%
    group_by(Institution, `Sex Type`) %>%
    summarize(n = n(), .groups = "drop") %>%
    pivot_wider(names_from = "Sex Type", values_from = "n") %>%
    mutate(subspecies = "Generic")

# Table for Masai
masai <- df %>%
    filter(UDFSubspecies == "Masai") %>%
    group_by(Institution, `Sex Type`) %>%
    summarize(n = n(), .groups = "drop") %>%
    pivot_wider(names_from = "Sex Type", values_from = "n") %>%
    mutate(subspecies = "Masai")

# Bind generic & masai rows together
all <- bind_rows(generic, masai) %>%
    
    # Add lat/long back in
    left_join(df %>%
                  select(Institution, Lat, Long) %>%
                  unique(),
              by = "Institution") %>%
    
    # Replace NAs with zeros
    mutate(across(where(is.integer), ~if_else(is.na(.x), 0L, .x))) %>%
    
    # Add up male, female, and undetermined for each row
    rowwise() %>%
    mutate(n_total = sum(Female, Male, Undetermined)) %>%
    ungroup()

# Palette for subspecies colors
pal <- colorFactor(c("navy", "red"), domain = c("Generic", "Masai"))

# Server
server <- function(input, output, session) {
    
    # Create map
    output$map <- renderLeaflet({
        
        # Filter data depending on radio button selection
        if(input$pop %in% c("Masai", "Generic")){
            display_table <- all %>%
                filter(subspecies == input$pop)
        } else {
            display_table <- all
        }
        
        # Create map    
        display_table %>%
            
            # Create leaflet map object
            leaflet::leaflet() %>%
            
            # Add map background
            leaflet::addTiles() %>%
            
            # Add markers
            leaflet::addCircleMarkers(
                
                # Jitter lat/lng to reduce overplotting
                lat = ~ jitter(Lat, factor = 40),
                lng = ~ jitter(Long, factor = 40),
                
                # Adding 4 ensures that even small makers are easily clickable
                radius = ~ n_total + 4,
                
                # Colors for subspecies are determined by the palette "pal"
                color = ~ pal(subspecies),
                
                # Popup text is HTML
                popup = ~ paste(
                    "<b>", Institution, subspecies, "</b><br>",
                    "Female:", Female, "<br>",
                    "Male:", Male, "<br>",
                    "Undetermined", Undetermined),
                
                # No outline around markers
                stroke = FALSE,
                
                # Markers are transparent. This is needed so that users can see when
                # overplotting is happening.
                fillOpacity = 0.5)
    })
    
    # Watch for clicking of sign out button
    observeEvent(input$sign_out, {
        sign_out_from_shiny()
        session$reload()
    })
}

polished::secure_server(server)
