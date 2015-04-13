# Handler for geolocations and easy transformation to different formats.
class Geolocation
  attr_reader :latitude, :longitude

  # takes either an object that responds to #latitude and #longitude, or both
  # of those as separate floating point parameters, or a string containing
  # them comma separated
  def initialize *attrs
    # if attrs[0].is_a? Float
    #   @latitude = attrs[0]
    #   @longitude = attrs[1]
    # els
    if attrs[0].is_a? String
      @latitude, @longitude = attrs[0].split(',')
    else
      @object = attrs[0]
      @latitude = @object.latitude
      @longitude = @object.longitude
    end
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
