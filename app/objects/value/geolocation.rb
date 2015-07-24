# Handler for geolocations and easy transformation to different formats.
class Geolocation
  attr_reader :latitude, :longitude

  # @attr object has to respond to #latitude and #longitude
  def initialize object
    @object = object
    @latitude = @object.latitude
    @longitude = @object.longitude
  end

  def to_s
    return nil unless complete?
    "#{@latitude},#{@longitude}"
  end

  # not needed anymore? #
  # def to_json
  #   return nil unless complete?
  #   "{\"latitude\":#{@latitude},\"longitude\":#{@longitude}}"
  # end

  def to_h
    return nil unless complete?
    { latitude: @latitude, longitude: @longitude }
  end

  def complete?
    @latitude && @longitude
  end

  # only compare latitude and longitude
  def == other
    @latitude == other.latitude && @longitude == other.longitude
  end
end
