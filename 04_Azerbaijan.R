# Oil Price Volatility and Azerbaijan's Fiscal Exposure
# Session 4: how exposed is Azerbaijan?

library(tidyverse)
library(WDI)
# Oil rents as a share of GDP, Azerbaijan vs. comparison countries
oil_rents <- WDI(
  country = c("AZ", "NO", "KZ", "SA", "RU"),
  indicator = "NY.GDP.PETR.RT.ZS",
  start = 2000, end = 2023
)

head(oil_rents)
# Clean up and plot
oil_rents_clean <- oil_rents %>%
  filter(!is.na(NY.GDP.PETR.RT.ZS)) %>%
  rename(oil_rents_pct = NY.GDP.PETR.RT.ZS)

ggplot(oil_rents_clean, aes(x = year, y = oil_rents_pct, color = country)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Oil rents as a share of GDP, 2000-2021",
    subtitle = "Azerbaijan's exposure exceeds Russia's and rivals Saudi Arabia's",
    x = "Year", y = "Oil rents (% of GDP)",
    color = "Country",
    caption = "Source: World Bank WDI (NY.GDP.PETR.RT.ZS)"
  ) +
  theme_minimal()

ggsave("oil_rents_comparison.png", width = 9, height = 5, dpi = 300)
# Average exposure by country
oil_rents_clean %>%
  group_by(country) %>%
  summarise(
    mean_rents = mean(oil_rents_pct),
    max_rents  = max(oil_rents_pct),
    min_rents  = min(oil_rents_pct)
  ) %>%
  arrange(desc(mean_rents))
# What does a 23% price error mean in GDP terms?
# Azerbaijan's mean oil rents: 25.1% of GDP
# Our out-of-sample MAPE: 22.97%

mean_rents <- 25.1
mape       <- 22.97

gdp_exposure <- mean_rents * (mape / 100)
gdp_exposure
