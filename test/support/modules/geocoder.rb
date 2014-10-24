Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.add_stub(
"Berlin", [
  {
    'latitude'  => 52.520007,
    'longitude' => 13.404954
  }
 ]
)

Geocoder::Lookup::Test.add_stub(
"Foobar 1, 12345 Berlin Berlin", [
  {
    'latitude'  => 1,
    'longitude' => 1
  }
 ]
)
