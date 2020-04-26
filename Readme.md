# Getting and Cleaning Data - Course Project

This is the Matias Roqueta's final course project for the Getting and Cleaning Data Coursera course.

The dataset used belongs to the `Human Activity Recognition Using Smartphones Dataset`. The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.

The R script `run_analysis.R` is meant to do the following:

1. Checks if the dataset already exists in the working directory.
2. If it does not exist, it downloads it.
3. Loads the activity and feature info.
4. Keeps only the measurments (variable names that reflect a mean or standard deviation).
5. Cleans feature names.
4. Loads the training and test datasets for activities, subjects and measurments. It merges them by binding rows and columns.
6. Converts the `activity_label` and `subject` columns into factors.
7. Creats a `tidy` dataset with the mean of each variable for each activity and subject. This dataset is shown in the file `tidy.txt`.
