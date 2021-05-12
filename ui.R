# Author: Jeremy Boyd (jeremyboyd@pm.me)

# UI for giraffe map.
ui <- fluidPage(
    
    # Use external CSS
    tags$head(
        tags$link(rel = "stylesheet",
                  type = "text/css",
                  href = "style.css")),
    
    # App title
    titlePanel("Giraffe Populations"),
    
    # Background image
    # setBackgroundImage(src = "giraffe-skin-print-pattern.jpg"),
    
    # Background image with transparency. Problem here is that it makes the app
    # title transparent too.
    # img(src = "giraffe-skin-print-pattern.jpg"),

    # Sidebar with controls
    sidebarLayout(
        sidebarPanel(
            helpText("Circles in the map represent giraffe populations at different institutions. Larger circles indicate larger populations. Red circles represent Masai populations. Purple circles represent generic populations. Use the radio buttons to show only Masai, only generic, or both populations. Click any circle to see additional population information."),
            br(),
            
            # Radio buttons to select different populations
            radioButtons(inputId = "pop",
                         label = "Population",
                         choices = c("Masai", "Generic", "Both"),
                         selected = "Both"),
            br(),
            br(),
            
            # Sign out
            actionButton(
                "sign_out",
                "Sign Out",
                icon = icon("sign-out-alt"))
        ),
        
        # Main panel with map
        mainPanel(
            leafletOutput("map"),
        )
    )
)

# customize your sign in page UI with logos, text, and colors.
my_sign_in <- sign_in_ui_default(
    company_name = "Andrea Putnam",
    logo_top = tags$img(
        src = "giraffe-skin-print-pattern.png",
        alt = "Giraffe icon",
        style = "width: 90px; margin-top: 30px; margin-bottom: 30px;"),
    icon_href = "giraffe-skin-print-pattern.png",
    logo_bottom = NULL,
    background_image = NULL,
    terms_and_privacy_footer = NULL,
    align = "center"
)

polished::secure_ui(ui, sign_in_page_ui = my_sign_in)
