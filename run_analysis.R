# =============================================================================
# 1. Merges the training and the test sets to create one data set.
# =============================================================================

# 1.1 Read train set
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

# 1.2 Read test set
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# 1.3 Read feature/column names
features <- read.table("features.txt")[,2]
features <- c(features, "subjectId", "activityId")

# 1.4 Merge train and test together
merge_train <- cbind(X_train, subject_train, y_train)
merge_test <- cbind(X_test, subject_test, y_test)
merge_all <- rbind(merge_train, merge_test)

# 1.5 Update column names to feature names
colnames(merge_all) <- features

# =============================================================================
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# =============================================================================
library(dplyr)
mean_and_std <- select(merge_all, contains("mean") | contains("std") | "subjectId" | "activityId")

# =============================================================================
# 3. Uses descriptive activity names to name the activities in the data set
# =============================================================================
activity_labels <- read.table("activity_labels.txt")
colnames(activity_labels) <- c("activityId", "activityName")
merge_all <- merge(x=merge_all, y=activity_labels, by="activityId", all.x=TRUE)

# =============================================================================
# 4. Appropriately labels the data set with descriptive variable names.
# =============================================================================
# Already done!

# =============================================================================
# 5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
# =============================================================================
# tidy_all <- aggregate(.~activityName.x+subjectId, merge_all, mean)
tidy_all <- aggregate(x = merge_all, by = merge_all[c("activityId", "subjectId")], 
                      FUN = mean, na.rm = TRUE)
write.table(tidy_all, "tidy_all.txt", row.name=FALSE)
