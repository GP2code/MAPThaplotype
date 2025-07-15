
#    _                            ______                       _____  _       _       
#   | |                          |___  /                      |  __ \| |     | |      
#   | |     ___   ___ _   _ ___     / / ___   ___  _ __ ___   | |__) | | ___ | |_ ___ 
#   | |    / _ \ / __| | | / __|   / / / _ \ / _ \| '_ ` _ \  |  ___/| |/ _ \| __/ __|
#   | |___| (_) | (__| |_| \__ \  / /_| (_) | (_) | | | | | | | |    | | (_) | |_\__ \
#   |______\___/ \___|\__,_|___/ /_____\___/ \___/|_| |_| |_| |_|    |_|\___/ \__|___/
#                                                                                     
#                                                                                     

#Version: R version 4.3.0

#Last Updated:JAN-2025
## GP2 NBA data release 7


#Script overview: This script generates locus zoom regional association plots for the MAPT locus (chr17:45.8–46.2 Mb) using association results from the LARGE-PD and GP2 datasets. Using the topr package, it reads per-population summary statistics, filters relevant SNPs, and visualizes -log10(p-values) across the region. Two multi-panel plots are created: one including all populations and one excluding Europeans, with visual annotations for rs1052553 and genome-wide significance.

#### Set Working Directory ----

setwd("your/path/here/")  # <- Replace with your actual working directory


#  ┓ •┓       •   
#  ┃ ┓┣┓┏┓┏┓┏┓┓┏┓┏
#  ┗┛┗┗┛┛ ┗┻┛ ┗┗ ┛
library(topr)
library(tidyr)
library(dplyr)
library(ggplot2)

#  ┏┓•┓   
#  ┣ ┓┃┏┓┏
#  ┻ ┗┗┗ ┛

# List of populations
GP2_populations <- c("AAC", "AFR", "AMR", "AJ", "CAS", "EAS", "EUR", "MDE", "SAS", "LARGE", "CAH")

# Loop through each population
for (pop in GP2_populations) {
  # Construct the file path dynamically
  file_path <- paste0(pop, "_locus_17q.txt")
  
  # Read the CSV file
  df <- read.csv(file_path, sep="\t")
  
  # Rename the column
  df <- df %>% rename(CHROM = X.CHROM)
  
  # Remove rows with missing values in OR and P columns
  df <- df %>% filter(!is.na(OR) & !is.na(P))
  
  # Dynamically assign the dataframe to a variable named df_<POP>_GP2
  assign(paste0("df_", pop, "_GP2"), df)
}
                                           


  
  
  #  ┏┓┓    
  #  ┃┃┃┏┓╋┏
  #  ┣┛┗┗┛┗┛
  #         
  
# Regional plot focusing  on the MAPT gene

  ## All populations
  
All_MAPT <- regionplot(list( df_LARGE_GP2,
                             df_AAC_GP2, df_AFR_GP2, 
                             df_AJ_GP2, df_AMR_GP2,df_CAS_GP2,df_EAS_GP2,
                             df_EUR_GP2, df_MDE_GP2,df_SAS_GP2, df_CAH_GP2),
                       annotate_with_vline = 5e-08,
                       region="17:45794527-46228334",
                       rsids_with_vline = "rs1052553",
                       rsids = "rs1052553",
                       protein_coding_only = TRUE,
                       show_genes = FALSE,
                       show_gene_legend = FALSE,
                       legend_labels = c("LARGE-PD",
                                         "GP2 AAC", "GP2 AFR",
                                         "GP2 AJ", "GP2 AMR", "GP2 CAS","GP2 EAS",
                                         "GP2 EUR", "GP2 MDE", "GP2 SAS", "GP2 CAH"),
                       color = c( "darkgrey",
                                  "lightgoldenrod", "darkolivegreen",
                                  "cyan3","peru", "magenta4", "plum2",
                                  "cornflowerblue" ,"indianred","blue4", "plum4"),
                       title = "All",
                       size = 0.5,
                       alpha = 0.5,
                       max.overlaps = 20)

## All populations except EUR
All_notEUR_MAPT <- regionplot(list( df_LARGE_GP2,
                                    df_AAC_GP2, df_AFR_GP2, 
                                    df_AJ_GP2, df_AMR_GP2,df_CAS_GP2,df_EAS_GP2,
                                    df_MDE_GP2,df_SAS_GP2, df_CAH_GP2),
                              annotate_with_vline = 5e-08,
                              region="17:45794527-46228334",
                              rsids_with_vline = "rs1052553",
                              rsids = "rs1052553",
                              protein_coding_only = TRUE,
                              show_genes = FALSE,
                              show_gene_legend = FALSE,
                              legend_labels = c("LARGE-PD cohort","GP2 AAC", "GP2 AFR",
                                                "GP2 AJ", "GP2 AMR", "GP2 CAS","GP2 EAS",
                                                "GP2 MDE", "GP2 SAS cohort", "GP2 CAH"),
                              color = c( "darkgrey",
                                         "lightgoldenrod", "darkolivegreen",
                                         "cyan3","peru", "magenta4", "plum2",
                                         "indianred","blue4", "plum4"),
                              title = "All except EUR",
                              size = 0.7,
                              alpha = 0.7,
                              max.overlaps = 20)


