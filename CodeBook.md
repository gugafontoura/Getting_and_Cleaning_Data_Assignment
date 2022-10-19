At first, data was collected and pre-prepared for questions with the created function "receive_data()". 
In general, it retrieves the data from the given link, downloads it, retrieves Train and Test data, and returns it as variables to be used in the main script, by a list datavars, within other important variables for evaluating the whole data set. 
The script was available at "receive_data.R" archive. 
 
Step-by-step data manipulation:

- The biggest majority of functions used in that analysis were from dplyr package: 
        
                library(dplyr)

- At first, to facilitate use of DIR related attributes, variables we're setted for DIR and Downloaded file, in that step the archive was also downloaded, as the package was unzipped
        
                ## CREATES TRACEABLE DIR 
                datadir <- paste0(getwd(), "/data")
                dir.create(datadir)
                
                ## CREATES AND DOWNLOAD TRACEABALE FILE 
                datazipfile <- paste0(datadir, "/data.zip")
                if(!file.exists(datazipfile)){
                        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", datazipfile)}
                
                ## UNZIP FILES
                setwd(datadir)
                unzip(datazipfile)
                setwd("..")
        
- As was informed on "README.txt", of the downloaded data, each columns of data was given by "features.txt" archive. In this step this data was read, transformed into a vector, and also was appended by other variable names that are gonna be used in next steps 
        
                features <- read.table(paste0(datadir, "/UCI HAR Dataset/features.txt"))
                features <- c(as.vector(features$V2), "activityLabel", "subject", "type")
        
- Just like the first step, variables for DIR were Train and Test data was specified 
        
                traindir <- paste0(getwd(),"/data/UCI HAR Dataset/train")
                testdir <- paste0(getwd(),"/data/UCI HAR Dataset/test")
        
- Preparing Tests and Trains datasets were the result of similar stages. 
                
                # At first, i read the subject files, containing the ID that identifies each participant of the experiment.
        
                        subject_train <- unlist(as.vector(read.table(paste0(traindir, "/subject_train.txt"))))
                        subject_train <- factor(subject_train, c(1:30))
                
                        subject_test <- unlist(as.vector(read.table(paste0(testdir, "/subject_test.txt"))))
                        subject_test <- factor(subject_test, c(1:30))

.

                # Second, variables indicating the activity for each record, in Y file, are readed. 

                        y_train <- unlist(as.vector(read.table(paste0(traindir, "/y_train.txt"))))
                        y_test <- unlist(as.vector(read.table(paste0(testdir, "/y_test.txt"))))
        
.

                # Third, the registers of the experiment for each record, in X file, are readed.

                        x_train <- as_tibble(read.table(paste0(traindir, "/X_train.txt")))
                        x_test <- as_tibble(read.table(paste0(testdir, "/X_test.txt")))
                        
.

                # Merge all infos together, from X tables, within Y tables, subject tables and the variable type indicating if it refers to a "TRAIN" register or a "TEST" register
                
                        train <- mutate(x_train, activityLabel = y_train, subject = subject_train, type = "TRAIN")
                        test <- mutate(x_test, activityLabel = y_test, subject = subject_test, type = "TEST")
                
.

                # Remove variables that wont't be used anymore
                
                        rm(subject_train, y_train, x_train)
                        rm(subject_test, y_test, x_test)
                
.

                # Add columns names for both "train" and "test" datasets. Since were found duplicated column names, attribute unique was set to TRUE, adding suffix to duplicated names
                
                        colnames(train) <- make.names(features, unique=TRUE)    
                        colnames(test) <- make.names(features, unique=TRUE)
                        
- Assign to a list variables that will be used in the "run_analysis()" script
                
                datavars <- list(test = test, train = train, datadir = datadir)

As result of that function, i will be returne with values for: 
        - test: Test registers properly column named, within subject and activity data. 
        - train: Train registers properly column named, within subject and activity data. 
        - datadir: The specified dir for saving data (hereafter for saving output from run_analysis.R)
        
About variables at outputted datasets, it's important to tell that, differing from original variables (available on "~/data/UCI HAR Dataset/features_info.txt"), are the above:

                    
                    activityLabel - Describes which kind of activities was being done in the experiment registered
                            
                            Values: 1 for WALKING
                                    2 for WALKING_UPSTAIRS
                                    3 for WALKING_DOWNSTAIRS
                                    4 for SITTING
                                    5 for STANDING
                                    6 for LAYING
                                            Integer

                            -- refactored at line 20 of "run_analysis.R"--        
                            Values: WALKING
                                    WALKING_UPSTAIRS
                                    WALKING_DOWNSTAIRS
                                    SITTING
                                    STANDING
                                    LAYING
                            
                                            String
                    
                    subject - Number that idetifies whose was the volunteer of the registered experiment
                            
                            Values: 1 to 30 
                            
                                            Integer 
                            
                    type - Describes if it refers to a train or a test experiment
                            
                            Value: Train or Test
                            
                                            String as Factor

