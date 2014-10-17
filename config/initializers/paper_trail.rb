# config/initializers/paper_trail.rb

module PaperTrail
  module Rails
    class Engine < ::Rails::Engine
      paths['app/models'] << 'lib/paper_trail/frameworks/active_record/models'
    end
  end
end

if defined?(::Rails::Console)
  PaperTrail.whodunnit = "#{`whoami`.strip}: console"
elsif File.basename($0) == "rake"
  PaperTrail.whodunnit = "#{`whoami`.strip}: rake #{ARGV.join ' '}"
end

# the following line is required for PaperTrail >= 3.1.0 with Rails
PaperTrail::Rails::Engine.eager_load!

