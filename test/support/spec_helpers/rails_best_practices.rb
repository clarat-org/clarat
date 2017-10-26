# Check for best practices
def rails_best_practices
  bp_analyzer = RailsBestPractices::Analyzer.new(Rails.root)
  bp_analyzer.analyze

  # Console output:
  bp_analyzer.output

  # Generate HTML as well:
  options = bp_analyzer.instance_variable_get :@options
  bp_analyzer.instance_variable_set :@options, options.merge('format' => 'html')
  bp_analyzer.output

  exit 1 if bp_analyzer.runner.errors.size > 0
end
