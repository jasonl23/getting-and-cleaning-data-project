## Reads activity files

datatestactivity  <- read.table("./UCI HAR Dataset/test/Y_test.txt" ,header = FALSE)
datatrainactivity <- read.table("./UCI HAR Dataset/train/Y_train.txt",header = FALSE)

## Reads subject files

datatestsubject  <- read.table("./UCI HAR Dataset/test/subject_test.txt",header = FALSE)
datatrainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt",header = FALSE)

##Reads feature files

datatestfeatures  <- read.table("./UCI HAR Dataset/test/X_test.txt" ,header = FALSE)
datatrainfeatures <- read.table("./UCI HAR Dataset/project/train/X_train.txt",header = FALSE)


## Merges data tables

dataactivity <- rbind(datatestactivity, datatrainactivity)
datasubject <- rbind(datatestsubject, datatrainsubject)
datafeatures <- rbind(datatestfeatures, datatrainfeatures)

##set names to variables

names(dataactivity)<- c("activity")
names(datasubject)<-c("subject")
datafeaturesnames <- read.table("./UCI HAR Dataset/features.txt",head=FALSE)
names(datafeatures)<- datafeaturesnames$V2

## Merge columns to get the data frame for all data

datacombine <- cbind(datasubject, dataactivity)
data <- cbind(datafeatures, datacombine)

## Subset measurements on mean and standard deviation

subdatafeaturesnames<-datafeaturesnames$V2[grep("mean\\(\\)|std\\(\\)", datafeaturesnames$V2)]

## Subset data frame Data by seleted names of Features

selectednames<-c(as.character(subdatafeaturesnames), "subject", "activity" )
data<-subset(data,select=selectednames)

## Check structures of the data frame

str(data)

## Read descriptive activity names from “activity_labels.txt”

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE)


## Check

head(data$activity,30)

## labels dataset with descriptive names

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

## check 

names(data)

#creates second independent dataset and outputs it

library(dplyr);
data2<-aggregate(. ~subject + activity, data, mean)
data2<-data2[order(data2$subject,data2$activity),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)

