require_relative 'report'

report = Report.new
report.generate
report.to_csv
