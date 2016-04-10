## Script to create plot1.png: a histogram showing two days worth of data on
## global active power from an individual household
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


## Plot global active power as a function of time
print('Plotting')
png('plot2.png')
with(subset, plot(Time, Global_active_power, type = 'l',
                 xlab = '',
                 ylab = "Global Active Power (kilowatts)"))
dev.off()
print("Success, graph saved as 'plot2.png'")
