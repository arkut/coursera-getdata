# Coursera R class: Getting and Cleaning Data
# Course Project
# Creating tidy data set of Samsung wearable usage data
library(plyr)

# 0. Read in data
setwd("OneDrive/coursera/cleanData")
if(!file.exists("./data")){dir.create("./data")}

#general data
activity_labels <- read.table("./raw/UCI/activity_labels.txt")
features <- read.table("./raw/UCI/features.txt")

#training data
subject_train <- read.table("./raw/UCI/train/subject_train.txt")
x_train <- read.table("./raw/UCI/train/X_train.txt")
y_train <- read.table("./raw/UCI/train/y_train.txt")

#testing data
subject_test <- read.table("./raw/UCI/test/subject_test.txt")
x_test <- read.table("./raw/UCI/test/X_test.txt")
y_test <- read.table("./raw/UCI/test/y_test.txt")

# 1. Merge training and test sets
xset <- rbind(x_train, x_test)
yset <- rbind(y_train, y_test)
subj <- rbind(subject_train, subject_test)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
measure <- grep("-(mean|std)\\(\\)", features[, 2])
xset <- xset[, measure]

# 3. Use descriptive activity names to name the activities in the data set
names(xset) <- features[measure, 2]
yset[, 1] <- activity_labels[yset[, 1], 2]
names(yset) <- "activity"

# 4. Appropriately label the data set with descriptive variable names. 
names(subj) <- "subject"

full_file <- cbind(xset, yset, subj)

# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.
avg_data <- ddply(full_file, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(avg_data, "avg_data.txt", row.name=FALSE)
