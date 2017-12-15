# twitternci
NCI project - collecting Twitter Data
---------------------------------------------------------------------------------


Using R code
---------------------------------------------------------------------------------
Step 1
  Collecting Twitter Data using R script.
  Data is collected for 2 minutes every hour and saved to a JSON file.
  
  File: '1 - GetTweets.R'

Step 2
  Convert large JSON files to CSV files
  
  File: '2 - CleanTweets.R'

Importing into MySQL
---------------------------------------------------------------------------------
Step 3 
  In UBuntu in the home directory run:
  mysql -u root -ppassword < tweetSQL.text - note 'password' shoudl be replaced with your MySQL password.
  
File: 'tweetSQL.txt'


Importing into HBase
---------------------------------------------------------------------------------
Step 4
   In HBase create an empty table in HBase with the column family 'user_info'.
   
   create 'tweets', {NAME=>'user_info'}
   
   Then use SQOOP import
   - note 'password' should be replaced with your MySQL password.
  
    sqoop import --connect jdbc:mysql://localhost/twitterStaging? --username root--password password --driver com.mysql.cj.jdbc.Driver  --table tweets --hbase-table tweets
--column-family user_info --hbase-row-key id -m 1






