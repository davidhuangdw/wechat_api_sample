require 'active_support/all'
require_relative 'lib/parser'


# time_str = Time.now.strftime('%m-%d-%I-%M-%S')
time_str = ''
overview_log_file = "tmp/overview_#{time_str}.txt"

log_files = Dir['tmp/perf_*.log']
parsed = Parser.new.parse_log_files(log_files)
summary = Summary.new.render(parsed)

File.write(overview_log_file, summary)
