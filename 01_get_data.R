# Oil Price Volatility and Azerbaijan's Fiscal Exposure
# Session 1: get and explore the data

library(quantmod)
library(forecast)
library(tseries)
library(tidyverse)

# Pull monthly Brent crude prices from FRED
getSymbols("POILBREUSDM", src = "FRED")

# Look at what came back
head(POILBREUSDM)
tail(POILBREUSDM)
# Convert to a proper time series object
oil <- ts(as.numeric(POILBREUSDM),
          start = c(1992, 1),
          frequency = 12)

# Plot the full history
autoplot(oil) +
  labs(
    title = "Brent Crude Oil Price, 1992-2026",
    subtitle = "Monthly average, US dollars per barrel",
    x = "Year",
    y = "USD per barrel",
    caption = "Source: IMF via FRED (POILBREUSDM)"
  ) +
  theme_minimal()
ggsave("brent_full_history.png", width = 9, height = 5, dpi = 300)

# Zoom in on the last decade
oil_recent <- window(oil, start = c(2014, 1))

autoplot(oil_recent) +
  labs(
    title = "Brent Crude, 2014-2026",
    subtitle = "The 2014-15 collapse triggered two manat devaluations in Azerbaijan",
    x = "Year", y = "USD per barrel"
  ) +
  theme_minimal()
# The 2026 shock: train/test split at February 2026
train <- window(oil, end = c(2026, 2))
test  <- window(oil, start = c(2026, 3))

length(train)  # months used to fit the model
test           # what actually happened after
