## Script to create plot4.png: a matrix with 4 line graphs showing (1) Total
## active power, (2) Voltage, and (3) Energy usage across submeters, and 
## (4) Total reactive power--all as functions of time
##
## Data source:
## “Individual household electric power consumption Data Set”
## Lichman, M. (2013). UCI Machine Learning Repository 
## [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, 
## School of Information and Computer Science. 
##
## Script created by Austin Dempewolff (adempewolf@gmail.com) as part of
## an assignment for Coursera "Exploratory Data Analysis" course.


## Download data if not found locally
if(!dir.exists('data')) {
     print('Creating data directory')
     dir.create('data')
}
path <- file.path('data','household_power_consumption.zip')
url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
if(!file.exists(path)) {
     print('Data not found locally, downloading...')
     download.file(url, path)
     print('Success')
} else print('Data found locally')
rm(url)


## Unzip data and read in data
print('Unzipping and reading in, this might take some time...')
data <- read.table(unz(path, 'household_power_consumption.txt'), sep = ';',
                   header = TRUE, na.strings = '?')
print('Success')
rm(path)


## Convert Time and Date to POSIXct and date classes
print('Converting dates and times, this might take some time...')
data <- transform(data, Time = as.POSIXct(strptime(paste(Date, Time), 
                                                  '%d/%m/%Y %H:%M:%S',
                                                  tz = 'UTC')))
data <- transform(data, Date = as.Date(Date, '%d/%m/%Y'))
print('Success')


## Filter out data from 2007-02-01 and 2007-02-02
print('Filtering data from specified dates')
index <- data$Date >= as.Date('2007-02-01') & data$Date <= as.Date('2007-02-02')
subset <- data[index,]
print('Success')


## Plot 4 graphs (described in opening comment)
print('Plotting')
png('plot4.png')

par(mfrow = c(2,2))

## Plot 1
with(subset, plot(Time, Global_active_power, type = 'l',
                  xlab = '',
                  ylab = "Global Active Power (kilowatts)"))
## Plot 2
with(subset, plot(Time, Voltage, type = 'l',
                  xlab = 'datetime',
                  ylab = "Voltage"))

## Plot 3
with(subset, plot(Time, Sub_metering_1, type = 'l', 
                  ylab = 'Energy sub metering',
                  xlab = ''))
with(subset, lines(Time, Sub_metering_2, col = 'red'))
with(subset, lines(Time, Sub_metering_3, col = 'blue'))
legend('topright', names(subset)[7:9], col = c('black', 'red', 'blue'), 
       lty = 1, bty = 'n')

## Plot 4
with(subset, plot(Time, Global_reactive_power, type = 'l',
                  xlab = 'datetime',
                  ylab = "Global_reactive_power"))

dev.off()
print("Success, graph saved as 'plot4.png'")
