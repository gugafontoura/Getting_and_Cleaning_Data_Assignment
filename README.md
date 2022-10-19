# Getting_and_Cleaning_Data_Assignment
 
As described on CodeBook.md, a function receive_data() was set for retrieving the data from the web and manipulating it so to be evaluated by this script. The data received "receive_data()", in this case assigned to "datavars", is a list with the following items: 
        - test: Test registers properly column named, within subject and activity data. 
        - train: Train registers properly column named, within subject and activity data. 
        - datadir: The specified dir for saving data (hereafter for saving output from run_analysis.R)
        source("receive_data.R")
        
The first step of "run_analysis.R" script is to call that function and separate its outputs, as to be used by the following lines of the script.

        ## RUNS FUNCTION (ON receive_data.R ARCHIVE) TO GET DATA FROM LINK, READ IT, AND PRE-PREPARE IT (AS DESCRIBED IN CODEBOOK, QUESTION 4 IS PART OF THE SCRIPT OF THAT FUNCTION)
        datavars <- receive_data()
        
        ## GET VARIABLES FROM FUNCTION
        test <- datavars$test ## TEST DATA
        train <- datavars$train ## TRAIN DATA
        datadir <- datavars$datadir ## DIR WHERE DATA IS STORED
        rm(datavars)

The second step, as asked in Question 1, was to Join Test and Train data together. I also rearrange columns, with select function, and sorted dataframe by subject and activityLabel, for better visualization.

        ## MERGES TEST AND TRAIN DATASETS AND ORGANIZE IT IN A MORE INTUITIVE WAY
        data <- full_join(test, train) %>% ## JOIN THEM TOGETHER (QUESTION 1)
                select(subject,activityLabel, type, 1:561) %>% ## REARRANGE COLUMNS
                arrange(subject, activityLabel) ## ARRANGE DATAFRAME BY SUBJECT AND ACTIVITY
        rm(test, train)
        
For Item 3, i retrivied data from "activity_labels.txt" whose content is Activities names and its respective indice in table. For turning the indices into descriptive labels, was declared a function that receives the number of an activitie and return its string label. That function was Sapplied to the whole activity label columns. 

        ## CHANGE ACTIVITIE LEVELS AND NAME TO DESCRIPTIVE (QUESTION 3)
        activities <- read.table(paste0(datadir, "/UCI HAR Dataset/activity_labels.txt"), col.names = c("number", "activity")) ## READ FILE WITH ACTIVITIES
        data$activityLabel <- as.factor(sapply(data$activityLabel, function(x){activities$activity[as.numeric(x)]})) ## SAPPLY A FUCTION TO CHANGE ACCORDING TO DOCUMENT INDEXES
        rm(activities)
        
For Item 2, a indices vector with variable names containing "std()" or "mean()" was created so we could subset columns with dplyr select(). I also added general id data (activityLabel, subject and type)
        
        ## CREATE A NEW DATA SET CONTAINING ID OF EACH OBSERVATION AND ALSO MEAN AND STANDARD DEVIATION MEASURES (QUESTION 2)
        data_sd_mean <- select(data, c("activityLabel", "subject", "type", grep("std()|mean()", colnames(data))))
        
For Item 5, the previous dataset was grouped by activityLabel and subject, so, with summarise function (notice .groups = "drop"), another dataset was created with the mean for each variables for each combination of  activityLabel and subject
        
        ## SUMMARIZE DATA_SD_MEAN AVERAGE FOR EACH VARIABLE AND EACH ACTIVITIE
        averages <- group_by(data_sd_mean, activityLabel, subject) %>% ## GROUP DATAFRAME BY SUBJECT AND ACTIVITY
                summarize(across(2:80, mean), .groups = 'drop')
                
General data, subsetted by std() and mean() dataset and summarised dataset, in this order, are saved to datadir.
        
        ## CREATE OUTPUT FILES 
        write.table(data, file = paste0(datadir, "/general.txt")) ## CREATE JOINED TEST AND TRAIN OUTPUT
        write.table(data_sd_mean, file = paste0(datadir, "/filtered.txt")) ## CREATE COLUMN FILTERED OUTPUT
        write.table(averages, file = paste0(datadir, "/tidy.txt")) ## CREATE SUMMARIZED TIDY OUTPUT
        rm(datadir, data, data_sd_mean, averages)
