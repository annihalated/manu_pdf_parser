require 'pdf-reader'
require 'axlsx'
# HMM, considering moving this whole thing to work with axlsx
def find_text(string, phrase1, phrase2)
  string.split(phrase1).last.split(phrase2).first
end
x = 0 

results = []
# Iterate through each file
Dir.foreach('./files') do |filename|
  # Dir.foreach returns the directory name and the pathname to the previous directory
  next if filename == '.' or filename == '..'
  x = x + 1

  reader = PDF::Reader.new("./files/#{filename}")
  
  text = reader.pages.map {|page| page.text}
  text = text.join
  citation = text.match('^([^\s]+)')
  appellants = find_text(text, 'Appellants:', 'Vs.')
  date_decided = find_text(text, 'Decided On:', 'Appellants:')
  respondents = find_text(text, 'Respondent:', "Hon\'ble Judges/Coram:\n")
  # Go to the judgment, 
  puts "----------------------------------------------------"
  if text.include?("Case Note:\n")
      puts "THE CASE NOTE HAS BEEN FOUND"
      if text.include?("ORDER\n")
          puts "THIS FILE IS AN ORDER"
          casenote = find_text(text, "Case Note:\n", "ORDER\n")
      elsif text.include?("JUDGMENT\n")
          puts "THIS FILE IS A JUDGMENT"
          casenote = find_text(text, "Case Note:\n", "JUDGMENT\n")
      end
  else
      casenote = 'COULD NOT FIND CASE NOTE'
  end
  puts "------------------------------------------------------"

  puts "#{x}: #{appellants} v. #{respondents} (#{citation}), #{date_decided}"
  puts "#{casenote}"
  current_result = [x, date_decided, citation, appellants, respondents, casenote]
  results.push(current_result)

  if x > 5
    break
  end
end

Axlsx::Package.new do |p|
  p.workbook.add_worksheet(:name => "Cases") do |sheet|
    results.each do |result|
      sheet.add_row(result)
    end
  end
  p.serialize('output.xlsx')
end  