Output Data
===========

This script combines training and test data and saves it in the `dataset/tidy` directory
Following are merged files for each of the test and training datasets:
```
1. subject_merged.txt - merge of subject_test.txt and subject_train.txt
2. X_merged.txt - merge of X_test.txt and X_train.txt for variable which are mean and std deviations
3. y_merged.txt - merge of y_test.txt and y_train.txt with actual activity names
```
Apart from generating merged files, tidy dataset containing average of each variable 
for each activity and each subject is also generaed in file `dataset/tidy/final_tidy.txt`.

Following are variables in the tidy dataset:
```
1. Subject - Subject id
2. Activity - Name of activity
3. Average of tBodyAcc-mean()-X per subject per activity
4. Average of tBodyAcc-mean()-Y per subject per activity
5. Average of tBodyAcc-mean()-Z per subject per activity
6. Average of tBodyAcc-std()-X per subject per activity
7. Average of tBodyAcc-std()-Y per subject per activity
8. Average of tBodyAcc-std()-Z per subject per activity
9. Average of tGravityAcc-mean()-X per subject per activity
10. Average of tGravityAcc-mean()-Y per subject per activity
11. Average of tGravityAcc-mean()-Z per subject per activity
12. Average of tGravityAcc-std()-X per subject per activity
13. Average of tGravityAcc-std()-Y per subject per activity
14. Average of tGravityAcc-std()-Z per subject per activity
15. Average of tBodyAccJerk-mean()-X per subject per activity
16. Average of tBodyAccJerk-mean()-Y per subject per activity
17. Average of tBodyAccJerk-mean()-Z per subject per activity
18. Average of tBodyAccJerk-std()-X per subject per activity
19. Average of tBodyAccJerk-std()-Y per subject per activity
20. Average of tBodyAccJerk-std()-Z per subject per activity
21. Average of tBodyGyro-mean()-X per subject per activity
22. Average of tBodyGyro-mean()-Y per subject per activity
23. Average of tBodyGyro-mean()-Z per subject per activity
24. Average of tBodyGyro-std()-X per subject per activity
25. Average of tBodyGyro-std()-Y per subject per activity
26. Average of tBodyGyro-std()-Z per subject per activity
27. Average of tBodyGyroJerk-mean()-X per subject per activity
28. Average of tBodyGyroJerk-mean()-Y per subject per activity
29. Average of tBodyGyroJerk-mean()-Z per subject per activity
30. Average of tBodyGyroJerk-std()-X per subject per activity
31. Average of tBodyGyroJerk-std()-Y per subject per activity
32. Average of tBodyGyroJerk-std()-Z per subject per activity
33. Average of tBodyAccMag-mean() per subject per activity
34. Average of tBodyAccMag-std() per subject per activity
35. Average of tGravityAccMag-mean() per subject per activity
36. Average of tGravityAccMag-std() per subject per activity
37. Average of tBodyAccJerkMag-mean() per subject per activity
38. Average of tBodyAccJerkMag-std() per subject per activity
39. Average of tBodyGyroMag-mean() per subject per activity
40. Average of tBodyGyroMag-std() per subject per activity
41. Average of tBodyGyroJerkMag-mean() per subject per activity
42. Average of tBodyGyroJerkMag-std() per subject per activity
43. Average of fBodyAcc-mean()-X per subject per activity
44. Average of fBodyAcc-mean()-Y per subject per activity
45. Average of fBodyAcc-mean()-Z per subject per activity
46. Average of fBodyAcc-std()-X per subject per activity
47. Average of fBodyAcc-std()-Y per subject per activity
48. Average of fBodyAcc-std()-Z per subject per activity
49. Average of fBodyAccJerk-mean()-X per subject per activity
50. Average of fBodyAccJerk-mean()-Y per subject per activity
51. Average of fBodyAccJerk-mean()-Z per subject per activity
52. Average of fBodyAccJerk-std()-X per subject per activity
53. Average of fBodyAccJerk-std()-Y per subject per activity
54. Average of fBodyAccJerk-std()-Z per subject per activity
55. Average of fBodyGyro-mean()-X per subject per activity
56. Average of fBodyGyro-mean()-Y per subject per activity
57. Average of fBodyGyro-mean()-Z per subject per activity
58. Average of fBodyGyro-std()-X per subject per activity
59. Average of fBodyGyro-std()-Y per subject per activity
60. Average of fBodyGyro-std()-Z per subject per activity
61. Average of fBodyAccMag-mean() per subject per activity
62. Average of fBodyAccMag-std() per subject per activity
63. Average of fBodyBodyAccJerkMag-mean() per subject per activity
64. Average of fBodyBodyAccJerkMag-std() per subject per activity
65. Average of fBodyBodyGyroMag-mean() per subject per activity
66. Average of fBodyBodyGyroMag-std() per subject per activity
67. Average of fBodyBodyGyroJerkMag-mean() per subject per activity
68. Average of fBodyBodyGyroJerkMag-std() per subject per activity
```

Data Processing
===============

1. To transform the name of the activity id to activity name following transformation is done
```
activity_ids = read.csv('dataset/train/y_train.txt', header=F, sep="", colClasses=c("numeric"))
activity_names = sapply(activity_ids$V1, function(x) { as.character(act[act$V1==x,]$V2) })
```
2. To find the mean of the variables per subject per activity, reshape package is used. first
   variables are `melt`ed per subject per activity and then using `dcast` mean is generated
```
melted = melt(merged, id.vars=c('subject', 'activity'))
result = dcast(melted, subject + activity ~ variable, mean)
```
