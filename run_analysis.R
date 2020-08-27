##Load libraries, download files, and set working directory
library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "getdata_projectfiles_UCI HAR Dataset.zip")
unzip("~/Downloads/getdata_projectfiles_UCI HAR Dataset.zip")
setwd("~/Downloads/UCI HAR Dataset")

##Assigning DFs
features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./test/subject_test.txt", col.names = "subject")
x_test <- read.table("./test/X_test.txt", col.names = features$functions)
y_test <- read.table("./test/y_test.txt", col.names = "code")
subject_train <- read.table("./train/subject_train.txt", col.names = "subject")
x_train <- read.table("./train/X_train.txt", col.names = features$functions)
y_train <- read.table("./train/y_train.txt", col.names = "code")

##Merging Datasets
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
everything <- cbind(Subject, X, Y)

##Extracts mean and std for each measurement
means.devs <- select(everything, subject, code, contains("mean"), contains("std"))

##Describes activities in the dataset
means.devs$code <- activities[means.devs$code, 2]

##Labels measurements descriptively
names(means.devs)[2] = "activity"
names(means.devs)<-gsub("Acc", "Accelerometer", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("Gyro", "Gyroscope", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("BodyBody", "Body", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("Mag", "Magnitude", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("^t", "Time", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("^f", "Frequency", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("Frequencyrequency", "Frequency", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("Timeime", "Time", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("mean", "Mean", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("std", "STD", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("angle", "Angle", names(means.devs), ignore.case = TRUE)
names(means.devs)<-gsub("gravity", "Gravity", names(means.devs), ignore.case = TRUE)

##Creates dataset grouped by activity and subject
grouped.data <- means.devs %>% 
        group_by(subject, activity) %>%
        summarize(across(.fns = mean))

##Writes to CSV
write.csv(grouped.data, "CompletedProject.csv")