require 'rubyXL'
require 'rubyXL/convenience_methods'
require 'pdf-reader'
# HMM, considering moving this whole thing to work with axlsx
def find_text(string, phrase1, phrase2)
  string.split(phrase1).last.split(phrase2).first
end

x = 0

# Iterate through each file
Dir.foreach('./files') do |filename|
  # Dir.foreach returns the directory name and the pathname to the previous directory
  next if filename == '.' or filename == '..'
  x+= 1

  reader = PDF::Reader.new("./files/#{filename}")
  
  text = reader.pages.map {|page| page.text}
  text = text.join
  citation = text.match('^([^\s]+)')
  appellants = find_text(text, 'Appellants:', 'Vs.')
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

  puts "#{x}: #{appellants} v. #{respondents} (#{citation})"
  workbook = RubyXL::Parser.parse('./ouput.xlsx')

  worksheet = workbook[0]
  
  worksheet.sheet_data[x][0].change_contents(citation)
  worksheet.sheet_data[x][1].change_contents(appellants)
  worksheet.sheet_data[x][2].change_contents(respondents)
  worksheet.sheet_data[x][3].change_contents(casenote)

  workbook.write("./output.xlsx")

end