
# This is a quick-and-dirty approximate approach for estimating LAI from field data 
#   Uses:
#     values from LP-80 Ceptometer (in data file lai_data.csv)
#     values from EM20 PAR data logger (in data file par_downwelling_background.csv)

# Interpolates downwelling PAR values from datalogger to gap-fill in ceptometer
# Fits curve to estimate LAI values from ceptometer for cases where it wasn't computed in field
# Plots range of LAI values taken in field for both survey protocols

library(tidyverse)
library(here)

lai <- read_csv(here::here("lai_data.csv")) %>%
  #mutate(survey_type = c("physio_site", "grid")[1+grepl("GRD", lai$name)],
  mutate(day_frac = hour/24 + minute/60/24)

par_background <- read_csv(here::here("par_downwelling_background.csv"))

# Get background PAR for each ceptometer reading
getBackground <- function(lai, par, day_target)
{
  # Subset both datasets to the target day 
  lai_sub <- lai %>% filter(day == day_target)
  par_sub <- par %>% filter(day == day_target)
  # Fit linear interpolation from full-sky datalogger at timestamps from ceptometer
  lai_sub$logger_par <- approx(par_sub$day_frac, 
                               par_sub$par_avg, 
                               xout = lai_sub$day_frac)$y
  # Return result
  return(lai_sub)
}
# Interpolate for data logger downwelling PAR at each timestep
lai_background <- rbind(getBackground(lai, par_background, 16),
                        getBackground(lai, par_background, 17),
                        getBackground(lai, par_background, 18)) 

# Get a relationship between PAR estimates from the ceptometer (downwelling) and data logger
# The two sensors might give slightly different estimates (we see a fairly stable factor of ~ 0.98)
logger_ceptometer_comparison <- lm(data=lai_background %>% filter(PAR_a > 0), PAR_a~logger_par)
summary(logger_ceptometer_comparison)

# Apply the above correction to get ceptometer downwelling PAR based on interpolated data logger values
lai_background <- lai_background %>%
  mutate(PAR_a_logger = predict(logger_ceptometer_comparison,
                                newdata = lai_background)) %>%
  mutate(tau_logger = PAR_b / PAR_a_logger)
  
# Fit a relationship bewteen tau at the data logger and LAI 
linmod <- (lm(data=lai_background %>% filter(LAI > 0), LAI~as.factor(day)*log(tau_logger)))
summary(linmod)
# Estimate LAI based on that model
lai_background$lai_fit <- predict(linmod, newdata = lai_background)

# Plot overall range of LAI
ggplot(lai_background) + 
  geom_histogram(aes(x=lai_fit), binwidth = 1)

# Plot range of LAI values for grid points
ggplot(lai_background %>% filter(survey_type == "grid")) + 
  geom_histogram(aes(x=lai_fit), binwidth = 1)

# Plot range of LAI values for plant types 
ggplot(lai_background %>% filter(survey_type == "physio")) + 
  geom_boxplot(aes(x=plant, y=lai_fit))

# Output a summary plot of LAI by plant type and hydrology
lai_physio <- ggplot(lai_background %>% filter(survey_type == "physio")) + 
  geom_boxplot(aes(x=interaction(hydrology, plant), y=lai_fit, col=hydrology)) + 
  geom_signif(aes(x=interaction(hydrology, plant), y=lai_fit), 
              comparisons = list(c("dry.AruDon","wet.AruDon")), 
              map_signif_level=TRUE) + 
  geom_signif(aes(x=interaction(hydrology, plant), y=lai_fit), 
              comparisons = list(c("dry.BacSal","wet.BacSal")), 
              map_signif_level=TRUE) +
  geom_signif(aes(x=interaction(hydrology, plant), y=lai_fit), 
              comparisons = list(c("dry.SalLas","wet.SalLas")), 
              map_signif_level=TRUE) +
  theme_bw() + 
  scale_y_continuous(limits=c(0,10)) + 
  ylab("LAI")
lai_physio
ggsave(here::here("lai_physio.png"), lai_physio, width=5, height=3)

# Output a summary plot of LAI by plant type and hydrology
lai_physio_course <- ggplot(lai_background %>% filter(survey_type == "physio")) + 
  geom_boxplot(aes(x=plant, y=lai_fit)) + 
  geom_signif(aes(x=plant, y=lai_fit), 
              comparisons = list(c("AruDon","BacSal")), 
              map_signif_level=TRUE) + 
  geom_signif(aes(x=plant, y=lai_fit), 
              comparisons = list(c("BacSal","SalLas")), 
              map_signif_level=TRUE) +
  theme_bw() + 
  ylab("LAI")
lai_physio_course
ggsave(here::here("lai_physio_course.png"), lai_physio_course, width=5, height=3)

# Compare BacSal values by hydrology and location

# Output a summary plot of LAI by plant type and hydrology
lai_bacsal <- ggplot(lai_background %>% filter(survey_type == "physio", plant=="BacSal")) + 
  geom_boxplot(aes(x=interaction(hydrology, site), y=lai_fit, col=hydrology)) + 
#  geom_signif(aes(x=interaction(hydrology, site), y=lai_fit), 
#              comparisons = list(c("dry.Freeman Diversion","wet.Freeman Diversion")), 
#              map_signif_level=TRUE) + 
#  geom_signif(aes(x=interaction(hydrology, site), y=lai_fit), 
#              comparisons = list(c("dry.Lost Creek","wet.Lost Creek")), 
#              map_signif_level=TRUE) +
#  geom_signif(aes(x=interaction(hydrology, site), y=lai_fit), 
#              comparisons = list(c("dry.SalLas","wet.SalLas")), 
#              map_signif_level=TRUE) +
  theme_bw() + 
  scale_y_continuous(limits=c(0,8))
ylab("LAI")
lai_bacsal
ggsave(here::here("lai_bacsal.png"), lai_bacsal, width=5, height=3)


