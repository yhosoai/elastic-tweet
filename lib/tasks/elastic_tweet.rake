namespace :elastic_tweet do
  require 'tweetstream'
  require 'time'
  require 'json'
  require 'elasticsearch/persistence'
  
 # https://www.elastic.co/guide/en/elasticsearch/guide/current/lat-lon-formats.html
 
 task :streamToElasticSearch => :environment do
   # TweetStream::Client.new.track('weather')  do |status|
   #TODO
   #we'll get it from collection of what user typed before later.
   #FOR NOW, using hard-coded value to make sure data pipelines are setup correctly.
   #cast to Tweet object that has only fields that we care about
   repository = Elasticsearch::Persistence::Repository.new do
     client Elasticsearch::Client.new url: ENV['ELASTICSEARCH_URL'], log: true

     # Set a custom index name
     index :twitter

     # Set a custom document type
     type  :tweet

     # Specify the class to initialize when deserializing documents
     klass Tweet

     # Configure the settings and mappings for the Elasticsearch index
     settings number_of_shards: 1 do
       mapping do
         indexes :text,  analyzer: 'snowball'
         indexes :location, type: 'geo_point', as: 'coordinates'
         indexes :geoshape_location, type: 'geo_shape', as: 'coordinates'
         indexes :hashtags, analyzer: 'english'
       end
     end

     # Customize the serialization logic
     def serialize(document)
      super
     end

     def deserialize(document)
         puts "# ***** CUSTOM DESERIALIZE LOGIC KICKING IN... *****"
         super
       end
   end
   
   
   # locations = -123.044,36.846,-121.591,38.352

   #san francisco,CA
   locations =  -123.044,36.846,-121.591,38.352
   @t
   TweetStream::Client.new.locations(locations) do |tweet|
     puts "new tweet :#{tweet.text}"
     @t = tweet
     twr = Tweet.new
     twr.mapFromStream(@t)
     repository.save(twr)
   end
   

 end 
# -114.131212,42.009519
locations =  -123.044,36.846,-121.591,38.352
@t
TweetStream::Client.new.locations() do |tweet|
  puts "new tweet :#{tweet.text}"
  @t = tweet
  twr = Tweet.new
  twr.mapFromStream(@t)
  repository.save(twr)
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