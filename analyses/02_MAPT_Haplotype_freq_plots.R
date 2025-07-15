
#    _    _             _       _                       __                        _       _       
#   | |  | |           | |     | |                     / _|                      | |     | |      
#   | |__| | __ _ _ __ | | ___ | |_ _   _ _ __   ___  | |_ _ __ ___  __ _   _ __ | | ___ | |_ ___ 
#   |  __  |/ _` | '_ \| |/ _ \| __| | | | '_ \ / _ \ |  _| '__/ _ \/ _` | | '_ \| |/ _ \| __/ __|
#   | |  | | (_| | |_) | | (_) | |_| |_| | |_) |  __/ | | | | |  __| (_| | | |_) | | (_) | |_\__ \
#   |_|  |_|\__,_| .__/|_|\___/ \__|\__, | .__/ \___| |_| |_|  \___|\__, | | .__/|_|\___/ \__|___/
#                | |                 __/ | |                           | | | |                    
#                |_|                |___/|_|                           |_| |_|                    

#Version: R version 4.3.0

#Last Updated:JUNE-2025
## GP2 NBA data release 7


#Script overview: This script plots the distribution of MAPT H1/H2 haplotype frequencies in PD cases and controls across multiple populations. It combines frequency data with power analysis results, reshapes and standardizes the data, and generates facet-wrapped stacked bar plots using ggplot2. Power values are overlaid for each population panel, and the final annotated figure is saved as a high-resolution image.



#### Load Required Libraries ----

library(tidyr)
library(ggplot2)
library(dplyr)
library(scales)


#### Set Working Directory ----
## Replace with your actual project directory
WORK_DIR <- "YOUR/WORKING/DIRECTORY/PATH"
setwd(WORK_DIR)


#### Load Input Data ----
## Load haplotype frequencies and power analysis results
df_cases_LARGE     <- read.csv("pdcases_LARGEPD_freq_release7.csv", row.names = 1)
df_controls_LARGE  <- read.csv("controls_largepd_freq_release7.csv", row.names = 1)
power_data         <- read.csv("power_values_MAPT.csv", stringsAsFactors = FALSE)


#### Reshape Data for Plotting ----

# Transpose data (optional, currently unused)
df_t_cases    <- t(df_cases_LARGE) %>% as.data.frame()
df_t_controls <- t(df_controls_LARGE) %>% as.data.frame()

# Convert wide to long format
df_long_cases    <- gather(df_cases_LARGE, key = "Population", value = "Frequency", AJ:LARGE.PD)
df_long_controls <- gather(df_controls_LARGE, key = "Population", value = "Frequency", AJ:LARGE.PD)

# Add Haplotype and Status labels
df_long_cases$Haplotype    <- rownames(df_cases_LARGE)
df_long_controls$Haplotype <- rownames(df_controls_LARGE)

df_long_cases$Type    <- "PD"
df_long_controls$Type <- "Control"

# Combine cases and controls
df_combined <- rbind(df_long_cases, df_long_controls) %>% as.data.frame()


#### Standardize Labels ----

# Fix inconsistent haplotype label
df_combined$Haplotype <- gsub("H2/H2\\(GG \\)", "H2/H2(GG)", df_combined$Haplotype)

# Replace population name
df_combined$Population[df_combined$Population == "LARGE.PD"] <- "LARGE-PD"


#### Set Factor Levels ----

# Define consistent population order
ordered_levels <- c("AFR", "AAC", "AMR", "EUR", "AJ", "MDE", "CAS", "SAS", "EAS", "CAH", "LARGE-PD")

df_combined$Population <- factor(df_combined$Population, levels = ordered_levels)
power_data$Population   <- factor(power_data$Population, levels = ordered_levels)


#### Define Plotting Aesthetics ----

# Custom color palette
my_palette <- c("#66c2a5", "#fc8d62", "#8da0cb")  # Extend or customize as needed


#### Create Base Plot ----

combined_plots <- ggplot(df_combined, aes(fill = Haplotype, y = Frequency, x = Type)) +
  geom_bar(position = "fill", stat = "identity") +
  scale_y_continuous(labels = percent_format(scale = 100)) +
  labs(
    title = "Frequency of the MAPT Haplotypes in all individuals",
    x = "Status", y = "Frequency", fill = "Haplotype", size = 18
  ) +
  facet_grid(~Population, scales = "free_x") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, size = 12),
    panel.background = element_rect(fill = "transparent")
  ) +
  scale_fill_manual(values = my_palette)

# Display base plot
combined_plots


#### Create Ordered Plot ----

combined_plots_ORDER <- ggplot(df_combined, aes(fill = Haplotype, y = Frequency, x = Type)) +
  geom_bar(position = "fill", stat = "identity") +
  scale_y_continuous(labels = percent_format(scale = 100)) +
  labs(
    title = "Frequency of the MAPT Haplotypes in all individuals",
    x = "Status", y = "Frequency", fill = "Haplotype", size = 18
  ) +
  facet_grid(~Population, scales = "free_x") +
  theme_minimal(base_size = 18) +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, size = 18),
    panel.background = element_rect(fill = "transparent")
  ) +
  scale_fill_manual(values = my_palette)

# Display ordered plot
combined_plots_ORDER


#### Overlay Power Values ----

# Define vertical placement for text
power_data$y_pos <- 1.02

combined_plots_ORDER_2 <- combined_plots_ORDER +
  geom_text(
    data = power_data,
    aes(x = 1.5, y = y_pos, label = Power),
    inherit.aes = FALSE,
    size = 4,
    color = "red"
  ) +
  theme(strip.text = element_text(size = 14))

# Show final annotated plot
combined_plots_ORDER_2


#### Save Output Plot ----

# Save final annotated plot (modify filename/path as needed)
ggsave("combined_plots_ORDER.png", combined_plots_ORDER_2, width = 12, height = 6)



