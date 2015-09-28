#reinitialize
# http://localhost:9200
# local http://localhost:9200
curl -XDELETE 'http://localhost:9200/twitter/'
curl -XPUT 'http://localhost:9200/twitter/'
#
#set mapping
curl -XPUT 'http://localhost:9200/twitter/tweet/_mapping' -d '
{    
    "tweet" : {
    	"dynamic": "true",
        "properties" : {        
      	  "text" : { "type" : "string" },        
      	  "hashtags" : { "type" : "string" },        
        "location": {
                "type" : "geo_point",
	            "geohash_prefix": true,
	            "geohash_precision": 6				
        },
		  "geoshape_location" : { "type" : "geo_shape" ,"tree":"quadtree"}        
        }
    }
}'
  
#set refresh interval
curl -XPUT http://localhost:9200/twitter/_settings -d '{
    "index" : {
        "refresh_interval" : "10s"
    } 
}' 

curl -XPUT http://localhost:9200/twitter/tweet/_settings -d '{
    "index" : {
        "refresh_interval" : "10s"
    } 
}'  

