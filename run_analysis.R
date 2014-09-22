base.dir <- 'UCI HAR Dataset/'

# read each file 
features <- read.table(paste(base.dir, 'features.txt', sep = ""))
activ.labels <- read.table(paste(base.dir, 'activity_labels.txt', sep = ""))
test.data <- read.table(paste(base.dir, 'test/X_test.txt', sep = ""))
test.labels <- read.table(paste(base.dir, 'test/y_test.txt', sep = ""))
test.subjects <- read.table(paste(base.dir, 'test/subject_test.txt', sep = ""))
train.data <- read.table(paste(base.dir, 'train/X_train.txt', sep = ""))
train.labels <- read.table(paste(base.dir, 'train/y_train.txt', sep = ""))
train.subjects <- read.table(paste(base.dir, 'train/subject_train.txt', sep = ""))

# merge train an test data
merged.data <- rbind(train.data, test.data)

# name the variable
names(merged.data) <- features[, 2]

# get the column indexes for mean and std variables
col_idx <- grep('(mean|std)\\(\\)', features[, 2])

# select only the column in col_idx
# subsetting merged.data to keep anly mean and std variables for each measurement
tidy.data <- merged.data[, col_idx]

# merge train and test activity labels
labels_idx <- rbind(train.labels, test.labels)

# add activity labels column to tidy.data
tidy.data$activity <- activ.labels$V2[labels_idx[[1]]]

# merge train and test subject ids
subjects <- rbind(train.subjects, test.subjects)

# add subject id column
tidy.data$subject <- subjects[[1]]

# use dplyr to comput mean of each varible group by activity and subject 
library(dplyr)

sum.data <- tidy.data %>%
  group_by(activity, subject) %>%
  summarise_each(funs(mean))

# write sum.data into a text file name tidy.txt
write.table(sum.data, file='tidy_data.txt', row.name=FALSE )

sum.data

