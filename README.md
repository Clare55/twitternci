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
Step 4a
   In HBase create an empty table in HBase with the column family 'user_info'.
   
   create 'tweets', {NAME=>'user_info'}
   
   Then use SQOOP import
   - note 'password' should be replaced with your MySQL password.
  
sqoop import --connect jdbc:mysql://localhost/twitterStaging
--username root--password password --driver com.mysql.cj.jdbc.Driver  --table tweets --hbase-table tweets
--column-family user_info --hbase-row-key id -m 1


Importing into HIVE
---------------------------------------------------------------------------------
Step 4b
Then use SQOOP import   - note 'password' should be replaced with your MySQL password.

sqoop import --connect jdbc:mysql://127.0.0.1/twitterStaging
--username root --password password
--driver com.mysql.cj.jdbc.Driver --table tweets --hive-import -m 1

Creating Views in HIVE (MapReduce)
---------------------------------------------------------------------------------
Step 5

In HIVE there were problems with the date format so first created a new table with a subset of variables and recasting the date.

CREATE TABLE tweetsbydateeverything as SELECT id, id_str, retweet_count, retweeted, cast(created_at AS DATE), in_reply_to_status_id, lang, user_id_str, user_lang, utc_offset, friends_count, country_code, place_type, place_lat, place_lon, lat, lon, hour

Number of unique Tweets by country by date by hour
CREATE VIEW vnumberbycountry AS SELECT count(id_str), country_code, created_at, hour FROM tweetsbydateeverything GROUP BY country_code, created_at, hour;
Counts numbers of tweets by country by date, by hour 

Then exported this as a CSV file
hive -e "select * from vnumberbycountry" | sed 's/[\t]/,/g' > numberbycountry.csv

The number of unique Tweeters by country by date by hour;
CREATE VIEW vnumberoftweetersbycountry AS SELECT count(DISTINCT(user_id_str), country_code, created_at, hour FROM tweetsbydateeverything GROUP BY country, created_at, hour;
Then exported this as a CSV file
hive -e "select * from vnumberoftweetersbycountry" | sed 's/[\t]/,/g' > distincttweetersbycountry.csv



