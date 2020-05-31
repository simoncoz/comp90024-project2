import tweepy
import sys
import os
import couchdb
import json
from tweepy import OAuthHandler
from tweepy import API
from tweepy import Stream
from tweepy.streaming import StreamListener

#override tweepy.StreamListener to add logic to on_status
class Listener(StreamListener):
    def __init__(self, output_file=sys.stdout):
        super(Listener,self).__init__()
        self.output_file = output_file

    # called when a tweet is downloaded    
    def on_status(self, tweet):
        json_tweet = tweet._json
        print(json_tweet)
        db.save(json_tweet)

    # handle errors caused by the API
    def on_error(self, status_code):
        print(status_code)
        return False


#Define filter terms
filterTerms = ["holadiho"]

# Twitter auth - #TODO change to env vars 
CONSUMER_KEY = 'SCUhOySMXyXfwi2G4WcnzF18i'
CONSUMER_SECRET = 'n5oIIuFnbDjkzZ4YL3b6xuQ57cEVCjPJajVmMa5842q373mgqi'
ACCESS_TOKEN = '1256415422137556993-jxEOTaE1r2p7x5HlRitpIYQRRjSRoz'
ACCESS_SECRET = 'YtLvVQmlvLLzLnLlWZth64qkvOGumfoVEf1mbdhimU8v0'

auth = OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(ACCESS_TOKEN, ACCESS_SECRET)

api = API(auth, wait_on_rate_limit=True,
				   wait_on_rate_limit_notify=True)

# CouchDB auth
env_user = os.environ.get('user')
env_pass = os.environ.get('pass')
print(f"http://{env_user}:{env_pass}@127.0.0.1:5984/")


# Connect to couchDB
try:
    couch = couchdb.Server(f"http://{env_user}:{env_pass}@127.0.0.1:5984/")
    db = couch['tweetsdb']
except:
    print("Can't connect to CouchDB Server ...Exiting")
    print("----_Stack Trace_-----")
    raise

places = api.geo_search(query="Australia", granularity="country")
place_id = places[0].id

myStreamListener = Listener()
stream = Stream(auth=api.auth, listener=myStreamListener)

try:
    print('Stream starting')
    stream.filter(track=["Trump", "Django", "Tweepy"] )
except KeyboardInterrupt as e :
    print("Stopped by user")
finally:
    print('Done')
    stream.disconnect()