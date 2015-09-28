
curl -XPUT 'http://paas:db71af800adf05b16dab2e61d2e5d715@fili-us-east-1.searchly.com:80/twitter/tweet/_mapping' -d '
{    
    "tweet" : {
    	"dynamic": "true",
        "properties" : {        
      	  "text" : { "type" : "string" },        
      	  "hashtags" : { "type" : "string" },        
        "location": {
                "type" : "geo_point"
        },
		  "geoshape_location" : { "type" : "geo_shape" ,"tree":"quadtree"}        
        }
    }
}'
  
  
curl -XPUT http://paas:db71af800adf05b16dab2e61d2e5d715@fili-us-east-1.searchly.com:80/twitter/_settings -d '{
    "index" : {
        "refresh_interval" : "1s"
    } }'  

