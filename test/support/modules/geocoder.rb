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

Geocoder::Lookup::Test.add_stub( # stub for standard FactoryGirl address
  'Foobar 1, 12345 Berlin Berlin', [
    {
      'latitude'  => 1,
      'longitude' => 1
    }
  ]
)

Geocoder::Lookup::Test.add_stub( # stub for non-existant location queries
  'Bielefeld', [
    {
      'latitude'  => nil,
      'longitude' => nil
    }
  ]
)
