# Oil Price Volatility and Azerbaijan's Fiscal Exposure
# Session 3: ARIMA models and forecasting

library(quantmod)
library(forecast)
library(tseries)
library(tidyverse)

getSymbols("POILBREUSDM", src = "FRED")

oil <- ts(as.numeric(POILBREUSDM),
          start = c(1992, 1),
          frequency = 12)

train <- window(oil, end = c(2026, 2))
test  <- window(oil, start = c(2026, 3))
# Automatic model selection
fit_arima <- auto.arima(train)
summary(fit_arima)
# The naive benchmark: next month = this month
fit_naive <- naive(train, h = 5)
# Forecast six months ahead from February 2026
fc_arima <- forecast(fit_arima, h = 5)

# What does the model predict?
fc_arima

# Plot it against reality
autoplot(fc_arima) +
  autolayer(test, series = "Actual", size = 1) +
  coord_cartesian(xlim = c(2024, 2026.6), ylim = c(40, 130)) +
  labs(
    title = "ARIMA forecast vs. what actually happened",
    subtitle = "Model trained through February 2026; war began February 28",
    x = "Year", y = "USD per barrel"
  ) +
  theme_minimal()
# How wrong was each model?
accuracy(fc_arima, test)
accuracy(fit_naive, test)
ggsave("forecast_vs_actual.png", width = 9, height = 5, dpi = 300)
