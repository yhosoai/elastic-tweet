class Tweet
  include Elasticsearch::Persistence::Model
  # attribute :title,  String

  # Define an `author` attribute, with multiple analyzers for this field
  #
  attribute :user, String
  
  attribute :text, String, presence: true

  # Define a `views` attribute, with default value
  # attribute :created_at,  DateTime

  # Validate the presence of the `title` attribute
  #
  attribute :url, String
  attribute :country, String
  attribute :country_code, String
  attribute :hashtags
  attribute :coordinates
  attribute :city
  attribute :source
  attribute :geo
  attribute :place_coordinates

  def self.createFromStream(twitterStreamResponse)
    t = Tweet.new
    t.id = twitterStreamResponse.id
    t.text = twitterStreamResponse.text
    t.user = twitterStreamResponse.user
    t.url = twitterStreamResponse.place.url
    t.geo = twitterStreamResponse.geo
    t.coordinates = twitterStreamResponse.coordinates
    t.place_coordinates = twitterStreamResponse.place.bounding_box.coordinates
    if(twitterStreamResponse.place.place_type=='city')
      t.city = twitterStreamResponse.place.name
    end
    t.country = twitterStreamResponse.place.url
    t.country_code = twitterStreamResponse.place.country_code
    t.hashtags = twitterStreamResponse.entities.hashtags    
    
    return t
  end

end
 #
# :place:
#   :id: 7d62cffe6f98f349
#   :url: https://api.twitter.com/1.1/geo/id/7d62cffe6f98f349.json
#   :place_type: city
#   :name: San Jose
#   :full_name: San Jose, CA
#   :country_code: US
#   :country: United States
#   :bounding_box:
#     :type: Polygon
#     :coordinates:
#     - - - -122.035311
#         - 37.193164
#       - - -122.035311
#         - 37.469154
#       - - -121.71215
#         - 37.469154
#       - - -121.71215
#         - 37.193164
#   :attributes: {}
# :contributors:
# :is_quote_status: false
# :retweet_count: 0
# :favorite_count: 0
# :entities:
#   :hashtags: []
#   :urls: []
#   :user_mentions: []
#   :symbols: []