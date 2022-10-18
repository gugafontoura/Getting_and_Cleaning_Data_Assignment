source("preparedata.R")

#get the data from the internet, and prepare it, as explained in code book. script in archive preparedata.R and CodeBook.md
datavars <- preparedata()

#get variables from function
test <- datavars$test #test data
train <- datavars$train #train data
datadir <- datavars$datadir #dir where data is stored
features <- datavars$features #columns variables

rm(datavars)

# Merges the training and the test sets to create one data set. 
data <- full_join(test, train)

# Extracts only the measurements on the mean and standard deviation for each measurement. (With and Without experiment data, since it wasn't specified)
stdmeandt <- select(data, c(grep("std()|mean()", colnames(data))))
stdmeandata <- select(data, c(grep("std()|mean()", colnames(data)),"activityLabel", "subject", "type"))

# Uses descriptive activity names to name the activities in the data set (for complete and filtered datasets, since it wasn't specified)
activities <- read.table(paste0(datadir, "/UCI HAR Dataset/activity_labels.txt"), col.names = c("number", "activity"))
data <- mutate(data, activityLabelDesc = sapply(activityLabel, function(x){activities$activity[x]}))
stdmeandata <- mutate(stdmeandata, activityLabelDesc = sapply(activityLabel, function(x){activities$activity[x]}))

# Appropriately labels the data set with descriptive variable names. 
        # Column names were setted in the cleaning script, according to README.txt and the other orientation documents
        # That were done intending to facilitate coding in this script
        features # in features variable
        colnames(test); colnames(train); colnames(data) #assigned for all data sets also

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data <- mutate(data, activityLabelDesc = as.factor(activityLabelDesc)) %>%
        group_by(activityLabelDesc, subject)
averages <- summarize(data, across(everything(), mean))

#create files for averages dataset and the tidy complete dataset
write.table(averages, file = paste0(datadir, "/q5.txt")) #question 5 dataset
write.table(data, file = paste0(datadir, "/qn1n3n4.txt")) #question 1,3 and 4 dataset
write.table(stdmeandt, file = paste0(datadir, "/q2.txt")) #question 2 dataset