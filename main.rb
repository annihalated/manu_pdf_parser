require 'progress_bar'
require_relative 'helpers'

results = []
dir = './files/'

bar = ProgressBar.new(count_files(dir))

Dir.glob(dir + '*') do |file|
  next if file == '.' or file == '..'
  
  text = get_full_text(file)
  citation = text.match('^([^\s]+)')
  appellants = find_text_between(text, 'Appellants:', 'Vs.')
  date_decided = find_text_between(text, 'Decided On:', 'Appellants:')
  respondents = find_text_between(text, 'Respondent:', "Hon\'ble Judges/Coram:\n")
  casenote = get_casenote(text)

  puts "#{appellants} v. #{respondents} (#{citation}), #{date_decided}"
  current_result = [date_decided, citation, appellants, respondents, casenote]
  results.push(current_result)

  bar.increment!
end

save_to_csv(results, "results.csv")
