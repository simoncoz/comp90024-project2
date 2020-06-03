# Twitter Harvesters

## About
The script uses Twitter's search API to get tweets originating in Australia.

There is a rate limit on the number of API calls, such that the script stops with an error printed to the console after around 7000 tweets.

Tweets are inserted into the local couchdb instance in the `tweetsdb` database.

## Running the script
You can run the harvester by calling `python3 main.py`

## Viewing tweets
You can see the harvested tweets by checking couchdb's Fauxton interface at http://<nodeip>:5984/_utils where <nodeip> is the IP address of the instance hosting couchdb and the harvester.
  
# Streaming API Script
The file `streaming.py` is a script that cnnects to the Twitter Streaming API to open a long-lived connection and download tweets as they are uploaded to the platform.

Similar to the above script, tweets are posted to the local CouchDB instance and replicated by CouchDB to the other nodes in the cluster.

# Future Enhancements
- Run as a service/perpetually.
- Optimise the harvester to retrieve tweets in batches
- Get Twitter auth details from env vars rather than hard-coded.
