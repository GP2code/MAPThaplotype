#     _____       _     _                 _          __                        _       _       
#    / ____|     | |   | |               | |        / _|                      | |     | |      
#   | (___  _   _| |__ | |__   __ _ _ __ | | ___   | |_ _ __ ___  __ _   _ __ | | ___ | |_ ___ 
#    \___ \| | | | '_ \| '_ \ / _` | '_ \| |/ _ \  |  _| '__/ _ \/ _` | | '_ \| |/ _ \| __/ __|
#    ____) | |_| | |_) | | | | (_| | |_) | | (_) | | | | | |  __| (_| | | |_) | | (_) | |_\__ \
#   |_____/ \__,_|_.__/|_| |_|\__,_| .__/|_|\___/  |_| |_|  \___|\__, | | .__/|_|\___/ \__|___/
#                                  | |                              | | | |                    
#                                  |_|                              |_| |_|                    


#Version: R version 4.3.0

#Last Updated:JUNE-2025
## GP2 NBA data release 7


#Script overview: Visualizes the distribution of MAPT H1/H2 subhaplotype frequencies across multiple populations in PD cases and controls. It merges data from the LARGE-PD and GP2 datasets, reshapes and cleans the data, collapses rare subhaplotypes (<1% frequency), and generates a stacked bar plot of subhaplotype frequencies. 

#### Load Required Libraries ----

library(ggplot2)
library(dplyr)
library(tidyr)


#### Set Working Directory ----

setwd("your/path/here/")  # <- Replace with your actual working directory


#### Load and Clean LARGE Dataset ----

large <- read.csv("subhaplos_large/LARGE_March25.csv", sep = ",", header = TRUE)

# Rename columns to include dataset prefix
colnames(large)[colnames(large) == "p.val"]      <- "LARGE.p.val"
colnames(large)[colnames(large) == "pool.hf"]    <- "LARGE.pool.hf"
colnames(large)[colnames(large) == "control.hf"] <- "LARGE.control.hf"
colnames(large)[colnames(large) == "case.hf"]    <- "LARGE.case.hf"
colnames(large)[colnames(large) == "glm.eff"]    <- "LARGE.glm.eff"
colnames(large)[colnames(large) == "OR.lower"]   <- "LARGE.OR.lower"
colnames(large)[colnames(large) == "OR"]         <- "LARGE.OR"
colnames(large)[colnames(large) == "OR.upper"]   <- "LARGE.OR.upper"


#### Merge Haplotype Names and GP2 Data ----

names <- read.csv("subhaplos_large/subhaplos.csv", sep = ",", header = TRUE)
full_LARGE <- merge(large, names, by = "Alleles")
colnames(full_LARGE)[colnames(full_LARGE) == "Haplotype"] <- "Subhaplotype"

data_GP2 <- read.csv("data/subhaplo_march25.csv")
complete_dataset <- merge(full_LARGE, data_GP2, by = "Subhaplotype", all = TRUE)

# Save merged dataset
write.csv(complete_dataset, "LARGE_GP2_march25_25.csv", row.names = FALSE)


#### Load Complete Dataset for Plotting ----

data_all <- read.csv("data/LARGE_GP2_march25.csv")


#### Transform Data to Long Format ----

data_all_long <- data_all %>%
  pivot_longer(
    cols = -Subhaplotype,
    names_to = c("Population", "Status"),
    names_pattern = "(.*)\\.(.*)\\.hf"
  ) %>%
  mutate(POP = paste(Population, Status, sep = "-")) %>%
  rename(Freq = value) %>%
  dplyr::select(Subhaplotype, POP, Freq)

# Replace NA frequencies with 0
data_all_long$Freq[is.na(data_all_long$Freq)] <- 0

# Standardize population labels
data_all_long$POP[data_all_long$POP == "LARGE-PD"] <- "LARGE-PD-PD"
data_all_long$POP[data_all_long$POP == "LARGE-control"] <- "LARGE-PD-control"


#### Set Population Plot Order ----

pop_order <- c("LARGE-PD-control", "LARGE-PD-PD",
               "CAH-control", "CAH-PD",
               "EAS-control", "EAS-PD",
               "CAS-control", "CAS-PD",
               "SAS-control", "SAS-PD",
               "MDE-control", "MDE-PD",
               "AJ-control", "AJ-PD",
               "EUR-control", "EUR-PD",
               "AMR-control", "AMR-PD",
               "AAC-control", "AAC-PD",
               "AFR-control", "AFR-PD")

data_all_long$POP <- factor(data_all_long$POP, levels = pop_order)


#### Group and Collapse Rare Subhaplotypes (<1%) ----

filtered_alleles_1 <- data_all_long %>%
  group_by(Subhaplotype) %>%
  summarize(All_Low_Freq_1 = all(Freq < 0.01)) %>%
  filter(All_Low_Freq_1) %>%
  pull(Subhaplotype)

data_all_long_1 <- data_all_long %>%
  mutate(Subhaplotype = ifelse(Subhaplotype %in% filtered_alleles_1, "Others", Subhaplotype))


#### Set Subhaplotype Plot Order ----

custom_order <- c("A(H2a)", "B(H1b)", "E(H1e)", "C(H1c)", "H", "D(H1d)", "I", "O", "L", 
                  "M", "R", "G", "J", "U", "P", "N", "V", "Z*", "T", "Y*", "X", "F", 
                  "W", "K", "US1", "US2", "Q", "US3", "US4", "US5", "US6", "US7", "US8", "Others")

data_all_long_1$Label <- factor(data_all_long_1$Subhaplotype, levels = custom_order)


#### Plot Stacked Bar Chart ----

subhaplos_1 <- ggplot(data_all_long_1, aes(x = Freq, y = POP, fill = Label)) +
  geom_col(position = "fill") +
  scale_x_continuous(labels = scales::percent_format(scale = 100)) +
  labs(title = "Frequency of the H1/H2 subhaplotypes (MAF > 1% in all populations)",
       x = "Frequency",
       y = "Population") +
  theme_minimal(base_size = 18) +
  theme(axis.text.y = element_text(angle = 0, hjust = 0, size = 16)) +
  scale_fill_manual(values = c("#b30000", "#7c1158", "#4421af", "#1a53ff", "#0d88e6", 
                               "#00b7c7", "#5ad45a", "#8be04e", "#7fcdbb", "#fd7f6f", 
                               "#7eb0d5", "#b2e061", "#bd7ebe", "#ffb55a", "#ffee65", 
                               "#beb9db", "#fdcce5", "#8bd3c7", "#ea5545", "#f46a9b", 
                               "#ef9b20", "#edbf33", "#fff7bc", "#bdcf32", "#87bc45", 
                               "#27aeef", "#b33dc6", "#e7298a", "#525252"))

subhaplos_1


##Save figure
ggsave("subhaplos_1_plot.png", plot = subhaplos_1, width = 12, height = 8, dpi = 300)
