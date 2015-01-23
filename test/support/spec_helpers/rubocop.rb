require 'json'

# Check code style
def rubocop
  puts "\n\n[Rubocop] Checking Code Style:\n".underline
  output = %x( bundle exec rake test:rubocop )
  result = JSON.parse output

  offense_count = result['summary']['offense_count']

  unless offense_count == 0
    result['files'].each do |file|
      next if file['offenses'].empty?
      puts format(file)
    end
  end

  if offense_count == 0
    puts 'Code styled well.'.green
  else
    puts "Offenses: #{offense_count}".red
    puts 'Suite failing due to code styling issues.'.red.underline
    exit 1
  end
end

def format obj
  # {
  #   "metadata": {
  #     "rubocop_version": "0.9.0",
  #     "ruby_engine": "ruby",
  #     "ruby_version": "2.0.0",
  #     "ruby_patchlevel": "195",
  #     "ruby_platform": "x86_64-darwin12.3.0"
  #   },
  #   "files": [{
  #       "path": "lib/foo.rb",
  #       "offenses": []
  #     }, {
  #       "path": "lib/bar.rb",
  #       "offenses": [{
  #           "severity": "convention",
  #           "message": "Line is too long. [81/80]",
  #           "cop_name": "LineLength",
  #           "corrected": true,
  #           "location": {
  #             "line": 546,
  #             "column": 80,
  #             "length": 4
  #           }
  #         }, {
  #           "severity": "warning",
  #           "message": "Unreachable code detected.",
  #           "cop_name": "UnreachableCode",
  #           "corrected": false,
  #           "location": {
  #             "line": 15,
  #             "column": 9,
  #             "length": 10
  #           }
  #         }
  #       ]
  #     }
  #   ],
  #   "summary": {
  #     "offense_count": 2,
  #     "target_file_count": 2,
  #     "inspected_file_count": 2
  #   }
  # }
  output = ''

  obj['offenses'].each do |offense|
    output += 'Offense in '.red
    output += "#{obj['path']}:#{offense['location']['line']}:#{offense['location']['column']} ".blue
    output += offense['message']
    output += "\n"
  end

  output
end
