# Handler for geolocations
class Geolocation
  # takes either an object that responds to #latitude and #longitude, or both
  # of those as separate parameters
  def initialize *attrs
    if attrs[0].is_a? Float
      @latitude = attrs[0]
      @longitude = attrs[1]
    else
      @object = attrs[0]
      @latitude = @object.latitude
      @longitude = @object.longitude
    end
  end

  def to_s
    "#{@latitude},#{@longitude}"
  end

  def to_json
    "{\"latitude\": #{@latitude}, \"longitude\": #{@longitude}}"
  end
end
