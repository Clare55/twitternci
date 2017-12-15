# ================================================================================================================================== 
# 
# Script to collect a sample of Twitter Data for 2 minutes every hour for 1 week
# 
# ================================================================================================================================== 

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Install and Load ROAuth package
#---------------------------------------------------------------------------------------------------------------------------------------------------------

packages = c("ROAuth")
packages = packages[!(packages %in% installed.packages()[,"Package"])]
if (length(packages) > 0) 
{
  install.packages(packages)
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Install and Load Developer version of streamR from https://github.com/pablobarbera/streamR
#---------------------------------------------------------------------------------------------------------------------------------------------------------

if(!require(devtools)) {
  install.packages("devtools"); require(devtools)} 

library(devtools)
install_github("streamR", "pablobarbera", subdir = "streamR")  # from GitHub
library(streamR)

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Define Twitter Credentials and save to my_oauth.Rdata file
#---------------------------------------------------------------------------------------------------------------------------------------------------------

library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "UMHqEEONpSIiuMD1Dt3jxMpeR"
consumerSecret <- "kX8WqbnGwRlzlTlxWVoPkcJQQC4oieJUbzoMYObES1K3SawZIw"
my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
                             requestURL = requestURL, accessURL = accessURL, authURL = authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(my_oauth, file = "oauth.Rdata")

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Loading Twitter credentials
#---------------------------------------------------------------------------------------------------------------------------------------------------------

load("oauth.Rdata")
setwd("C:/Users/claremc.EUROPE/OneDrive/NCI/Programming/ADM")

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Function defines the time to suspend execution between collection times
#---------------------------------------------------------------------------------------------------------------------------------------------------------

pause <- function(x)
{
  p1 <- proc.time()
  Sys.sleep(x)
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Collect tweets worldwide for 2 minutes, then suspends for 58 minutes. Each 2 minute burst is saved to a new JSON file. 
# Data was collected from 6th November until 14th November
#---------------------------------------------------------------------------------------------------------------------------------------------------------

i=0
while(Sys.Date() < "2017-11-14")
{
  i=i+1
  filterStream( file=paste0("tweets_World",i,".json"),
                locations = c(-160, -85, 175, 85), timeout=120, oauth=my_oauth)
                pause(3480)
}

