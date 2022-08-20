require 'csv'

def count_files(folder)
  Dir[File.join(folder, '**', '*')].count { |file| File.file?(file) }
end

def save_to_csv(data, output_file)
  CSV.open(output_file, "wb") do |csv|
    csv << ["Date Decided", "Citation", "Appellants", "Respondents", "Case Note"]
    data.each do |item|
      csv << item
    end
  end
end
