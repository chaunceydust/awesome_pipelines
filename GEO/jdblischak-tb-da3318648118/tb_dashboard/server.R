
library("shiny")
library("ggplot2")
library("RColorBrewer")

shinyServer(function(input, output) {
  
  # Input data
  gene <- read.table("../../data/fold-change.txt",
                     stringsAsFactors = FALSE, header = TRUE)
  gene$bact <- ordered(gene$bact, levels = c("Rv", "Rv+", "GC", "BCG",
                                             "Smeg", "Yers", "Salm", "Staph"))
  motifs <- read.table("../../data/table-s3.txt", header = TRUE,
                       sep = "\t", stringsAsFactors = FALSE)
  eqtl <- read.table("../../data/dc-expr-eqtl.txt", header = TRUE,
                     sep = "\t", stringsAsFactors = FALSE)
  stats <- read.table("../../data/de-stats.txt", header = TRUE,
                      stringsAsFactors = FALSE)
  stats$bact <- sub("plus", "+", stats$bact)

  # Colors for plot
  my_cols <- brewer.pal(n = 9, name = "Greens")
  my_cols <- c(rev(my_cols)[1:5], "purple", "blue", "orange")
  names(my_cols) <- levels(gene$bact)

  data <- reactive({
    gene[gene$bact %in% input$bact &
         gene$rin >= input$rin[1] &
         gene$rin <= input$rin[2] &
         gene$ind %in% input$ind &
         gene$time %in% input$time, ]
  })
  
  output$plot <- renderPlot({
    p <- ggplot(data(), aes_string(x = "bact", y = input$ensg, fill = "bact")) +
      geom_boxplot(lwd = 1) +
      geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
      labs(x = "Bacterial infection", y = "log2 fold change in expression") +
      facet_grid(time ~ .) +
      theme_bw(base_size = 18) +
      scale_fill_manual(values = my_cols[names(my_cols) %in% input$bact]) +
      theme(legend.position = "none")
    print(p)
  }, height = 700)
  
  # eQTL status in dendritic cells
  output$eqtl <- renderTable({
    eqtl[eqtl$id == input$ensg, c("id", "name", "eqtl_type")]
  })
  
  # Expression pattern identified by Cormotif
  output$motifs <- renderTable({
    motifs[motifs$id == input$ensg, ]
  })
  
  # Differential expression from limma
  output$stats <- renderTable({
    stats[stats$time %in% input$time & stats$bact %in% input$bact & 
          stats$gene == input$ensg,
          c("test", "logFC", "t", "adj.P.Val")]
  })
})
