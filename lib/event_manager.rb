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
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
  zipcode = zipcode.to_s
  zipcode = zipcode.rjust(5,'0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    
    legislators = legislators.officials
  
    legislator_name = legislators.map(&:name).join(',')
    rescue
      legislator_name = 'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

template_letter = File.read('form_letter.html')

contents.each do |row|
  first_name, zipcode = row[:first_name] ,row[:zipcode]
  zipcode = clean_zipcode(zipcode)
  legislator_name = legislators_by_zipcode(zipcode)
  personal_letter = template_letter.gsub('FIRST_NAME', first_name).gsub('LEGISLATORS', legislator_name)
  puts personal_letter
end
