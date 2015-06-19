library(dplyr)

train <- read.table("./data/X_train.txt")
test <- read.table("./data/X_test.txt")

subjectTrain <- as.vector(read.table("./data/subject_train.txt"))
subjectTest <- as.vector(read.table("./data/subject_test.txt"))
trainingLabels <- as.vector(read.table("./data/y_train.txt"))
testLabels <- as.vector(read.table("./data/y_test.txt"))
features <- as.vector(read.table("./data/features.txt"))
activityLabels <- as.vector(read.table("./data/activity_labels.txt"))
names(activityLabels) <- c("ActivityID", "Activity")

names(train) <- features$V2
names(test) <- features$V2

train[, "Subject"] <- subjectTrain
train[, "ActivityID"] <- trainingLabels
test[, "Subject"] <- subjectTest
test[, "ActivityID"] <- testLabels

train <- merge(train, activityLabels, by = "ActivityID", all = TRUE)
test <- merge(test, activityLabels, by = "ActivityID", all = TRUE)

mergedSet <- merge(train, test, all = TRUE)
resultSet <- select(mergedSet, matches('std|mean|Activity|Subject'))

resultSet <- tbl_df(resultSet[, c(88, 89, 1:86)])

finalSet <- resultSet %>%
                group_by(Subject, Activity) %>%
                summarise_each(funs(mean)) %>%
                select(Subject, Activity, matches('std|mean'))

write.table(finalSet, "./data/tidy_data.txt", row.name = FALSE)




