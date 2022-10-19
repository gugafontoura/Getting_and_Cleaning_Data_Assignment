source("receive_data.R")

## RUNS FUNCTION (ON receive_data.R ARCHIVE) TO GET DATA FROM LINK, READ IT, AND PRE-PREPARE IT (AS DESCRIBED IN CODEBOOK, QUESTION 4 IS PART OF THE SCRIPT OF THAT FUNCTION)
datavars <- receive_data()

## GET VARIABLES FROM FUNCTION
test <- datavars$test ## TEST DATA
train <- datavars$train ## TRAIN DATA
datadir <- datavars$datadir ## DIR WHERE DATA IS STORED
rm(datavars)

## MERGES TEST AND TRAIN DATASETS AND ORGANIZE IT IN A MORE INTUITIVE WAY
data <- full_join(test, train) %>% ## JOIN THEM TOGETHER (QUESTION 1)
        select(subject,activityLabel, type, 1:561) %>% ## REARRANGE COLUMNS
        arrange(subject, activityLabel) ## ARRANGE DATAFRAME BY SUBJECT AND ACTIVITY
rm(test, train)

## CHANGE ACTIVITIE LEVELS AND NAME TO DESCRIPTIVE (QUESTION 3)
activities <- read.table(paste0(datadir, "/UCI HAR Dataset/activity_labels.txt"), col.names = c("number", "activity")) ## READ FILE WITH ACTIVITIES
data$activityLabel <- as.factor(sapply(data$activityLabel, function(x){activities$activity[as.numeric(x)]})) ## SAPPLY A FUCTION TO CHANGE ACCORDING TO DOCUMENT INDEXES
rm(activities)

## CREATE A NEW DATA SET CONTAINING ID OF EACH OBSERVATION AND ALSO MEAN AND STANDARD DEVIATION MEASURES (QUESTION 2)
data_sd_mean <- select(data, c("activityLabel", "subject", "type", grep("std()|mean()", colnames(data))))

## SUMMARIZE DATA_SD_MEAN AVERAGE FOR EACH VARIABLE AND EACH ACTIVITIE
averages <- group_by(data_sd_mean, activityLabel, subject) %>% ## GROUP DATAFRAME BY SUBJECT AND ACTIVITY
        summarize(across(2:80, mean), .groups = 'drop')

## CREATE OUTPUT FILES 
write.table(data, file = paste0(datadir, "/general.txt")) ## CREATE JOINED TEST AND TRAIN OUTPUT
write.table(data_sd_mean, file = paste0(datadir, "/filtered.txt")) ## CREATE COLUMN FILTERED OUTPUT
write.table(averages, file = paste0(datadir, "/tidy.txt")) ## CREATE SUMMARIZED TIDY OUTPUT
rm(datadir, data, data_sd_mean, averages)