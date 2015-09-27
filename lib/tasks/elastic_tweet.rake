namespace :elastic_tweet do
  require 'tweetstream'
  require 'time'
  require 'json'
  require 'elasticsearch/persistence'
  repository = Elasticsearch::Persistence::Repository.new
  
  TweetStream.configure do |config|
    config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
    config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
    config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
    config.auth_method        = :oauth
  end

  
 task :streamToElasticSearch => :environment do
   # TweetStream::Client.new.track('weather')  do |status|
   #TODO
   #we'll get it from collection of what user typed before later.
   #FOR NOW, using hard-coded value to make sure data pipelines are setup correctly.
   #cast to Tweet object that has only fields that we care about
   
   locations = -123.044,36.846,-121.591,38.352
   TweetStream::Client.new.locations(locations) do |tweet|
     puts "new tweet :#{tweet.text}"
   end
 end 
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

end
