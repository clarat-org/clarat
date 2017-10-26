require 'json'

# Check code style
def rubocop
  output = %x( bundle exec rake test:rubocop )
  result = JSON.parse output

  offense_count = result['summary']['offense_count']

  unless offense_count == 0
    result['files'].each do |file|
      next if file['offenses'].empty?
      puts rubocop_format(file)
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

def rubocop_format obj
  output = ''

  obj['offenses'].each do |offense|
    output += 'Offense in '.red
    output += "#{obj['path']}:#{offense['location']['line']}:#{offense['location']['column']} ".blue
    output += offense['message']
    output += "\n"
  end

  output
end
