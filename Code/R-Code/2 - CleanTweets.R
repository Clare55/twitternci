# ================================================================================================================================== 
# 
# Script to convert JSON files to CSVs
# 
# ================================================================================================================================== 

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Install and Load stringr, lubridate and dplyr packages
#---------------------------------------------------------------------------------------------------------------------------------------------------------
packages = c("stringr", "lubridate", "dplyr")
packages = packages[!(packages %in% installed.packages()[,"Package"])]
if (length(packages) > 0) 
{
  install.packages(packages)
}

library(stringr)
library(lubridate)
library(dplyr)

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Loops through an existing set of JSON files (169 files) and converts them to CSV
#---------------------------------------------------------------------------------------------------------------------------------------------------------

setwd("C:/Users/claremc.EUROPE/OneDrive/NCI/Programming/TwitterProject/FIles/JSON")
i <- 2

for (i in 1:170) {
  # For each file create the file name by combining "tweets_world" and ".json" with i
  myfile = paste("tweets_World",i,".json", sep = "")  
  # Parse each of the files
  tweetsWorld <- parseTweets(myfile, verbose = FALSE)
  
  # Modify the created_at and user_created_at times
  tweetsWorld$created_at <- format(strptime(tweetsWorld$created_at,format='%a %b %d %H:%M:%S'), usetz=FALSE)
  tweetsWorld$user_created_at <- format(strptime(tweetsWorld$user_created_at,format='%a %b %d'), usetz=FALSE)

  # Reduce to only take the variables necessary
  sample <- tweetsWorld[,c(2,5,7:10, 12, 16, 18:22, 26:29, 31, 33, 37:40)]
  # Add an empty variable - this is to facilitate an auto incremented id in MySQL
  sample$id <- 0
  sample$retweeted <- as.integer(sample$retweeted)
  sample$geo_enabled <- as.integer(sample$geo_enabled)
  sample$utc_offset[which(is.na(sample$utc_offset == TRUE))] = ""
  sample$place_lat[which(sample$place_lat == "NaN")] = 0
  sample$place_lon[which(sample$place_lon == "NaN")] = 0
  sample$lat[which(is.na(sample$lat == TRUE))] = ""
  sample$lon[which(is.na(sample$lon == TRUE))] = ""
  sample$user_created_at[which(is.na(sample$user_created_at == TRUE))] = "2010-01-01"
  sample$date <- as.Date(sample$created_at, format = '%Y-%m-%d')
  sample$hour <- hour(ymd_hms(sample$created_at))
  
  sample <- select(sample, id, retweet_count, id_str, source, retweeted, created_at, in_reply_to_status_id_str, lang, user_id_str, 
                   geo_enabled, user_created_at, statuses_count, followers_count, favourites_count, time_zone, user_lang, utc_offset, 
                   friends_count, country_code, place_type, place_lat, place_lon, lat, lon, date, hour)
  
  # Create a filename for the saved CSV files
  mysavedfile = paste("C:/Users/claremc.EUROPE/Desktop/SharedFolder/tweetsNov-",i,".csv", sep = "")
  
  # Write out the CSV files to the SharedFolder that's shared with Ubuntu VM
  write.table(sample, file = mysavedfile,row.names=FALSE, eol = "\r", na="", sep=",", col.names = FALSE, fileEncoding = "UTF-8")

  # Increment by 1 to go to next JSON
  i <- i + 1
}
