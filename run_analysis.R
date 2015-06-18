# Download and unzip dataset

if (!dir.exists('./data')) {
  dir.create('./data')
}

if (!dir.exists("./data/UCI HAR Dataset")) {
  download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                destfile = "./data/project_data.zip", method = "curl")
  unzip(zipfile = "./data/project_data.zip", exdir = "./data/", overwrite = TRUE)
}

# Load Activities
y_test_set <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
y_train_set <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
activities <- rbind(y_test_set, y_train_set)

# Load Activities Stats
x_test_set <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
x_train_set <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
activities_stats <- rbind(x_test_set, x_train_set)

# Load Subjects
volunteers_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
volunteers_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
volunteers <- rbind(volunteers_test, volunteers_train)

# Load Labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_std_features <- grep("-mean\\(\\)|-std\\(\\)", features[,2])
filtered_activities_stats <- activities_stats[,mean_std_features]

# Uses descriptive activity names to name the activities in the data set
names(filtered_activities_stats) <- features[filtered_features,2]

# Appropriately labels the data set with descriptive variable names. 
activities[,1] <- activity_labels[activities[,1],2]
names(activities) <- "Activity"
names(volunteers) <- "Volunteers"


# Create independent tidy data set with the average of each variable for each activity and each subject.
tidy_set <- cbind(volunteers, activities, filtered_activities_stats)

# Group by volunteers and activities and calculate mean for all features
library(dplyr)
result <- tidy_set %>% group_by(Volunteers, Activity) %>% summarise_each(funs(mean))

# Write tidy data to text file
write.table(result, file = "./run_analysis.txt", row.names = FALSE)
