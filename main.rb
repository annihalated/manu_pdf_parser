require 'rubyXL'
require 'rubyXL/convenience_methods'
require 'pdf-reader'

reader = PDF::Reader.new("./files/M_Vijaya_vs_Chairman_and_Managing_Director_Singarea010574COM625429.pdf")

# Find all text between two phrases in a string
def find_text(string, phrase1, phrase2)
  string.split(phrase1).last.split(phrase2).first
end

x = 0
# loop through the filename of every file in a folder, and extract the text from each file, and iterate a variable x to count the number of files    

Dir.foreach('./files') do |filename|
    x+= 1
    next if filename == '.' or filename == '..'
    reader = PDF::Reader.new("./files/#{filename}")
    first_page=reader.page(1).text
    citation = first_page.match('^([^\s]+)')
    appellants = find_text(first_page, 'Appellants:', 'Vs.')
    respondents = find_text(first_page, 'Respondent:', 'Hon\'ble Judges/Coram:')
    if first_page.include?('Case Note:')
        casenote = find_text(first_page, 'Case Note:', 'JUDGMENT')
    else
        casenote = ''
    end
    puts "COUNT #{x}"
    # puts "----------------"
    puts "Citation: #{citation}"
    puts "Appellants: #{appellants}"
    puts "Respondents: #{respondents}"
    puts "Case Note: #{casenote}"
end 


# This is the worksheet stuff, we'll get to it soon enough
# ----------------------------------------------------------

# workbook = RubyXL::Parser.parse("./cases.xlsx")
# worksheet = workbook[0]
# cell = worksheet.cell_at('C21')
# puts "This document has #{pdf.pages.size} pages"
# puts cell.value