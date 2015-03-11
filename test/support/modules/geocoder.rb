Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.add_stub( #! exists as fixture
  'Berlin', [
    {
      'latitude'  => 52.520007,
      'longitude' => 13.404954
    }
  ]
)

Geocoder::Lookup::Test.add_stub( # stub for non-fixture location query
  'Foobar', [
    {
      'latitude'  => 10,
      'longitude' => 20
    }
  ]
)

# use above stub for any Location#geocode calls
class Location
  geocoded_by :_alt_addr
  def _alt_addr
    'Foobar'
  end
end

Geocoder::Lookup::Test.add_stub( # stub for non-existant location queries
  'Bielefeld', [
    {
      'latitude'  => nil,
      'longitude' => nil
    }
  ]
)
