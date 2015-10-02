namespace :elastic_tweet do
  require 'tweetstream'
  require 'time'
  require 'json'
  require 'elasticsearch/persistence'
   #http://boundingbox.klokantech.com/
  norcal = -122.9953,36.7602,-121.26,38.1593
  california = -124.39,32.95,-113.87,40.98
  america_continent= -172.3,-57.0,-15.9,69.9
  asia = 69.2,3.6,157.4,55.4
  world = -177.9,-55.1,-179.7,81.0
  ny =-74.46,40.32,-70.15,43.38
 # https://www.elastic.co/guide/en/elasticsearch/guide/current/lat-lon-formats.html
 def stream(bounding_box)
   Rails.application.eager_load!
   
   repository = Tweet.repository
 
   starttime = DateTime.now
   #san francisco,CA
   # locations =  -123.044,36.846,-121.591,38.352  
   cycle = 0
   TweetStream::Client.new.locations(bounding_box) do |tweet|    
    
    tweetwrap = Tweet.new
    tweetwrap.mapFromStream(tweet)
    repository.save(tweetwrap)
    cycle++
    #refresh index every 300 tweets
    if(cycle>300)
      repository.refresh_index! force: true
      cycle = 0
    end
    if(DateTime.now > starttime+60.minutes)
      #heroku will start new job with new locations so break 
      break
    end
   end
 end
 
 task :streamNorCalTweets => :environment do
   stream(norcal)
 end 
 task :streamCaliforniaTweets => :environment do
   stream(california)
 end 
 task :streamNYweets => :environment do
   stream(ny)
 end 
 task :streamAsiaTweets => :environment do
   stream(asia)
 end 
end

#
# curl -XPUT 'http://paas:db71af800adf05b16dab2e61d2e5d715@fili-us-east-1.searchly.com/twitter/tweet/1' -d '{
#     "user" : "kimchy",
#     "post_date" : "2009-11-15T14:12:12",
#     "message" : "trying out Elasticsearch"
# }'
#
# curl -XPOST 'http://paas:db71af800adf05b16dab2e61d2e5d715@fili-us-east-1.searchly.com/twitter' -d '{
#   "settings": {
#     "index": {
#       "mapping.allow_type_wrapper": true
#     }
#   }
# }'

 # t = Tweet.createFromStream(tweet)
 # repository.save(t)
 # logger.debug "saved :#{tweet.id}"
 
#
# def save(tweet)
#   Tweet t = Tweet.createFromStream(tweet)
#   repository.save(t)
#   puts "successfully saved #{t.text}"
# end
#
#  #GET geo/reverse_geocode (based on lat & lot)
#
#  def sample
#    @client = TweetStream::Client.new
#
#    @client.on_delete do |status_id, user_id|
#      Tweet.delete(status_id)
#    end
#
#    @client.on_limit do |skip_count|
#      # do something
#    end
#
#    @client.on_enhance_your_calm do
#      # do something
#    end
#
#    @client.track('intridea')
#    @client.track('intridea')
#
#  end
#
#   def testLocationAPI
#
#     TweetStream::Client.new.locations(-80.29,32.57,-79.56,33.09,-123.044,36.846,-121.591,38.352) do |tweet|
#           p "new tweet #{tweet.text}"
#           p tweet.to_yaml
#           p JSON.pretty_generate(tweet)
#     end
#
#   end
#   def stream(tracked)
#     tracked.each do |track|
#       tweets = 0
#       TweetStream::Client.new.track(track) do |t|
#         tweets += 1
#         if tweets > 1000
#           break
#         else
#           Tweet.create(:text => t.text)
#         end
#       end
#    end
#  end