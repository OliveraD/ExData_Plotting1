#Copy the url into the fileUrl, download zip file if it does not exist, and unzip it: 
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("data_raw.zip")) {
    download.file(fileUrl, "data_raw.zip")
}

unzip("data_raw.zip")

#Read the txt data
data_raw <- read.table("household_power_consumption.txt", sep = ";", header = TRUE,
                       colClasses = "character", na.strings = "?")
#Inspect the raw data
head(data_raw)
str(data_raw)
#convert the Date and Time variables to Date/Time class using the strptime() and subset the first 2 days from February
data_raw$Timestamp <- paste(data_raw$Date, data_raw$Time)
data_raw$Timestamp <- strptime(data_raw$Timestamp, "%d/%m/%Y %H:%M:%S")
start <- which(data_raw$Timestamp==strptime("2007-02-01", "%Y-%m-%d"))
finish <- which(data_raw$Timestamp==strptime("2007-02-02 23:59:00", "%Y-%m-%d %H:%M:%S"))
data<-data_raw[start:finish,]

#Inspect the subsetted data, and remove raw data
head(data)
table(data$Date)
class(data$Timestamp)
rm(data_raw)

#Construct the first plot
hist(as.numeric(data$Global_active_power), col = "red",
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

#save the plot to a PNG file with a width of 480 pixels and a height of 480 pixels, and close the PNG device
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()


