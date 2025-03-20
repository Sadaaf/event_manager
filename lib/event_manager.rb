puts 'Event Manager Initialized'

# Check if the file exists
# puts File.exist?('event_attendees.csv')

# Read the file
# contents = File.read('event_attendees.csv')
# puts contents

# Read the file line by line
lines = File.readlines('event_attendees.csv')
lines.each_with_index do |line, index|
  next if index == 0
  puts line.split(',')[2]
end