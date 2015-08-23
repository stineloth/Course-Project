library(data.table)
library(dplyr)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl,destfile="./Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
filesPath <- "./UCI HAR Dataset"

# Import metadata files
featureNames <- tbl_df(read.table(file.path(filesPath, "features.txt")))
activityLabels  <- tbl_df(read.table(file.path(filesPath, "activity_labels.txt")))

# Import subject files
subjectt <- tbl_df(read.table(file.path(filesPath, "train", "subject_train.txt")))
subjecttst  <- tbl_df(read.table(file.path(filesPath, "test" , "subject_test.txt" )))

# Import activity files
activityt <- tbl_df(read.table(file.path(filesPath, "train", "Y_train.txt")))
activitytst  <- tbl_df(read.table(file.path(filesPath, "test" , "Y_test.txt" )))

# Import data files.
featurest <- tbl_df(read.table(file.path(filesPath, "train", "X_train.txt" )))
featurestst  <- tbl_df(read.table(file.path(filesPath, "test" , "X_test.txt" )))

#Combine files
features <- rbind(featurest, featurestst)
subject <- rbind(subjectt, subjecttst)
activity <- rbind(activityt, activitytst)

colnames(features) <- t(featureNames[2])

colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)
#Obtain mean and standard deviation
statistics <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

requiredColumns <- c(statistics, 562, 563)
dim(completeData)
# Name activities
extractdata <- completeData[,requiredColumns]
dim(extractdata)

extractdata$Activity <- as.character(extractdata$Activity)
for (i in 1:6){
  extractdata$Activity[extractdata$Activity == i] <- as.character(activityLabels[i,2])
}

extractdata$Activity <- as.factor(extractdata$Activity)

# Label data with variable names
names(extractdata)

names(extractdata)<-gsub("Acc", "Accelerometer", names(extractdata))
names(extractdata)<-gsub("Gyro", "Gyroscope", names(extractdata))
names(extractdata)<-gsub("BodyBody", "Body", names(extractdata))
names(extractdata)<-gsub("Mag", "Magnitude", names(extractdata))
names(extractdata)<-gsub("^t", "Time", names(extractdata))
names(extractdata)<-gsub("^f", "Frequency", names(extractdata))
names(extractdata)<-gsub("tBody", "TimeBody", names(extractdata))
names(extractdata)<-gsub("-mean()", "Mean", names(extractdata))
names(extractdata)<-gsub("-std()", "STD", names(extractdata))
names(extractdata)<-gsub("-freq()", "Frequency", names(extractdata))
names(extractdata)<-gsub("angle", "Angle", names(extractdata))
names(extractdata)<-gsub("gravity", "Gravity", names(extractdata))

names(extractdata)
# Write data to text file
extractdata$Subject <- as.factor(extractdata$Subject)
extractdata <- data.table(extractdata)

write.table(extractdata, "TidyDataFile.txt", row.name=FALSE)
