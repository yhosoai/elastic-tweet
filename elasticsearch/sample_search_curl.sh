#1. search with area info

curl -XGET 'http://paas:db71af800adf05b16dab2e61d2e5d715@fili-us-east-1.searchly.com:80/twitter/tweet/_search?pretty' -d '{
              "query": {
                "filtered" : {
                    "query" : {
                        "match" : {
						"hashtags": "bloodmoon"
					}
                   },
                    "filter" : {
                        "geo_distance" : {
                            "distance" : "200km",
                            "location" : {
                                "lat" : 40,
                                "lon" : -73
                            }
                        }
                    }
                }
               },
                "sort": [
                       { "created_at":   { "order": "desc" }}
                   ]
          }'
		  {  
		     "query":{  
		        "filtered":{  
		           "query":{  
		              "match_all":{  

		              }
		           },
		           "filter":{  
		              "geo_distance":{  
		                 "distance":"200km",
		                 "location":{  
		                    "lat":40.0,
		                    "lon":-73.0
		                 }
		              }
		           }
		        }
		     },
		     "sort":[  
		        {  
		           "created_at":{  
		              "order":"desc"
		           }
		        }
		     ]
		  }
		  
curl -XGET 'http://paas:db71af800adf05b16dab2e61d2e5d715@fili-us-east-1.searchly.com:80/twitter/tweet/_search?pretty' -d '{"query":{"filtered":{"query":{"match_all":{}},"filter":{"geo_distance":{"distance":"200km","location":{"lat":40.0,"lon":73.0}}}}},"sort":[{"created_at":{"order":"desc"}}]}'

#expect to match
#location":{"lon":-73.270527,"lat":40.825276},
#hashtags :["bloodmoon","lunareclipse","moon","space","newyork","longisland"]
		  # 2015-09-27 19:42:42 -0700: > {"id":648326782257487872,"text":"Blood moon and lunar eclipse #bloodmoon #lunareclipse #moon #space #newyork #longisland @ Smithtown,… https://t.co/kGCpcnAa7t","created_at":"2015-09-27T19:42:04.000-07:00","location":{"lon":-73.270527,"lat":40.825276},"geoshape_location":{"coordinates":[[-73.270527,40.825276],[-73.270527,40.895739],[-73.168645,40.895739],[-73.168645,40.825276]],"type":"linestring"},"hashtags":["bloodmoon","lunareclipse","moon","space","newyork","longisland"]}



-79.76259,"lat":40.477383
#1. search with area info & hashtags.


2015-09-27 18:34:40 -0700: > {"id":648308951461728256,"text":"Sometimes u have to unfollow people in real life!","created_at":"2015-09-27T18:31:13.000-07:00","location":{"lon":-124.482003,"lat":32.528832},"geoshape_location":{"coordinates":[[-124.482003,32.528832],[-124.482003,42.009519],[-114.131212,42.009519],[-114.131212,32.528832]],"type":"linestring"}}
