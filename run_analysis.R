## Script to run the analysis required for the Getting & Cleaning Data Course Project
##By Genevieve Beart 16/05/20 for the Coursera Getting & Cleaning Data Project

##-----Set up-----#

#Load the data manipulation package
library("dplyr")

##-------- 0. Read data from different folders -------##

    ## From the TRAIN folder:
    ##Training Set
    xtrain<-read.table("train/X_train.txt")
    ##Training Labels
    ytrain<-read.table("train/y_train.txt")
    ##Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
    subjecttrain<-read.table("train/subject_train.txt")

    ## From the TEST folder:
    ##Test Set
    xtest<-read.table("test/X_test.txt")
    ##Test Labels
    ytest<-read.table("test/y_test.txt")
    ##Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
    subjecttest<-read.table("test/subject_test.txt")

    ## From the parent folder:
    ##List of all features.
    features<-read.table("features.txt")
    ##Activity Labels - Links the class labels with their activity name.
    activitylabels<-read.table("activity_labels.txt")
    
##-------- 1. Merges the training and the test sets to create one data set. -------##
    
    ##Assign the Feature Names to the xtest and xtrain data sets - appropriately naming columns
    names(xtest)<-features$V2
    names(xtrain)<-features$V2
    
    ##create new columns in test and train data for the activitynumber and subject, and rename accordingly
    test<-cbind(xtest,ytest,subjecttest)
    colnames(test)[562]<-"activitynum"  
    colnames(test)[563]<-"subject"
    
    train<-cbind(xtrain,ytrain,subjecttrain)
    colnames(train)[562]<-"activitynum"
    colnames(train)[563]<-"subject"
    
    ##merge the test and train into one single data set
    testtrain<-rbind(test,train)
    
##--------2. Extracts only the measurements on the mean and standard deviation for each measurement. -------##
    
    ##Find columns with labels including strings "mean" OR "std", assign to vector 
    meanstdcols<-grep("mean|std",names(testtrain))
    
    ##Create a vector with the subject, activity, mean and standard column numbers
    reqdcols<-c(562,563,meanstdcols)
    
    ##Select only columns from the vector which found the mean and std columns and the activity/subject details
    testtrain_small<-testtrain[,c(reqdcols)]
    
##--------3. Merge in descriptive activity names to name the activities in the data set. -------##
    named_testtrain<-merge(x=testtrain_small,y=activitylabels,by.x="activitynum",by.y="V1",all.x=TRUE)
    ##Rename the activity name column and reorder the columns to have subject and activity name at front and drop activity number
    colnames(named_testtrain)[82]<-"activity"
    clean_testtrain<-named_testtrain[,c(2,82,3:81)]
    #sort the clean data from the subject then the activity
    clean_testtrain<-arrange(clean_testtrain,subject,activity)
    
##--------4. Appropriately label the data set with descriptive variable names. -------##  
    #Tidy up some of the confusing variable name text to make variable names simple to read
    names(clean_testtrain)<-gsub("^f", "Frequency", names(clean_testtrain))
    names(clean_testtrain)<-gsub("^t", "Time", names(clean_testtrain))
    names(clean_testtrain)<-gsub("-mean()", "Mean", names(clean_testtrain), ignore.case = TRUE)
    names(clean_testtrain)<-gsub("-std()", "STD", names(clean_testtrain), ignore.case = TRUE)

    clean_data<-clean_testtrain
    
##--------5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject.. -------##  
    output_data <- clean_data %>%
      group_by(subject, activity) %>%
      summarise_all(funs(mean))

    write.table(output_data, "output_data.txt", row.name=FALSE)
  
   

    