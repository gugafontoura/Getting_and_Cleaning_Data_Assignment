receive_data <- function(){

        library(dplyr)

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
        
        ## RETRIEVE FEATURES FOR COLUMNS
        features <- read.table(paste0(datadir, "/UCI HAR Dataset/features.txt"))
        features <- c(as.vector(features$V2), "activityLabel", "subject", "type")
        
        ## SET TRAIN AND TEST DIR
        traindir <- paste0(getwd(),"/data/UCI HAR Dataset/train")
        testdir <- paste0(getwd(),"/data/UCI HAR Dataset/test")
        
        ## PREPARE TRAIN DATA SET
        
                ## READ SUBJECTS AS VECTOR
                subject_train <- unlist(as.vector(read.table(paste0(traindir, "/subject_train.txt"))))
                subject_train <- factor(subject_train, c(1:30))
                
                ## READ ACTIVITIES LABELS AS VECTOR
                y_train <- unlist(as.vector(read.table(paste0(traindir, "/y_train.txt"))))
        
                ## READ TRAIN DATA
                x_train <- as_tibble(read.table(paste0(traindir, "/X_train.txt")))
        
                ## JOIN ALL DATA
                train <- mutate(x_train, activityLabel = y_train, subject = subject_train, type = "TRAIN")
                
                ## CLEAN VARIABLES
                rm(subject_train, y_train, x_train)
                
                ## NAME COLUMNS (WITH MAKE NAMES TO ADD SUFFIX TO DUPLICATED NAMES)
                colnames(train) <- make.names(features, unique=TRUE)
                
        ## PREPARE TEST DATA SET
                
                ## READ SUBJECTS AS VECTOR
                subject_test <- unlist(as.vector(read.table(paste0(testdir, "/subject_test.txt"))))
                subject_test <- factor(subject_test, c(1:30))
                
                ## READ ACTIVITIES LABELS AS VECTOR
                y_test <- unlist(as.vector(read.table(paste0(testdir, "/y_test.txt"))))
                
                ## READ TEST DATA
                x_test <- as_tibble(read.table(paste0(testdir, "/X_test.txt")))
                
                ## JOIN ALL DATA
                test <- mutate(x_test, activityLabel = y_test, subject = subject_test, type = "TEST")
                
                ## CLEAN VARIABLES
                rm(subject_test, y_test, x_test)
                
                ## NAME COLUMNS (WITH MAKE NAMES TO ADD SUFFIX TO DUPLICATED NAMES)
                colnames(test) <- make.names(features, unique=TRUE)
                
        datavars <- list(test = test, train = train, datadir = datadir)
        return(datavars)

}