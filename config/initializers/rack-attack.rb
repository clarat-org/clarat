class Rack::Attack
  Rack::Attack.throttle('location_api_requests/ip', limit: 20, period: 1.minute) do |req|
    req.ip if req.path.match /\A\/search_locations\/.*\z/
  end

  # Limit DOS?
  # Careful: each asset request also counts towards the limit
  # Rack::Attack.throttle('req/ip', limit: 30, period: 30.seconds) do |req|
  #   req.ip
  # end
end
