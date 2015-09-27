require 'elasticsearch/persistence'



class Area < ActiveRecord::Base

  # after_create: rake_job
  validates :latitude, uniqueness: { scope: [:latitude, :longitude,:radius] }

  # find existing value  
  def self.find_lat_lon(area)
    puts area.inspect
    area = Area.where(:latitude=>area.latitude, :longitude=>area.longitude,:radius=>area.radius)
      if(area!=nil)
        return area.first
      end
      return area    
  end
  
  def tweets
    
    
  end
  
  
end
