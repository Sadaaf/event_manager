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

def clean_zipcode(zipcode)
  if zipcode.nil?
    zipcode = '00000'
  elsif zipcode.length < 5
    zipcode = zipcode.rjust(5,'0')
  elsif zipcode.length > 5
    zipcode = zipcode[0..4]
  end
  zipcode
end

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
contents.each do |row|
  first_name, zipcode = row[:first_name] ,row[:zipcode]
  zipcode = clean_zipcode(zipcode)
  puts "#{first_name} #{zipcode}"
end