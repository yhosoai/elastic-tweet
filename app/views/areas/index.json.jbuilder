json.array!(@areas) do |area|
  json.extract! area, :id, :latitude, :longitude, :radius
  json.url area_url(area, format: :json)
end
