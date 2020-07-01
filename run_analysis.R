library(dplyr)
library(data.table)

# Download data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="c:/Users/rbrown5/CourseraR/datasciencecoursera/GetCleanData/data/dataset.zip",method="curl")

setwd("C://Users/rbrown5/CourseraR/datasciencecoursera/GetCleanData/Data/UCI HAR Dataset/")

# read train data 
x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 
subject_train <- read.table("./train/subject_train.txt")

# read test data 
x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
subject_test <- read.table("./test/subject_test.txt")

# read features description 
features <- read.table("./features.txt") 

# read activity labels 
activity_labels <- read.table("./activity_labels.txt") 

# merge datasets
x_data   <- rbind(x_train, x_test)
y_data   <- rbind(y_train, y_test) 
subject_data <- rbind(subject_train, subject_test)

# subset data with mean and standard deviation
selected <- features[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_data  <- x_data[,selected[,1]]

# create column names
colnames(x_data)   <- selected[,2]
colnames(y_data)   <- "activity"
colnames(subject_data) <- "subject"

# Create one merged dataset
final_data <- cbind(subject_data, y_data, x_data)

# Make activities & subjects factors 
final_data$activity <- factor(final_data$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
final_data$subject  <- as.factor(final_data$subject) 

# Create a second tidy dataset with average for each variable by activity and subject
final_mean <- final_data %>% group_by(activity, subject) %>% summarize_all(list(mean))

write.table(final_mean, file = "C://Users/rbrown5/CourseraR/datasciencecoursera/GetCleanData/Data/tidydata.txt",
            col.names = TRUE, row.names = FALSE)