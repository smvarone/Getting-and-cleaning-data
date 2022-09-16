# First we need to download and unzip the file

library(dplyr)

if(!file.exists('./projectweek4')){dir.create('./projectweek4')}
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', destfile = './projectweek4/data.zip')
unzip(zipfile = './projectweek4/data.zip', exdir = './projectweek4')

# 1. Merge the training and the test datasets into one

X_train <- read.table('./projectweek4/UCI HAR Dataset/train/X_train.txt', header = FALSE)
Y_train <- read.table('./projectweek4/UCI HAR Dataset/train/Y_train.txt', header = FALSE)
subject_train <- read.table('./projectweek4/UCI HAR Dataset/train/subject_train.txt', header = FALSE)

X_test <- read.table('./projectweek4/UCI HAR Dataset/test/X_test.txt', header = FALSE)
Y_test <- read.table('./projectweek4/UCI HAR Dataset/test/Y_test.txt', header = FALSE)
subject_test <- read.table('./projectweek4/UCI HAR Dataset/test/subject_test.txt', header = FALSE)

features <- read.table('./projectweek4/UCI HAR Dataset/features.txt', header = FALSE)
activity_labels = read.table('./projectweek4/UCI HAR Dataset/activity_labels.txt', header = FALSE)

colnames(subject_train) <- 'subjectID'
colnames(subject_test) <- 'subjectID'

colnames(X_train) <- t(features[,2])
colnames(X_test) <- t(features[,2])

colnames(activity_labels) <- c('activityID', 'action')

data <- cbind(rbind(Y_train, Y_test), rbind(X_train, X_test), rbind(subject_train, subject_test))

data_merged <- merge(data,activity_labels, by.x = 'subjectID', by.y = 'activityID')

# 2. Extract the measurements on the mean and the standard deviation of each measurement

mean_stadev <- select(activity_labels,subjectID, grep('\\bmean\\b | \\bstd\\b', colnames(data_merged))) 

# 3. Descriptive activity names for the activities in the data set

set_names_activites <- merge(mean_stadev_set, activity_labels, by = 'activityID', all.x = TRUE)

# 4. Label data set with descriptive variables

data_merged$activity_labels <- as.factor(data_merged$activity_labels)

colnames(data_merged) <- gsub('t', 'time', colnames(data_merged))
colnames(data_merged) <- gsub('f', 'frequency', colnames(data_merged))
colnames(data_merged) <- gsub('Acc', 'Accelerometer', colnames(data_merged))
colnames(data_merged) <- gsub('Gyro', 'Gyroscope', colnames(data_merged))
colnames(data_merged) <- gsub('Mag', 'Magnitude', colnames(data_merged))
colnames(data_merged) <- gsub('BodyBody', 'Body', colnames(data_merged))

# 5. Tidy set with the average of each subject and activity

tidy_set <- aggregate(. ~subjectID + action, data_merged, mean)

write.table(tidy_set, 'tidy_set.txt', row.names = FALSE)