# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject.

#Load reshape package
library(reshape2)

#Check if data was downloaded

files.check = c(
        "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt",
        "UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt",
        "UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt",
        "UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt",
        "UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt",
        "UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt",
        "UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt",
        "UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt",
        "UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt",
        "UCI HAR Dataset/test/X_test.txt",
        "UCI HAR Dataset/test/subject_test.txt",
        "UCI HAR Dataset/test/y_test.txt",
        "UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt",
        "UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt",
        "UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt",
        "UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt",
        "UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt",
        "UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt",
        "UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt",
        "UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt",
        "UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt",
        "UCI HAR Dataset/train/X_train.txt",
        "UCI HAR Dataset/train/subject_train.txt",
        "UCI HAR Dataset/train/y_train.txt",
        "UCI HAR Dataset/activity_labels.txt",
        "UCI HAR Dataset/features.txt"
)

files = list.files(pattern = ".txt",recursive = T)

#If any is missing, download all files
if (!all(files.check %in% files)){
        download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "dataset.zip")
        unzip(zipfile = "dataset.zip")
        files = list.files(pattern = ".txt",recursive = T)
        file.remove("dataset.zip")
}

#Load labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = F)
colnames(activity_labels) <- c("activity","activity_label")

features <- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = F)
colnames(features) <- c("index","names")

#Keep mean and std features

features <- subset(features,grepl(pattern = "-*mean*.|.*std*.", x = names, ignore.case = T))
features$names <- gsub(pattern = "-mean", replacement = "Mean",x = features$names)
features$names <- gsub(pattern = "-std", replacement = "Std",x = features$names)
features$names <- gsub(pattern = "[-()]|\\,", replacement = "",x = features$names)
features$names <- make.names(features$names)

#Load datasets

train_x <- read.table(file = "./UCI HAR Dataset/train/X_train.txt", dec = ".")[,features$index]
colnames(train_x) <- features$names

train_y <- read.table(file = "./UCI HAR Dataset/train/y_train.txt", dec = ".")
colnames(train_y) <- "activity"

train_subject <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt", dec = ".")
colnames(train_subject) <- "subject"

test_x <- read.table(file = "./UCI HAR Dataset/test/X_test.txt", dec = ".")[,features$index]
colnames(test_x) <- features$names

test_y <- read.table(file = "./UCI HAR Dataset/test/y_test.txt", dec = ".")
colnames(test_y) <- "activity"

test_subject <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt", dec = ".")
colnames(test_subject) <- "subject"

#Merge x and y

train <- cbind(train_subject, train_x, train_y)
test <- cbind(test_subject, test_x, test_y)

#Merge train and test

df <- rbind(train,test)

#Add activity labels and erase activity index
df <- merge(x = df, y = activity_labels, by = "activity")
df$activity <- NULL
df$activity_label <- as.factor(df$activity_label)
df$subject <- as.factor(df$subject)

rm(list = c("train_x","train_y","train_subject","train",
            "test_x","test_y","test_subject","test"))
gc()

#Make de complete dataset "tidy"
df_melt <- melt(df, id = c("subject", "activity_label"))
df_mean <- dcast(df_melt, subject + activity_label ~ variable, mean)

write.table(x = df_mean, file = "tidy.txt", row.names =F, quote = F)
