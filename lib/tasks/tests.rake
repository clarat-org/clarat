namespace :test do
  desc 'Run a Brakeman security audit'
  task :brakeman do
    system 'brakeman -z --summary -f json -q --ignore-model-output'
    # remove --ignore-model-output once we take user generated model input
  end

  desc 'Run a Rubocop code style check'
  task :rubocop do
    system 'rubocop --format json'
  end
end
