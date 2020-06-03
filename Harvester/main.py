#  Copyright (c) 2020.
#  Group 49, Melbourne
#  Simon Cozens 1071589
#  Solmaz Maabi 871603
#  Wenkang Dang 1009151

import tweepy
import sys
import os
import couchdb


from tweepy import OAuthHandler

# Twitter auth - #TODO change to env vars - they should NOT be in the code 
consumer_key = 'SCUhOySMXyXfwi2G4WcnzF18i'
consumer_secret = 'n5oIIuFnbDjkzZ4YL3b6xuQ57cEVCjPJajVmMa5842q373mgqi'
access_token = '1256415422137556993-jxEOTaE1r2p7x5HlRitpIYQRRjSRoz'
access_secret = 'YtLvVQmlvLLzLnLlWZth64qkvOGumfoVEf1mbdhimU8v0'

auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)

api = tweepy.API(auth, wait_on_rate_limit=True,
				   wait_on_rate_limit_notify=True)

# CouchDB auth
env_user = os.environ.get('user')
env_pass = os.environ.get('pass')
print(f"http://{env_user}:{env_pass}@127.0.0.1:5984/")
couch = couchdb.Server(f"http://{env_user}:{env_pass}@127.0.0.1:5984/")
db = couch['tweetsdb']

# These values should be taken in as args in a future iteration
places = api.geo_search(query="Australia", granularity="country")
place_id = places[0].id

maxTweets = 50000 # Some arbitrary large number


max_id = -1
tweetCount = 0
print("Downloading max {0} tweets".format(maxTweets))

# Need to handle API rate limiting in this loop.
while tweetCount < maxTweets:
    try:
      if (max_id <= 0):
        tweets = api.search(q="place:%s" % place_id)
      else:
        tweets = api.search(q="place:%s" % place_id,max_id=str(max_id - 1))
      for tweet in tweets:
        place = tweet.place.name if tweet.place else "Undefined place"
        doc = {'id': str(tweetCount+1), 'text': tweet.text, 'location': place, 'lang': tweet.lang} 
        print(doc['id'])
        db.save(doc)
      tweetCount += len(tweets)
      print("Downloaded {0} tweets".format(tweetCount))
      if len(tweets)==0:
        max_id = -1
      else:
        max_id = tweets[-1].id
    except tweepy.TweepError as e:
      print("some error : " + str(e))
      break
