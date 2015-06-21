run_analysis  <- function() {
    
    main <- "C:/Users/Tarak Paipuru/Desktop/Data Science/Getting and Cleaning Data/UCI HAR Dataset"
    test <- "C:/Users/Tarak Paipuru/Desktop/Data Science/Getting and Cleaning Data/UCI HAR Dataset/test"
    train <- "C:/Users/Tarak Paipuru/Desktop/Data Science/Getting and Cleaning Data/UCI HAR Dataset/train"
    mergepath <- "C:/Users/Tarak Paipuru/Desktop/Data Science/Getting and Cleaning Data/UCI HAR Dataset/merge"
    dir.create(mergepath,mode = "0777")
    
    
    
    #merge test and train
    
    setwd(train)
    file_list_train1 <- dir()
    
    setwd(test)
    file_list_test1 <- dir()
    
    
    
    for(file_test1 in file_list_test1) {
        
        if(substr(file_test1,(nchar(file_test1))-3,(nchar(file_test1))) == ".txt") {
            
            file_without_test1 <- sub("_test","",file_test1)
            
            setwd(test)
            
        } else { next }
        
        
        for(file_train1 in file_list_train1) {
            
            if(substr(file_train1,(nchar(file_train1))-3,(nchar(file_train1))) == ".txt") {
                
                file_without_train1 <- sub("_train","",file_train1)
                
                if(file_without_test1 == file_without_train1){
                    
                    setwd(test) 
                    
                    p <- read.table(file_test1)
                    
                    setwd(train)
                    
                    q <- read.table(file_train1)
                    
                    r <- rbind(p,q)
                    
                    setwd(mergepath)
                    
                    write.table(r,file_without_test1)
                }
                
            } else {next}
            
        }
    }

    setwd(mergepath)
    final_list  <- dir()
    
    for(file in final_list)
    {
        if(file == "subject.txt")
        {
            subject_df  <- data.frame(read.table(file))
            names(subject_df)  <- "subject_id"
            file.remove(file)
        }
        
        else if(file == "y.txt")
        {
            activity_df  <- data.frame(read.table(file))
            names(activity_df)  <- "activity_id"
            
            file.remove(file)
        }
        
        else if(file == "X.txt")
        {
            measurements_df  <- data.frame(read.table(file))
            
            measurement_names <- data.frame(read.table("C:/Users/Tarak Paipuru/Desktop/Data Science/Getting and Cleaning Data/UCI HAR Dataset/features.txt"))
            
            names(measurements_df)  <- measurement_names[,2]
            
            file.remove(file)
            
        } 
    }
    
    f1  <- cbind(measurements_df,subject_df,activity_df)
    
    tidy_data_mean <- f1[grep("mean",names(f1))]
    tidy_data_std  <- f1[grep("std",names(f1))]
    tidy_data_other <- f1[,562:563]
    
    tidy_data_final <-  cbind(tidy_data_mean,tidy_data_std,tidy_data_other)
    
    activity_labels <- data.frame(read.table("C:/Users/Tarak Paipuru/Desktop/Data Science/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt"))
    names(activity_labels)[2]  <- "activity"
    tidy_data_final <- merge(tidy_data_final,activity_labels,by.x = "activity_id",by.y = "V1",all = TRUE)
    tidy_data_final <- tidy_data_final[,2:ncol(tidy_data_final)]
    
    write.table(tidy_data_final,"tidy_data.txt",row.names = FALSE)
    
}
