require "net/http"
require "active_support"
require "minitest/autorun"

class TestMaps < MiniTest::Unit::TestCase

  def test_95032_11206_car_distance_is_4746
    assert_equal true, 4746 == Maps.new(95032, 11206, "car").distance
  end 

  def test_97203_12345_bicycle_duration_is_1_day_19_hours
    assert_equal true, "1 day 19 hours" == Maps.new(97203, 12345, "bicycle").duration
  end

end
  
class Maps

  def initialize(from="95032", to="11206", mode="car")
    get_url(from, to, mode)
    @mode = mode
  end 

  def get_url(from, to, mode)
    url = "http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{from}&destinations=#{to}&mode=#{mode}&sensor=false"
    response = Net::HTTP.get(URI(url))
    parse_json(response)
  end

  def parse_json(response)
    @decoded_response =  ActiveSupport::JSON.decode(response)
  end

  def distance
    @decoded_response["rows"].
        first["elements"].first["distance"]["value"]/1000
  end

  def duration
    @decoded_response["rows"].
        first["elements"].first["duration"]["text"]
  end

  def pretty
    duration = @decoded_response["rows"].first["elements"].first["duration"]["text"]
    distance = @decoded_response["rows"].first["elements"].first["distance"]["value"]
    distance_in_miles = (distance * 0.000621371).to_i
    from_full_name = @decoded_response["destination_addresses"].first
    to_full_name = @decoded_response["origin_addresses"].first
    
    puts "Directions to: #{to_full_name} \n\n" 
    puts "From: #{from_full_name} \n\n"
    puts "The trip will take: #{duration} \n\n"
    puts "You will travel: #{distance_in_miles} miles by #{@mode}"

  end

end