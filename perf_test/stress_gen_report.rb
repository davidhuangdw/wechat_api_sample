def number_after_word(str, word)
  str[/#{word}\s*([\d.]+)/, 1].to_f
end
def parse_line(line, attrs)
  words = line.strip.split(/\s+/)
  case words.first
    when 'Total'
      attrs[:total_time] = number_after_word(line, 'Total time:')
    when 'Throughput:'
      attrs[:throughput] = number_after_word(line, 'Throughput:')
    when 'resp_code:'
      attrs[:resp] ||= {}
      attrs[:resp][number_after_word(line, 'resp_code:').to_i] = number_after_word(line, 'count:').to_i
    when 'average:'
      attrs[:avg_latency] = number_after_word(line, 'average:')*1000
    else
  end
end


type, file_num = ARGV
type ||= 'thread'
file_num ||= 10
files = `ls -t tmp/stress_#{type}* | head -#{file_num}`.split("\n")

res = ''
keys = %w[thread_num total_time throughput req_count fail_req_count avg_latency]
res << keys.map(&:upcase).join("\t\t") << "\n"
files.map do |file|
  thread_num = file[/#{type}_([\d.]+)_/,1].to_i
  attrs = {thread_num: thread_num}
  File.read(file).each_line do |line|
    parse_line(line, attrs)
  end
  attrs
end.sort_by{|a| a[:thread_num]}.each do |attrs|
  attrs[:req_count] = attrs[:resp].values.reduce(0, :+)
  attrs[:fail_req_count] = attrs[:req_count] - (attrs[:resp][200]||0)
  res << attrs.values_at(*keys.map(&:to_sym)).join("\t\t") << "\n"
end

puts res
outfile = "tmp/report_of_stress_#{type}_#{file_num}_#{Time.now.to_i}.txt"
File.write(outfile, res)
