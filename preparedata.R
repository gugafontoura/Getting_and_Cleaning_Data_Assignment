preparedata <- function(){

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
                
        datavars <- list(test = test, train = train, datadir = datadir, features = features)
        return(datavars)

}