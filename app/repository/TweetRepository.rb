require 'base64'
class TweetRepository
  include Elasticsearch::Persistence::Repository

  @repository
  
  def initialize(options={})
    index  options[:index] || 'notes'
    client Elasticsearch::Client.new url: ENV['ELASTICSEARCH_URL'], log: true
    
    
    
  end

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
      indexes :location, type: 'geo_point', as: 'location'
      indexes :coordinates, type: 'geo_shape', as: 'geo_shape'
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

# -114.131212,42.009519
  
  def search
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
   
   
   
    results = repository.search(query: {
        filtered: {
            query: {
                match_all: {}
            },
            filter: {
                geo_shape: {
                    location: {
                        shape: {
                            type: "envelope",
                            coordinates: [[13.0, 53.0], [14.0, 52.0]]
                        }
                    }
                }
            }
        }
    })
    
    #case 2
        results = repository.search(query: {
            geo_shape: {
                geoshape: {
                    shape: {
                        type: "envelope",
                        coordinates: [[13.0, 53.0], [14.0, 52.0]]
                    }
                }
            }
        })
    # Iterate over the objects
    #
    results.each do |note|
      puts "* #{note.attributes[:text]}"
    end
    
  end
  
end