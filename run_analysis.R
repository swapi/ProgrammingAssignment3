#!/usr/bin/env Rscript

library(reshape2)

run_analysis <- function() {
    # if input dataset does not exist then extract it from current directory
    if(!file.exists('dataset')) {
        unzip('getdata-projectfiles-UCI HAR Dataset.zip')
        file.rename('UCI HAR Dataset', 'dataset')
    }

    if(!file.exists('dataset/tidy/')) {
        dir.create('dataset/tidy/', recursive = T)
    }

    # extract only mean and std deviations for training data
    train_obs = read.csv('dataset/train/X_train.txt', header=F, sep="", colClasses=c("numeric"))
    train_obs = train_obs[,c(1, 2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 86, 121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166, 201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266, 267, 268, 269, 270, 271, 345, 346, 347, 348, 349, 350, 424, 425, 426, 427, 428, 429, 503, 504, 516, 517, 529, 530, 542, 543)]

    # extract only mean and std deviations for test data
    test_obs = read.csv('dataset/test/X_test.txt', header=F, sep="", colClasses=c("numeric"))
    test_obs = test_obs[,c(1, 2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 86, 121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166, 201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266, 267, 268, 269, 270, 271, 345, 346, 347, 348, 349, 350, 424, 425, 426, 427, 428, 429, 503, 504, 516, 517, 529, 530, 542, 543)]

    # merge data
    merged_obs = rbind(train_obs, test_obs)
    # give meaningfull name to observations
    names(merged_obs) = c('tBodyAcc-mean()-X', 'tBodyAcc-mean()-Y', 'tBodyAcc-mean()-Z', 'tBodyAcc-std()-X', 'tBodyAcc-std()-Y', 'tBodyAcc-std()-Z', 'tGravityAcc-mean()-X', 'tGravityAcc-mean()-Y', 'tGravityAcc-mean()-Z', 'tGravityAcc-std()-X', 'tGravityAcc-std()-Y', 'tGravityAcc-std()-Z', 'tBodyAccJerk-mean()-X', 'tBodyAccJerk-mean()-Y', 'tBodyAccJerk-mean()-Z', 'tBodyAccJerk-std()-X', 'tBodyAccJerk-std()-Y', 'tBodyAccJerk-std()-Z', 'tBodyGyro-mean()-X', 'tBodyGyro-mean()-Y', 'tBodyGyro-mean()-Z', 'tBodyGyro-std()-X', 'tBodyGyro-std()-Y', 'tBodyGyro-std()-Z', 'tBodyGyroJerk-mean()-X', 'tBodyGyroJerk-mean()-Y', 'tBodyGyroJerk-mean()-Z', 'tBodyGyroJerk-std()-X', 'tBodyGyroJerk-std()-Y', 'tBodyGyroJerk-std()-Z', 'tBodyAccMag-mean()', 'tBodyAccMag-std()', 'tGravityAccMag-mean()', 'tGravityAccMag-std()', 'tBodyAccJerkMag-mean()', 'tBodyAccJerkMag-std()', 'tBodyGyroMag-mean()', 'tBodyGyroMag-std()', 'tBodyGyroJerkMag-mean()', 'tBodyGyroJerkMag-std()', 'fBodyAcc-mean()-X', 'fBodyAcc-mean()-Y', 'fBodyAcc-mean()-Z', 'fBodyAcc-std()-X', 'fBodyAcc-std()-Y', 'fBodyAcc-std()-Z', 'fBodyAccJerk-mean()-X', 'fBodyAccJerk-mean()-Y', 'fBodyAccJerk-mean()-Z', 'fBodyAccJerk-std()-X', 'fBodyAccJerk-std()-Y', 'fBodyAccJerk-std()-Z', 'fBodyGyro-mean()-X', 'fBodyGyro-mean()-Y', 'fBodyGyro-mean()-Z', 'fBodyGyro-std()-X', 'fBodyGyro-std()-Y', 'fBodyGyro-std()-Z', 'fBodyAccMag-mean()', 'fBodyAccMag-std()', 'fBodyBodyAccJerkMag-mean()', 'fBodyBodyAccJerkMag-std()', 'fBodyBodyGyroMag-mean()', 'fBodyBodyGyroMag-std()', 'fBodyBodyGyroJerkMag-mean()', 'fBodyBodyGyroJerkMag-std()')
    # write merged data to new file in tidy dataset
    write.table(merged_obs, 'dataset/tidy/X_merged.txt', qu=F, row.names=F)

    # read activity lables
    act = read.csv('dataset/activity_labels.txt', header=F, sep="", colClasses=c("numeric", NA))
    act.mapper = function(x) { as.character(act[act$V1==x,]$V2) }

    # read and convert training activities
    train_act = read.csv('dataset/train/y_train.txt', header=F, sep="", colClasses=c("numeric"))
    train_act = sapply(train_act$V1, function(x) { as.character(act[act$V1==x,]$V2) })
    # read and convert test activities
    test_act = read.csv('dataset/test/y_test.txt', header=F, sep="", colClasses=c("numeric"))
    test_act = sapply(test_act$V1, function(x) { as.character(act[act$V1==x,]$V2) })

    # merge activity data
    merged_act = data.frame(activity=c(train_act, test_act))
    # write merged data to new file in tidy dataset
    write.table(merged_act, 'dataset/tidy/y_merged.txt', qu=F, row.names=F)

    train_sub = read.csv('dataset/train/subject_train.txt', header=F, sep="", colClasses=c("numeric"))
    test_sub = read.csv('dataset/test/subject_test.txt', header=F, sep="", colClasses=c("numeric"))
    # merge subject data
    merged_sub = rbind(train_sub, test_sub)
    names(merged_sub) = c('subject')
    write.table(merged_sub, 'dataset/tidy/subject_merged.txt', qu=F, row.names=F)

    merged = cbind(merged_obs, merged_act, merged_sub)

    # melt and dcast the dataset to find the mean per subject per activity
    melted = melt(merged, id.vars=c('subject', 'activity')) 
    result = dcast(melted, subject + activity ~ variable, mean)

    # write result dataset to file
    write.table(result, 'dataset/tidy/final_tidy.txt', qu=F, row.names=F)

    merged
}

r <- run_analysis()
str(r)
