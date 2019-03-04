install.packages("coinmarketcapr")
library(coinmarketcapr)
plot_top_5_currencies()

install.packages("jsonlite")
library(jsonlite)
dataset.btc <- fromJSON("https://min-api.cryptocompare.com/data/histoday?fsym=BTC&tsym=USD&limit=2000&aggregate=1&e=CCCAGG")
# head is the old data and tail the new data
tail(dataset.btc$Data)
head(dataset.btc$Data)    

library(dplyr)
install.packages("lubridate")
library(lubridate)

data.frame(dataset.btc$Data) %>% mutate(date=as.POSIXct(time, origin="1970-01-01"),week=lubridate::week(ymd(as.Date(as.POSIXct(time, origin="1970-01-01")))),avg_price=((close+high+low+open)/4),year=lubridate::year(ymd(as.Date(as.POSIXct(time, origin="1970-01-01")))))->dataset.btc.expanded

library(ggplot2)

ggplot(dataset.btc.expanded,aes(as.Date(date)))+geom_line(aes(y=as.numeric(avg_price)))+xlab("Date")+ylab("Average Price BTC/USD")

btc.price<-ts(as.numeric(dataset.btc.expanded$avg_price),start = c(year(as.Date(dataset.btc.expanded$date[1])),month(as.Date(dataset.btc.expanded$date[1])),day(as.Date(dataset.btc.expanded$date[1]))),frequency =365 )

#btc.price2<-ts(as.numeric(dataset.btc.expanded$avg_price),start = c(2011, 11, 1), end = c(2018, 4, 24), frequency =365 )

btc.price2<-ts(as.numeric(dataset.btc.expanded$avg_price), start = c(2012, 306), frequency =365.25 )

# subset the time series (1st Nov 2012 to 31st Jan 2014)
btc.price3 <- window(btc.price2, start=c(2012, 306), end=c(2014, 31)) 


plot(btc.price2)

plot(btc.price3)

fit <- stl(btc.price2, s.window="period")
plot(fit)

# additional plots
monthplot(btc.price2)
library(forecast)
seasonplot(btc.price2)


# simple exponential - models level
fit <- holt(btc.price2, beta=FALSE, gamma=FALSE)
accuracy(fit)


# double exponential - models level and trend
fit1 <- HoltWinters(btc.price2, gamma=FALSE)
accuracy(fit1)


# triple exponential - models level, trend, and seasonal components
fit2 <- HoltWinters(btc.price2)



# predictive accuracy
library(forecast)
accuracy(fit)

# predict next three future values
library(forecast)
forecast(fit, 3)
plot(forecast(fit, 3))


#lag(ts, k)	lagged version of time series, shifted back k observations
#diff(ts, differences=d)	difference the time series d times
#ndiffs(ts)	Number of differences required to achieve stationarity (from the forecast package)
#acf(ts)	autocorrelation function
#pacf(ts)	partial autocorrelation function
#adf.test(ts)	Augemented Dickey-Fuller test. Rejecting the null hypothesis suggests that a time series is stationary (from the tseries package)
#Box.test(x, type="Ljung-Box")	Pormanteau test that observations in vector or time series x are independent

View(btc.price2)

btc.price10 <- lag(btc.price2, 2)

View(btc.price10)
btc11 <- diff(btc.price2, differences = 1)
ndiffs(btc.price2)
acf(btc.price2)
pacf(btc.price2)

#Augmented Dicket Fuller Test
library(tseries)
adf.test(btc.price2)

Acf(btc.price2)
Pacf(btc.price2)


#ARIMA Fitting

# fit an ARIMA model of order P, D, Q
fit <- Arima(btc.price2, order=c(1, 0, 2))
             
# predictive accuracy
library(forecast)
accuracy(fit)
             
# predict next 5 observations
library(forecast)
forecast(fit, 5)
plot(forecast(fit, 5))

#Automatic Model Fitting
library(forecast)
# Automated forecasting using an exponential model
fit20 <- ets(btc.price2)

# Automated forecasting using an ARIMA model
fit21 <- auto.arima(btc.price2)
forecast(fit21, 20)
summary(fit21)
plot(forecast(fit21))


#Fitting Neural Network
install.packages("caret")
library(caret)
fit <- nnetar(btc.price2)
plot(forecast(fit,h=60))
#points(1:length(btc.price2),fitted(fit),type="l",col="green")



#Fuzzy Time-Series

install.packages("AnalyzeTS")

library(AnalyzeTS)

#Changing format to TS

btc.price<-ts(as.numeric(dataset.btc.expanded$avg_price),start = c(year(as.Date(dataset.btc.expanded$date[1])),month(as.Date(dataset.btc.expanded$date[1])),day(as.Date(dataset.btc.expanded$date[1]))),frequency =365 )

View(btc.price)

# Finding the best C value by DOC function

# Abbasov-Mamedova model

str.C1<-DOC(btc.price,n=7,w=7,D1=0,D2=0,CEF="MAPE",type="Abbasov-Mamedova")

C1<-as.numeric(str.C1[1])

fuzzy.ts2(btc.price,n=7,w=7,D1=0,D2=0,C=C1,forecast=5,type="Abbasov-Mamedova",trace=TRUE,plot=TRUE)