# Repeatedly usable with rake db:fake
u = User.first or raise "run `rake db:seed` first"

unless ENV['ALGOLIA_ID'] && ENV['ALGOLIA_KEY']
  raise "needs environment variables for algolia"
end

class GeocodingWorker
  def self.perform_async *attrs
    true
  end
end

puts "Before: Offer count #{Offer.count}"
10.times do
  begin
    FactoryBot.create :offer, :approved, :with_dummy_translations,
                       approved_by: u, fake_address: true
  rescue ActiveRecord::RecordInvalid
    puts "Offer data are randomly repeating"
  end
end
Offer.reindex!
puts "After: Offer count #{Offer.count}"
