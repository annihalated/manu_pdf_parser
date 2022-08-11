require 'pdf-reader'
require 'axlsx'
def find_text_between(string, phrase1, phrase2)
  string.split(phrase1).last.split(phrase2).first
end
x = 0 

results = []
Dir.foreach('./files') do |filename|
  next if filename == '.' or filename == '..'
  x = x + 1

  reader = PDF::Reader.new("./files/#{filename}")
  
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

Axlsx::Package.new do |p|
  p.workbook.add_worksheet(:name => "Cases") do |sheet|
    results.each do |result|
      sheet.add_row(result)
    end
  end
  p.serialize('output.xlsx')
end  