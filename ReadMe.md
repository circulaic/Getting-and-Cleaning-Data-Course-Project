---
title: "ReadMe for Getting & Cleaning Data Course Project"
author: "Genevieve Beart"
date: "16/05/2020"
output: pdf_document
---

## Document Overview

This is a ReadMe file which describes how the script "run_analysis.R" works.

## Script Functionality: "run_analyis.R"

The script "run_analysis.R" undertakes the following steps:

### Setup

This section of the script loads the data manipulation package "dyplr" to ensure its functions can be accessed later in the script. 

### 0. Read the Data

This section of the script assumes the .zip folder for the project has been downloaded and unzipped. It then reads the eight core files associated with the  project into variables.

The files it reads includes 3 files from the TRAIN folder detailing the data readings from training, the associated subjects and the type of activity undertaken. 

Likewise, the files it reads includes 3 files from the TEST folder detailing the data readings from the test, the associated subjects and the type of activity undertaken.

Two additional files are read from the main directory: the features file (which provides all of the variable names for the test and train data); and the  activity labels file which provides the key to convert numeric representations of the activity to text. 

### 1. Merge the Training and Test Data Sets

This section of the script combines the data together. Firstly, it takes the "features" file and uses the variable names in here to assign these to both the test and training data variables. It then appends two additional columns to both the test and training data which represent the activity undertaken in integer form, and the subject number (from 1 to 30). 

Finally, with both the test and training tables named, and augmented with the activity and subject details, the two tables are combined, being stacked on one another to create a single table with both the training and test data sets stored under the name "testtrain".

### 2. Extract the Name and Standard Deviations Columns 

With the consolidated table, the code now looks at the variable names and identifies columns with either the text string "mean" or "std" within the variable name. It then returns a vector identified the column numbers which pass this test, as well as the column numbers for the subject and activity. 

With this column vector, the combined training and test data is subset, taking all rows but only the columns whose ID is within the vector. This produces the smaller data set with only the columns for the subject, activity and variables which are either a mean or standard deviation. 


### 3. Merge in Descriptive Activity Names
Now that we have a smaller data frame with the columns we want, we merge in the activity labels data so that we have the text form (e.g., "WALKING", "SITTING") of the activity variables in the data frame. 

### 4. Labelling the Data Set
Here, we rename many of the variables to make them easier to read. Four specific labellings are changed - variables which start with "t" are renamed to start with "Time", variables which start with "f" are renamed to start with "Frequency", "-mean" is replaced by "Mean", and "-std" is replaced by "STD".

### 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject.

Finally, we use the dyplr package to group and then summarise the data. Firstly we initiate the pipeing, then we group the data by subject and activity to create every permutation of these two variables. Then for every purmutation we summarise across every column with the mean function to produce the average of each variable for each activity and each subject. 

This clean data is then written to an output table.
