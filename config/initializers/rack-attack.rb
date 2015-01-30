class Rack::Attack
  Rack::Attack.throttle(
    'location_api_requests/ip',
    limit: 20,
    period: 1.minute
  ) do |req|
    next unless req.path.match /\A\/search_locations\/.*\z/
    Digest::SHA1.hexdigest(req.ip) # anonymize IP
  end

  # Limit DOS?
  # Careful: each asset request also counts towards the limit
  # Rack::Attack.throttle('req/ip', limit: 30, period: 30.seconds) do |req|
  #   Digest::SHA1.hexdigest(req.ip)
  # end
end
