require 'csv'
require 'progress_bar'
require_relative 'opinion'

class Report
  def initialize
    puts 'Where are the files?'
    @dir = gets.chomp
    @results = []
  end

  def generate
    bar = ProgressBar.new(count_files(@dir))
    Dir.glob(@dir + '*.pdf') do |file|
      next if file == '.' or file == '..'
      opinion = Opinion.new(file)
      puts "#{opinion.appellants} v. #{opinion.respondents} (#{opinion.citation}), #{opinion.date_decided}"
      @results.push([opinion.date_decided, opinion.citation, opinion.appellants, opinion.respondents, opinion.casenote])
      bar.increment!
    end

    @results
  end

  def to_csv
    CSV.open("results.csv", "wb") do |csv|
      csv << ["Date Decided", "Citation", "Appellants", "Respondents", "Case Note"]
      @results.each do |item|
        csv << item
      end
    end
  end

  private 

  def count_files(folder)
    Dir[File.join(folder, '**', '*')].count { |file| File.file?(file) }
  end

end
