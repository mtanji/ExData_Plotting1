install.packages("lubridate")
library(lubridate)

# Use English locale
mylocale<-Sys.getlocale()
mylocale<-strsplit(mylocale, split = ";")
lctime<-mylocale[[1]][grepl("LC_TIME", mylocale[[1]])]
mylctime<-substr(lctime, gregexpr("=", lctime)[[1]][1] + 1, nchar(lctime))
Sys.setlocale("LC_TIME", "English")

# process data
unzip("household_power_consumption.zip")
hpc<-read.table("household_power_consumption.txt", sep=";", header = T, dec = ".",  colClasses = c("character", "character", "character", "character", "character", "character", "character", "character", "character"))
hpc$Date2<-as.Date(hpc$Date, format = "%d/%m/%Y")
hpc2<-hpc[month(hpc$Date2) ==2 & year(hpc$Date2) == 2007 & (day(hpc$Date2) == 1 | day(hpc$Date2) == 2),]
hpc2[hpc2$Global_active_power=="?",c("Global_active_power","Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")]<-NA
hpc2$Time2<-strptime(paste(hpc2$Date, hpc2$Time), "%d/%m/%Y %H:%M:%S")

# set PNG device
png(file = "plot3.png", bg = "transparent", width = 480, height = 480)

# plot lines
plot(hpc2$Time2, hpc2$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(hpc2$Time2, hpc2$Sub_metering_2, col = "red")
lines(hpc2$Time2, hpc2$Sub_metering_3, col = "blue")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = c(1,1), col = c("black", "red", "blue"))

# export to PNG device
dev.off()

# Revert locale
Sys.setlocale("LC_TIME", mylctime)