require "net/http"
require "active_support"
  
class ZipCode 
  def distance_calculator(from, to)
    uri = URI("http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{from}&destinations=#{to}&mode=bicycling&sensor=false")
    response = Net::HTTP.get(uri)
    parsed_response = ActiveSupport::JSON.decode(response)
    return parsed_response["rows"].first["elements"].first["distance"]["text"]
  end
end