namespace :elastic_tweet do
  require 'tweetstream'
  require 'time'
  require 'json'
  require 'elasticsearch/persistence'
  
 # https://www.elastic.co/guide/en/elasticsearch/guide/current/lat-lon-formats.html
 
 task :streamTweetsToSearch => :environment do
   # TweetStream::Client.new.track('weather')  do |status|
   #TODO
   #we'll get it from collection of what user typed before later.
   #FOR NOW, using hard-coded value to make sure data pipelines are setup correctly.
   #cast to Tweet object that has only fields that we care about

   
   repository = Tweet.repository
   
   #get all area locations
   # locations =Area.all.map{|a| [a.longitude.round,a.latitude.round]}.uniq.flatten
   # locations = locations.concat mainCities
   # newyork=40.71427, longitude=-74.00597 NEW YORK CITY
   #start tracking main cities for now
   locations= -123.044,36.846,-121.591,38.352,-74,40,-73,41#,-74.00597,40.71427,-87.6847,41.8369
   # locations = -122, 37, -74, 41, -124, 32, -80, 40, -73, 40
   starttime = DateTime.now
   #san francisco,CA
   # locations =  -123.044,36.846,-121.591,38.352  
   cycle = 0
   TweetStream::Client.new.locations(locations) do |tweet|    
    puts "#new tweets #{tweet.text}"
    tweetwrap = Tweet.new
    tweetwrap.mapFromStream(tweet)
    repository.save(tweetwrap)
    cycle++
    #refresh index every 300 tweets
    if(cycle>300)
      repository.refresh_index! force: true
      cycle = 0
    end
    if(DateTime.now > starttime+15.minutes)
      #heroku will start new job with new locations so break 
      break
    end
   end
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