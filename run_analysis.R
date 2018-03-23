#
# This script does the cleaning of data.
#

#
# Deleting preexisting variables.
#

rm(list = ls())


#
# Loading libraries.
# 

library(dplyr)
library(tidyr)


#
# Loading data.
#

activity_labels <- read.table("activity_labels.txt")

features <- read.table("features.txt")



xtrain <- read.table("X_train.txt")

ytrain <- read.table("y_train.txt")

subjecttrain <- read.table("subject_train.txt")



xtest <- read.table("X_test.txt")

ytest <- read.table("y_test.txt")

subjecttest <- read.table("subject_test.txt")

#
# Eliminating the punctuation of the variable names and writing the 
# variables with lowercase letters.
#


activity_labels <- gsub("[[:punct:]]","",activity_labels$V2)

activity_labels <- tolower(activity_labels)

#
# Rewriting the names of variables to understandable names.
#


ytrain$V1 <- factor(ytrain$V1, levels = c(1:6), labels = activity_labels )

ytest$V1 <- factor(ytest$V1, levels = c(1:6), labels = activity_labels )


ytrain$V1 <- as.character(ytrain$V1)

ytest$V1 <- as.character(ytest$V1)


names(ytrain) <- "activity"

names(ytest) <- "activity"

names(subjecttrain) <- "subject"

names(subjecttest) <- "subject"


feact <- features$V2

feact <-as.character(feact)


names(xtrain) <- feact

names(xtest) <- feact


#
# Selected variables referring to mean and standard deviation only.
#

xtrain <- xtrain[, grep( "mean\\(\\)|std\\(\\)" ,names(xtrain))]

xtest <- xtest[, grep( "mean\\(\\)|std\\(\\)" ,names(xtest))]


#
# Eliminating the punctuation of the variable names and writing the 
# variables with lowercase letters.
#


names(xtrain) <- gsub("[[:punct:]]", "", names(xtrain))

names(xtrain)<-tolower(names(xtrain))


names(xtest) <- gsub("[[:punct:]]", "", names(xtest))

names(xtest)<-tolower(names(xtest))



#
# Combined dataset.
#


xytrain <- cbind(ytrain,xtrain)

xysubjecttrain <- cbind(subjecttrain,xytrain)


xytest <- cbind(ytest,xtest)

xysubjecttest <- cbind(subjecttest,xytest)


#
# Combined test and training data into only one set of data.
#

xysubjectset <- rbind(xysubjecttrain,xysubjecttest)


xysubjectset$activity<-as.factor(xysubjectset$activity)


#
# Calculatting the average of each variable for each activity and each subject.
#

tidyData <- group_by(xysubjectset, subject,activity)

tidyData <- summarise_all(tidyData,.funs = mean)


#
# Writing the tidy data set into a txt file
#

write.table(tidydata, file = "tidyData.txt", row.names = FALSE)



tidyD <- read.table("tidyData.txt", header = TRUE)










