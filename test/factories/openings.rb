FactoryGirl.define do
  factory :opening do
    day { Opening.enumerized_attributes.attributes['day'].values.sample }
    open { rand(0.0..24.0).hours.from_now }
    close { open + rand(0.0..3.0).hours }
  end
end
