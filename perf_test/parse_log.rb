require 'active_support/all'
SKIP_EXTREME_NUM = 5

class Parser
  def parse_log_files(files)
    res = Hash.new{|h,k|h[k] = []}
    each_msg_lines(files) do |lines|
      raise "not beginning line: #{lines[0]}" unless lines[0] =~ /--------/
      resp_code = last_word(lines[1])
      msg_id = last_word(lines[2]).to_i
      latency = last_word(lines[4]).to_f
      res[resp_code] << {msg_id: msg_id, latency:latency}
    end
    res
  end

  private
  def each_msg_lines(files)
    files.each do |file|
      File.open(file).each_slice(5){|lines| yield lines}
    end
  end
  def last_word(str)
    str.split(/[\s()]+/).reject(&:blank?).last
  end
end

class Summary
  attr_reader :metrics
  def initialize(metrics)
    @metrics = metrics
  end

  def overview
    [count_summary, latency_summary].join("\n")
  end

  def msg_ids
    sorted_msg_ids.join("\n")
  end

  def msg_count_commands
    min_id = sorted_msg_ids.first
    max_id = sorted_msg_ids.last
    "command: msg_count(#{min_id}, #{max_id})\n"
  end

  private
  def count_summary
    metrics.map do |code, records|
      "resp_code: #{code}\t\tcount: #{records.count}"
    end.join("\n")
  end

  def latency_summary
    lines = []

    records = after_sort_and_skip
    lines << "max latentcy:\t" + latency_detail(records[-1])
    lines << "min latentcy:\t" + latency_detail(records[0])
    latencies = records.map{|r| r[:latency]}
    avg = average(latencies)
    vari = variation(latencies, avg)
    lines << "average:\t #{avg}"
    lines << "variation:\t #{vari}"
    lines.join("\n")
  end

  def after_sort_and_skip
    sorted_records[SKIP_EXTREME_NUM...-SKIP_EXTREME_NUM]
  end


  def latency_detail(record)
    msg_id = record[:msg_id]
    created_at = Time.at(msg_id)
    latency = record[:latency]
    "#{latency}\t#{msg_id}\t#{created_at}"
  end

  def average(values)
    return nil if values.empty?
    sum = values.reduce(0, :+)
    sum.to_f/values.size
  end

  def variation(values, avg)
    return nil if values.empty?
    deltas = values.map{|v| (v-avg).abs}
    average(deltas)
  end

  def sorted_records
    records = metrics['200']
    @sorted_records ||= records.sort_by{|r| r[:msg_id].to_i}
  end

  def sorted_msg_ids
    @sorted_msg_ids ||= sorted_records.map{|r| r[:msg_id]}
  end

end

# time_str = Time.now.strftime('%m-%d-%I-%M-%S')
time_str = ''
overview_log_file = "tmp/overview_#{time_str}.txt"
ids_log_file = "tmp/ids_#{time_str}.txt"

log_files = Dir['tmp/*.log']
metrics = Parser.new.parse_log_files(log_files)
summary = Summary.new(metrics)

File.write(overview_log_file, summary.overview)
File.write(ids_log_file, summary.msg_count_commands+summary.msg_ids)
