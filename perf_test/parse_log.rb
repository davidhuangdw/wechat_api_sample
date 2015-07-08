require 'active_support/all'
require_relative 'lib/parser'


# time_str = Time.now.strftime('%m-%d-%I-%M-%S')
time_str = ''
overview_log_file = "tmp/overview_#{time_str}.txt"
ids_log_file = "tmp/ids_#{time_str}.txt"

log_files = Dir['tmp/perf_*.log']
metrics = Parser.new.parse_log_files(log_files)
summary = Summary.new(metrics)

File.write(overview_log_file, summary.overview)
File.write(ids_log_file, summary.msg_count_commands+summary.msg_ids)
