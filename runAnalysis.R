##########################################################################################################

# Dr. Melissa M. Sovak

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################
library(reshape2)
#Begin by setting working directory

setwd("/Users/lt_sovak/Dropbox/Coursera/Data Science Specialization/DS Course 3")

# Load activity labels and features
activityLabels <- read.table("./data/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("./data/features.txt")
features[,2] <- as.character(features[,2])

# Extract data on mean and standard deviation only and tidy the names
mean_sd_only <- grep(".*mean.*|.*std.*", features[,2])
mean_sd_only.names <- features[mean_sd_only,2]
mean_sd_only.names = gsub('-mean', 'Mean', mean_sd_only.names)
mean_sd_only.names = gsub('-std', 'Std', mean_sd_only.names)
mean_sd_only.names <- gsub('[-()]', '', mean_sd_only.names)

# Load the training and test datasets
train <- read.table("./data/train/X_train.txt")[mean_sd_only]
trainActivities <- read.table("./data/train/Y_train.txt")
trainSubjects <- read.table("./data/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("./data/test/X_test.txt")[mean_sd_only]
testActivities <- read.table("./data/test/Y_test.txt")
testSubjects <- read.table("./data/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# Merge the datasets and add column labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", mean_sd_only.names)

# Turn activities and subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allDataMelted <- melt(allData, id = c("subject", "activity"))
allDataMean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allDataMean, "./data/tidy.txt", row.names = FALSE, quote = FALSE)