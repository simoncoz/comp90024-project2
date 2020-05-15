import tweepy
import sys
import os
import couchdb

from tweepy import OAuthHandler
 
consumer_key = 'SCUhOySMXyXfwi2G4WcnzF18i'
consumer_secret = 'n5oIIuFnbDjkzZ4YL3b6xuQ57cEVCjPJajVmMa5842q373mgqi'
access_token = '1256415422137556993-jxEOTaE1r2p7x5HlRitpIYQRRjSRoz'
access_secret = 'YtLvVQmlvLLzLnLlWZth64qkvOGumfoVEf1mbdhimU8v0'

auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)

api = tweepy.API(auth, wait_on_rate_limit=True,
				   wait_on_rate_limit_notify=True)

couch = couchdb.Server('http://wenkang:010709@localhost:5984/')
db = couch['tweetsdb']

places = api.geo_search(query="Australia", granularity="country")
place_id = places[0].id

maxTweets = 50000 # Some arbitrary large number
fName = 'tweets7.txt' # We'll store the tweets in a text file.

max_id = -1
tweetCount = 0
print("Downloading max {0} tweets".format(maxTweets))
with open(fName, 'w', encoding='utf-8') as f:
  while tweetCount < maxTweets:
    try:
      if (max_id <= 0):
        tweets = api.search(q="place:%s" % place_id)
      else:
        tweets = api.search(q="place:%s" % place_id,max_id=str(max_id - 1))
      for tweet in tweets:
        place = tweet.place.name if tweet.place else "Undefined place"
        # doc = {'id': str(tweetCount+1), 'text': tweet.text, 'location': place, 'lang': tweet.lang}
        # doc = {'_id': '1', 'text': 't', 'location': 'place', 'lang': 'tweet'}
        # print(doc['id'])
        # db.save(doc)
        f.write(tweet.text + "\n" + place)
        f.write("\n"+tweet.lang + "\n")
      tweetCount += len(tweets)
      print("Downloaded {0} tweets".format(tweetCount))
      if len(tweets)==0:
        max_id = -1
      else:
        max_id = tweets[-1].id
    except tweepy.TweepError as e:
      print("some error : " + str(e))
      break
