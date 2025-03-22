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
require 'erb'
require 'time'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,'0')[0..4]
end

def clean_phone_number(phone_number)
  phone_number = phone_number.to_s.gsub(/\D/, '')
  if phone_number.length == 10
    phone_number
  elsif phone_number.length == 11 && phone_number[0] == '1'
    phone_number = phone_number[1..10]
  else
    phone_number = '0000000000'
  end
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
    rescue
      legislator_name = 'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

def save_thank_you_letter(id, form_letter)
  file_name = "output/thanks_#{id}.html"
  Dir.mkdir('output') unless Dir.exist?('output')
  File.open(file_name, 'w') do |file|
    file.puts form_letter
  end
end

def save_registration_time(registration_time)
  file_name = 'output/registration_times.txt'
  Dir.mkdir('output') unless Dir.exist?('output')
  File.open(file_name, 'a') do |file|
    file.puts registration_time.strftime("%H:%M")
  end
end

def find_registration_time(registration_date)
  registration_date = Time.parse(registration_date.split(' ')[1])
end

contents.each do |row|
  id = row[0]
  registration_date = row[:regdate]
  name, zipcode, phone_number = row[:first_name] ,row[:zipcode], row[:homephone]
  zipcode = clean_zipcode(zipcode)
  phone_number = clean_phone_number(phone_number)
  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)
  registration_time = find_registration_time(registration_date)
  save_registration_time(registration_time)
  save_thank_you_letter(id, form_letter)
end
