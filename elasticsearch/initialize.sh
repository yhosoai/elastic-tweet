
curl -XPUT 'http://localhost:9200/twitter/tweet/_mapping' -d '
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
  
  
 #inserts some data.
  
  curl -XPUT 'http://localhost:9200/twitter/tweet/648062829321318401' -d '{"id":648062829321318401,"text":"日本語訳でゲームウォーズという名前で買えますよ。電子書籍もあります。 https://t.co/k044Sbybsn","hashtags":[],"created_at":"2015-09-27T02:13:13.000-07:00","location": {
        "type" : "point",
        "coordinates" : [-77.03653, 38.897676]
    }
	}'

PUT http://localhost:9200:80/twitter/tweet/648065520114102272 [status:400, request:0.178s, query:N/A]
2015-09-27 02:23:57 -0700: > {"id":648065520114102272,"text":"Oh and here you go goldy. ;) http://t.co/c3KZOIcGv7","hashtags":[],"created_at":"2015-09-27T02:23:55.000-07:00","location":[-122.514926,37.708075],"geoshape":{"coordinates":[[[-122.514926,37.708075],[-122.514926,37.833238],[-122.357031,37.833238],[-122.357031,37.708075]]],"type":"multipoint"}}

	curl -XPUT 'http://localhost:9200/twitter/tweet/1' -d '{"id":648054293010870272,"text":"When youre on the phone with bae \u0026amp; he tells you to calm down http://t.co/xtNar7D7Ag","hashtags":[],"created_at":"2015-09-27T01:39:18.000-07:00","location":[-122.069956,37.454962],  "geoshape" : {
	   "type" : "Polygon",
	    "orientation" : "clockwise",
        "coordinates" : [[[-124.482003,32.528832],[-124.482003,42.009519],[-114.131212,42.009519],[-114.131212,32.528832]]]
    }} '


	curl -XPUT 'http://localhost:9200/twitter/tweet/1' -d '{"id":648054293010870272,"text":"When youre on the phone with bae \u0026amp; he tells you to calm down http://t.co/xtNar7D7Ag","hashtags":[],"created_at":"2015-09-27T01:39:18.000-07:00","location":[-122.069956,37.454962],  "geoshape" : {
	   "type" : "Polygon",
	    "orientation" : "clockwise",
        "coordinates" : [[[-124.482003,32.528832],[-124.482003,42.009519],[-114.131212,42.009519],[-114.131212,32.528832]]]
    }} '
#somehow fails..
	{"error":"MapperParsingException[failed to parse [geoshape]]; nested: ElasticsearchParseException[Invalid LinearRing found (coordinates are not closed)]; ","status":400}Yutaka-Hosoais-MacBook-Air:elastic-tweet yhosoai$ 
	

