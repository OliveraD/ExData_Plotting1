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

#Construct the third plot
plot(data$Timestamp, as.numeric(data$Sub_metering_1), 
     xlab = "",
     ylab = "Energy sub metering", 
     type = "l")
lines(data$Timestamp, as.numeric(data$Sub_metering_2), type = "l", col = "red")
lines(data$Timestamp, as.numeric(data$Sub_metering_3), type = "l", col = "blue")
legend("topright", lty = c(1,1,1), cex = 0.8, 
       legend = c("1_Sub_metering", "2_Sub_metering", "3_Sub_metering"),
       col = c("black", "red", "blue"), text.col = c("black", "red", "blue"))

#save the plot to a PNG file with a width of 480 pixels and a height of 480 pixels, and close the PNG device
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()


