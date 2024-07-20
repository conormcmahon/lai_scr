

# Load required libraries
library(tidyverse)
library(here)

# Load dataset from LP-80 ceptometer
lai <- read_csv(here::here("lp_80_backyard_summary.csv"))

# Summary data across plant types
plant_type_lai <- lai %>% 
  filter(site != "MARCAL800") %>% 
  group_by(plant_type, hour) %>% 
  summarize(lai = mean(lai), 
            solar_noon_diff = mean(solar_noon_diff))

# Generate some summary plots
lai_diurnal_plot <- ggplot() + 
  geom_line(data=lai %>% filter(site != "MARCAL800"),
            aes(x=-solar_noon_diff, y=lai, 
                group=site, col=plant_type), 
            size=0.5, alpha=0.2) +
  geom_line(data=plant_type_lai,
            aes(x=-solar_noon_diff, y=lai, 
                group=plant_type, col=plant_type), 
            size=0.75, alpha=1) + 
  geom_point(data=plant_type_lai,
             aes(x=-solar_noon_diff, y=lai, 
                 group=plant_type, col=plant_type), size=2) + 
  geom_vline(xintercept=-2, col="black", linetype="dashed") + 
  geom_vline(xintercept=2, col="black", linetype="dashed") + 
  scale_y_continuous(limits=c(0,12), expand=c(0,0)) +
  scale_x_continuous(limits=c(-5,5), expand=c(0,0)) + 
  scale_color_discrete(name = "Plant Type") + 
  xlab("Time Relative to Solar Noon (hours)") + 
  ylab("Leaf Area Index (m^2 / m^2)") + 
  ggtitle("Diurnal Stability of LP-80 Ceptometer Measurements") + 
  theme_bw()
lai_diurnal_plot
# Save output plot 
ggsave(here::here("lai_diurnal_change.png"), lai_diurnal_plot, height=3, width=5)