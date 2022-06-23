library("shiny")

shinyUI(pageWithSidebar(
  
  headerPanel("TB dashboard"),
  
  sidebarPanel(
    checkboxGroupInput("bact", "Bacteria:",
                       list("H37Rv" = "Rv",
                            "GC1237" = "GC",
                            "H37Rv (heat-inactivated)" = "Rv+",
                            "Bacillus Calmette–Guérin" = "BCG",
                            "Mycobacterium smegmatis" = "Smeg",
                            "Yersinia pseudotuberculosis" = "Yers",
                            "Salmonella typhimurium" = "Salm",
                            "Staphylococcus epidermidis" = "Staph"),
                       selected = c("H37Rv", "GC1237",
                                    "H37Rv (heat-inactivated)",
                                    "Bacillus Calmette–Guérin",
                                    "Mycobacterium smegmatis",
                                    "Yersinia pseudotuberculosis",
                                    "Salmonella typhimurium",
                                    "Staphylococcus epidermidis")),
    br(),
    checkboxGroupInput("time", "Timepoints:",
                       list("4 hours" = 4,
                            "18 hours" = 18,
                            "48 hours" = 48),
                       selected = c("4 hours", "18 hours", "48 hours")),
    br(),
    checkboxGroupInput("ind", "Individuals:",
                       list("M372" = "M372",
                            "M373" = "M373",
                            "M374" = "M374",
                            "M375" = "M375",
                            "M376" = "M376",
                            "M377" = "M377"),
                       selected = c("M372", "M373", "M374", "M375",
                                    "M376", "M377")),
    br(),
    textInput(inputId = "ensg", label = "Gene of interest",
              value = "ENSG00000000419"),
    br(),
    sliderInput("rin", 
                "RIN:", 
                value = c(0, 10),
                min = 0, 
                max = 10)
  ),

  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("plot", height = "auto")
               ), 
      tabPanel("eQTL type", tableOutput("eqtl")), 
      tabPanel("Expression pattern", tableOutput("motifs")),
      tabPanel("DE stats", tableOutput("stats"))
    )
  )
))
