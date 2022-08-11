require 'pdf-reader'
require 'csv'

def find_text_between(string, phrase1, phrase2)
  string.split(phrase1).last.split(phrase2).first
end
x = 0 

results = []
Dir.glob('./files/*') do |filename|
  next if filename == '.' or filename == '..'
  x = x + 1
  
  reader = PDF::Reader.new(filename)
  
  text = reader.pages.map {|page| page.text}
  text = text.join
  citation = text.match('^([^\s]+)')
  appellants = find_text_between(text, 'Appellants:', 'Vs.')
  date_decided = find_text_between(text, 'Decided On:', 'Appellants:')
  respondents = find_text_between(text, 'Respondent:', "Hon\'ble Judges/Coram:\n")
  puts "----------------------------------------------------"
  if text.include?("Case Note:\n")
      puts "THE CASE NOTE HAS BEEN FOUND"
      if text.include?("ORDER\n")
          puts "THIS FILE IS AN ORDER"
          casenote = find_text_between(text, "Case Note:\n", "ORDER\n")
      elsif text.include?("JUDGMENT\n")
          puts "THIS FILE IS A JUDGMENT"
          casenote = find_text_between(text, "Case Note:\n", "JUDGMENT\n")
      end
  else
      casenote = 'COULD NOT FIND CASE NOTE'
  end
  puts "------------------------------------------------------"

  puts "#{x}: #{appellants} v. #{respondents} (#{citation}), #{date_decided}"
  puts "#{casenote}"
  current_result = [x, date_decided, citation, appellants, respondents, casenote]
  results.push(current_result)
end

# Put each item in results as a raw  in a CSV file, with result values in individual columns

CSV.open("results.csv", "wb") do |csv|
  csv << ["File Number", "Date Decided", "Citation", "Appellants", "Respondents", "Case Note"]
  results.each do |result|
    csv << result
  end
end