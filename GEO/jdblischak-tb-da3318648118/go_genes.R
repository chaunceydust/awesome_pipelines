# Finding example genes in a given GO category that are in a specific pattern.
# This code relies on the code in the file joint_analysis.Rmd. Specifically, I ran
# debug(go_analysis), and then ran the code below to find the genes I cite
# in the paper.

# Also see joint_analysis.Rmd, where I used a different strategy to avoid having
# to run all the Cormotif and topGO analyses.

table_s3 <- read.table("../data/table-s3.txt", header = TRUE, sep = "\t",
                       stringsAsFactors = FALSE)

table_s3[table_s3$full_time_course == "18 & 48 h" &
         #table_s3$time_48h == "Yers-Salm" &
         grepl("TLR", table_s3$name), ]

go_table[, c("GO.ID", "Term", "Annotated", "Significant")]
go_id <- "GO:0008630"
go_genes <- genesInTerm(go_data, go_id)[[1]]
head(go_genes)
length(go_genes)
motif_genes <- names(motif)[motif == m]
length(motif_genes)
length(intersect(go_genes, motif_genes))
targets <- intersect(go_genes, motif_genes)

# The code below is not run in order. The line that needs to be run is the one 
# corresponding to the go_id set above and which motif (m) is currently being
# analyzed.

# All
interferon_2 <- table_s3[table_s3$id %in% targets, ] # GO:0060337
cytokine_2 <- table_s3[table_s3$id %in% targets, ] # GO:0002739
apop_3 <- table_s3[table_s3$id %in% targets, ] # GO:2000109
apop_4 <- table_s3[table_s3$id %in% targets, ] # GO:0008630

# 18 & 48 h
phago <- table_s3[table_s3$id %in% targets, ] # GO:0050766
cytokine <- table_s3[table_s3$id %in% targets, ] # GO:0050710
apop_2 <- table_s3[table_s3$id %in% targets, ] # GO:2001237 (found PYCARD in phago)
nfkb <- table_s3[table_s3$id %in% targets, ] # GO:0051092
tlr2 <- table_s3[table_s3$id %in% targets, ] # GO:0034134
table_s3[table_s3$full_time_course == "18 & 48 h" &
         grepl("TLR", table_s3$name), ]

# 48 h
phago_48h <- table_s3[table_s3$id %in% targets, ] # GO:0006910
tnf <- table_s3[table_s3$id %in% targets, ] # GO:0033209

# 18 h
apo_18h <- table_s3[table_s3$id %in% targets, ] # GO:0072332

# Yers-Salm
interferon <- table_s3[table_s3$id %in% targets, ] # GO:0060337
antigen <- table_s3[table_s3$id %in% targets, ] # GO:0002480
antigen_2 <- table_s3[table_s3$id %in% targets, ] # GO:0002479
apoptosis <- table_s3[table_s3$id %in% targets, ] # GO:0042771
apoptosis_2 <- table_s3[table_s3$id %in% targets, ] # GO:2001239
