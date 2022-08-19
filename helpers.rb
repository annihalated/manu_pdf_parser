require 'csv'
require 'pdf-reader'

def find_text_between(string, phrase1, phrase2)
  string.split(phrase1).last.split(phrase2).first
end

def count_files(folder)
  Dir[File.join(folder, '**', '*')].count { |file| File.file?(file) }
end

def get_full_text(file)
  reader = PDF::Reader.new(file)
  text = reader.pages.map {|page| page.text}
  text.join
end

def save_to_csv(data, output_file)
  CSV.open(output_file, "wb") do |csv|
    csv << ["Date Decided", "Citation", "Appellants", "Respondents", "Case Note"]
    data.each do |item|
      csv << item
    end
  end
end

def get_casenote(text)
  if text.include?("Case Note:\n")
    if text.include?("ORDER\n")
      casenote = find_text_between(text, "Case Note:\n", "ORDER\n")
    elsif text.include?("JUDGMENT\n")
      casenote = find_text_between(text, "Case Note:\n", "JUDGMENT\n")
    end
  else
    casenote = 'COULD NOT FIND CASE NOTE'
  end

  casenote
end
