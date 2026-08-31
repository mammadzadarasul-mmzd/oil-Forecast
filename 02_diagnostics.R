# Oil Price Volatility and Azerbaijan's Fiscal Exposure
# Session 2: decomposition and stationarity

library(quantmod)
library(forecast)
library(tseries)
library(tidyverse)

# Rebuild the data (self-contained script)
getSymbols("POILBREUSDM", src = "FRED")

oil <- ts(as.numeric(POILBREUSDM),
          start = c(1992, 1),
          frequency = 12)

train <- window(oil, end = c(2026, 2))
test  <- window(oil, start = c(2026, 3))
# Split the series into trend, seasonal, and remainder
decomp <- decompose(train)
autoplot(decomp)
# Is the series stationary?
adf.test(train)
# Difference the series: model changes, not levels
oil_diff <- diff(train)

autoplot(oil_diff) +
  labs(
    title = "Monthly change in Brent crude price",
    subtitle = "First difference of the price series",
    x = "Year", y = "Change in USD per barrel"
  ) +
  theme_minimal()

# Test again
adf.test(oil_diff)
# Correlation structure of the differenced series
ggAcf(oil_diff) + labs(title = "ACF: monthly price changes")
ggPacf(oil_diff) + labs(title = "PACF: monthly price changes")