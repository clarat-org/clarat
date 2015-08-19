case Rails.env
when 'production'
  Rails.application.configure do
    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      r301 %r{.*}, 'http://www.clarat.org$&', if: Proc.new { |rack_env|
        rack_env['SERVER_NAME'] != 'www.clarat.org'
      }
    end
  end
when 'staging'
  Rails.application.configure do
    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      r301 %r{.*}, 'http://staging.clarat.org$&', if: Proc.new { |rack_env|
        rack_env['SERVER_NAME'] != 'staging.clarat.org'
      }
    end
  end
end
