puts 'Event Manager Initialized'

# Check if the file exists
# puts File.exist?('event_attendees.csv')

# Read the file
# contents = File.read('event_attendees.csv')
# puts contents

# Read the file line by line
# lines = File.readlines('event_attendees.csv')
# lines.each_with_index do |line, index|
#   next if index == 0
#   puts line.split(',')[2]
# end


# Use the csv library
require 'csv'
contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
contents.each do |row|
  first_name, zipcode = row[:first_name] ,row[:zipcode]
  # Check the zipcode length and add 0 if it is less than 5 and truncate if more than 5
  if zipcode.nil?
    zipcode = '00000'
  elsif zipcode.length < 5
    zipcode = zipcode.rjust(5,'0')
  elsif zipcode.length > 5
    zipcode = zipcode[0..4]
  end
  
  puts "#{first_name} #{zipcode}"
end