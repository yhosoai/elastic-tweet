class TweetsController < ApplicationController
  require 'tweetstream'
  require 'time'

  TweetStream.configure do |config|  
    # Consumer Key (API Key)  DDu2K4NbcPU1n2Fe8K4XrHm5Q
    # Consumer Secret (API Secret)  oA3QUbDRj3nrYUgmnzRBWW58mpNbiPZSibyM4y8gqtQyio2ZRb
    # Access Token  14097834-KItFVh6cdr7SjPXDNv3qG5abTtPEnR4kKhajR7K32
    # Access Token Secret  W9Jd4PobiWhgQ1G5WSzvVvVjMn4BACeMyZpt1Cvqdgh5B
    config.consumer_key       = 'DDu2K4NbcPU1n2Fe8K4XrHm5Q'
    config.consumer_secret    = 'oA3QUbDRj3nrYUgmnzRBWW58mpNbiPZSibyM4y8gqtQyio2ZRb'
    config.oauth_token        = '14097834-KItFVh6cdr7SjPXDNv3qG5abTtPEnR4kKhajR7K32'
    config.oauth_token_secret = 'W9Jd4PobiWhgQ1G5WSzvVvVjMn4BACeMyZpt1Cvqdgh5B'
    config.auth_method        = :oauth
  end  

  
  def index
    TweetStream::Client.new.track('stock') do |status|  
      puts "#{status.text}"
    end  
  end

end
