setwd('/Users/jimstaisabel/Documents/R projects/GettingAndCleaningData-Coursera/UCI HAR Dataset')

# MERGE TRAINING AND TESTING DATA SETS
Xtrain <- read.table("train/X_train.txt")
Xtest <- read.table("test/X_test.txt")
X_data <- rbind(Xtrain, Xtest)

ytrain <- read.table("train/y_train.txt")
ytest <- read.table("test/y_test.txt")
Y_data <- rbind(ytrain, ytest)

subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")
Subject_data <- rbind(subject_train, subject_test)
names(Subject_data) <- "subject"


# EXTRACT MEAN AND STD

features <- read.table("features.txt")
View(features)

mean_std <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X_data <- X_data[, mean_std]
names(X_data) <- features[mean_std, 2]
View(X_data)


# RENAME COLUMNS
names(X_data) <- tolower(names(X_data))
names(X_data) <- gsub("\\(|\\)", "", names(X_data))


# NAMING ACTIVITIES
activity <- read.table("activity_labels.txt")
View(activity)

activity$V2 <- gsub("_", "", activity$V2)
activity$V2 <- tolower(activity$V2)
Y_data[, 1] <- activity[Y_data[, 1], 2]
names(Y_data) <- "activity"
View(Y_data)


# MERGING DATA
tidy_data_merged <- cbind(Subject_data, Y_data, X_data)
View(tidy_data_merged)
write.table(tidy_data_merged, "tidy_data_merged.txt")


# CALCULATE AVERAGES FOR EACH SUBJECT AND ACTIVITY 
library(dplyr)

tidy_data_averages <- tidy_data_merged %>%
    group_by(subject, activity) %>%
    summarise(across(where(is.numeric), mean), .groups = "drop")
View(tidy_data_averages)

write.table(tidy_data_averages, "tidy_data_averages.txt", row.names = FALSE)
