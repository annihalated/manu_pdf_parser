require 'progress_bar'
require_relative 'opinion'
require_relative 'helpers'

results = []
dir = './files/'

bar = ProgressBar.new(count_files(dir))

Dir.glob(dir + '*') do |file|
  next if file == '.' or file == '..'
  opinion = Opinion.new(file)
  puts "#{opinion.appellants} v. #{opinion.respondents} (#{opinion.citation}), #{opinion.date_decided}"
  results.push([opinion.date_decided, opinion.citation, opinion.appellants, opinion.respondents, opinion.casenote])
  bar.increment!
end

save_to_csv(results, "results.csv")
