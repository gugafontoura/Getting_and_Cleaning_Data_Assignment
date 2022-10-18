Each observation of final dataset, is the result of one Training or Testing experiment. So, in this case, variables can be divided by two groups:         
        1. The ones specified by data resourcer: as explained in the archive "~/data/UCI HAR Dataset/README.txt"
        2. The ones created by the analist, as the questions pointed too, arranged alphabetically below:
                + Variables increased on the resulting data set
                        activityLabel - Describes which kind of activities was being done in the experiment registered, as it was originally    registred by data producer
                                
                                Values: 1 for WALKING
                                        2 for WALKING_UPSTAIRS
                                        3 for WALKING_DOWNSTAIRS
                                        4 for SITTING
                                        5 for STANDING
                                        6 for LAYING
                                
                                                Integer
                        
                        activityLabelDesc - Describes which kind of activities was being done in the experiment registered
                                
                                Values: WALKING
                                        WALKING_UPSTAIRS
                                        WALKING_DOWNSTAIRS
                                        SITTING
                                        STANDING
                                        LAYING
                                
                                                String as Factor
                        
                        subject - Number that idetifies whose was the volunteer of the registered experiment
                                
                                Values: 1 to 30 
                                
                                                Integer 
                                
                        type - Describes if it refers to a train or a test experiment
                                
                                Value: Train or Test
                                
                                                String as Factor
                
                + Variables resulting from running the script
                        
                        activities - Dataframe of the activities and its refered code
                        
                        averages - Dataframe of the average of each variable for each activity and each subject
                
                        data - merged an tidy dataframe containing train and test registers
                        
                        stdmeandata - Dataframe containing only std and mean registers, plus the general identification of the registred experiment
                        
                        stdmeandt - Dataframe containing only std and mean registers
                        
                        test - tidy dataframe containaing test registers
                        
                        train - tidy dataframe containaing train registers


The data was collected and initially prepared, as some variables for run_analysis, by the function preparedata() on script preparedata.R. 
The whole script of the funtcion is diposed bellow: 

        library(dplyr)
        
        #creates a traceable dir for data in project folder
        datadir <- paste0(getwd(), "/data")
        dir.create(datadir)
        
        #creates and download traceable file for data in project folder
        datazipfile <- paste0(datadir, "/data.zip")
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", datazipfile)
        
        #unzip files 
        setwd(datadir)
        unzip(datazipfile)
        setwd("..")
        
        #retrieve measured features for columns 
        features <- read.table(paste0(datadir, "/UCI HAR Dataset/features.txt"))
        features <- c(as.vector(features$V2), "activityLabel", "subject", "type")
        
        #set train and test data dir 
        traindir <- paste0(getwd(),"/data/UCI HAR Dataset/train")
        testdir <- paste0(getwd(),"/data/UCI HAR Dataset/test")
        
        #prepare train data set
        
                #read subjects as vector
                subject_train <- unlist(as.vector(read.table(paste0(traindir, "/subject_train.txt"))))
        
                #read activities labels as vector
                y_train <- unlist(as.vector(read.table(paste0(traindir, "/y_train.txt"))))
        
                #read train data
                x_train <- as_tibble(read.table(paste0(traindir, "/X_train.txt")))
        
                #join all data
                train <- mutate(x_train, activityLabel = as.factor(y_train), subject = as.factor(subject_train), type = "train")
                
                #clean variables
                rm(subject_train, y_train, x_train)
                
                #name columns (with make names to add suffix to duplicated names)
                colnames(train) <- make.names(features, unique=TRUE)
                
        #prepare test data set 
        
                #read subjects as vector
                subject_test <- unlist(as.vector(read.table(paste0(testdir, "/subject_test.txt"))))
                
                #read activities labels as vector
                y_test <- unlist(as.vector(read.table(paste0(testdir, "/y_test.txt"))))
                
                #read test data
                x_test <- as_tibble(read.table(paste0(testdir, "/X_test.txt")))
        
                #join all data
                test <- mutate(x_test, activityLabel = as.factor(y_test), subject = as.factor(subject_test), type = "test")
        
                #clean variables
                rm(subject_test, y_test, x_test)
                
                #name columns (with make names to add suffix to duplicated names)
                colnames(test) <- make.names(features, unique=TRUE)