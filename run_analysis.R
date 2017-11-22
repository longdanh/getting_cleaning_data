# COURSE PROJECT
# NAME: PEDRO MANUEL MORENO MARCOS
# INSTITUTION: UNIVERSIDAD CARLOS III DE MADRID

# 0. Load data
X_train_path = "./UCI HAR Dataset/train/X_train.txt"
X_train = read.table(X_train_path)
X_test_path = "./UCI HAR Dataset/test/X_test.txt"
X_test = read.table(X_test_path)
y_train_path = "./UCI HAR Dataset/train/y_train.txt"
y_train = read.table(y_train_path)
y_test_path = "./UCI HAR Dataset/test/y_test.txt"
y_test = read.table(y_test_path)
subject_train_path = "./UCI HAR Dataset/train/subject_train.txt"
subject_train = read.table(subject_train_path)
subject_test_path = "./UCI HAR Dataset/test/subject_test.txt"
subject_test = read.table(subject_test_path)

# 1. Merges the training and the test sets to create one data set.
train = cbind(subject_train, y_train, X_train)
test = cbind(subject_test, y_test, X_test)
dataset = rbind(train,test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features_path = "./UCI HAR Dataset/features.txt"
features = read.table(features_path)
idx = grep("mean|std", features$V2)
idx2 = c(1,2,idx+2)
dataset2 = dataset[, idx2]

# 3. Uses descriptive activity names to name the activities in the data set
activities_path = "./UCI HAR Dataset/activity_labels.txt"
activity_labels = read.table(activities_path)
dataset2$V1.1 <- activity_labels[dataset2$V1.1,2]

# 4. Appropriately labels the data set with descriptive variable names. 
names(dataset2)[-(1:2)] = as.character(features[idx,2])
names(dataset2)[1] = "subject"
names(dataset2)[2] = "activity"
names(dataset2) = gsub("-","", names(dataset2),)
names(dataset2) = gsub("mean","Mean", names(dataset2),)
names(dataset2) = gsub("std","Std", names(dataset2),)
names(dataset2) = gsub("\\(\\)","", names(dataset2),)
names(dataset2) = sub("^t","time", names(dataset2),)
names(dataset2) = sub("^f","freq", names(dataset2),)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
library(dplyr)
groups = group_by(dataset2, subject, activity)
dataset3 = summarize_all(groups, funs(mean))

# 6. Exports results to a .txt file
library(utils)
write.table(dataset3, "data.txt", quote=FALSE, row.names=FALSE)