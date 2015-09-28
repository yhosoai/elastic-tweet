require 'json'

class Tweet

  # Define an `author` attribute, with multiple analyzers for this field
  attr_reader :attributes
  def self.querystr
    
    querystr = '{
      "query": {
        "filtered" : {
            "query" : {
                "match_all" : {}
            },
            "filter" : {
                "geo_distance" : {
                    "distance" : "2000km",
                    "location" : {
                        "lat" : -122,
                        "lon" : 37
                    }
                }
            }
        }
       },
        "sort": [
               { "created_at":   { "order": "desc" }}
           ]
    }'
    return querystr
  end
  
  def mapFromStream(stream={})
    @attributes = {:id=>stream.id,:text=>stream.full_text,:created_at=>stream.created_at}
    #this is not accessible from object, so cannot be used... :coordinates =>stream.coordinatess
    if(!stream.place.nil? && !stream.place.bounding_box.nil? && !stream.place.bounding_box.coordinates.nil?)
       #take first array as location for this geo point
       @attributes[:location] =  {:lon=>stream.place.bounding_box.coordinates.first.first[0],:lat=>stream.place.bounding_box.coordinates.first.first[1]}
       #GeoJson expect Lon, Lat order, and twitter coordinates is in Lon, Lat order also
       @attributes[:geoshape_location] = {:coordinates=>stream.place.bounding_box.coordinates.first,:type=>'linestring'}
    end
    
    if(stream.hashtags.size()>0)
       @attributes[:hashtags]=stream.hashtags.map{|a|a.text}
    end
    
    # [{"text":"banana","indices":[28,35]},{"text":"cucumber","indices":[36,45]},{"text":"february","indices":[46,55]},{"text":"holiday","indices":[56,64]},{"text":"justinbeiber","indices":[65,78]}]
    # [{text:"banana"},{text:"banana"},{text:"banana"}]
  end
  def initialize(attributes={})
     @attributes = attributes
   end
  
  def to_hash
    @attributes
  end  #
 
  # 1. Enter the lat/long coordinates with an radius in a form
  # this will give us 4 coordinates. also try geocoder gem to see if it's more efficient. 
  # 2. See top 250 tweets within that area, sorted descendingly by time
  # 3. Additionally, tweets can be filtered within the above area with a specific hangtag (i.e.: #amazing, #super, #obama, etc)
  #https://dev.twitter.com/rest/reference/get/geo/reverse_geocode
  #https://www.elastic.co/guide/en/elasticsearch/guide/current/geo-shapes.html#geo-shapes
  #using elastic search geo-shape, filter by this.
  def self.showTweetsInArea(area)
    #TODO get it from TweetRepository instead. somehow it's not working
    # client Elasticsearch::Client.new url: ENV['ELASTICSEARCH_URL'], log: true

    repository = Elasticsearch::Persistence::Repository.new do
      client Elasticsearch::Client.new url: 'http://localhost:9200', log: true

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
    
    repository.search(query: {
        filtered: {
          query: {
            match_all: {}
          },
          filter:
            {
              geo_distance: 
              {distance: "200km",
               location:{
                lat: area.latitude, lon: area.longitude
                }
              }
            }
          }
      })
      
     
  end
  
  
  def self.createRepository
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
        super
      end
    end
    return repository
  end
  
end