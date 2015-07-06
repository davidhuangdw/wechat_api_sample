class Parser
  def parse_log_files(files)
    res = Hash.new{|h,k|h[k] = []}
    each_msg_lines(files) do |lines|
      parsed = parse_lines(lines)
      res[parsed[:resp_code]] << parsed
    end
    res
  end

  def parse_lines(lines)
    raise "not beginning line: #{lines[0]}" unless lines[0] =~ /--------/
    resp_code = last_word(lines[1])
    msg_id = last_word(lines[2]).to_i
    msg = lines[3]
    latency = last_word(lines[4]).to_f
    {resp_code: resp_code,
     msg_id: msg_id,
     msg: msg,
     latency:latency}
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
  SKIP_EXTREME_NUM = 2

  attr_reader :metrics
  def initialize(metrics)
    @metrics = metrics
  end

  def overview
    count_summary + latency_summary
  end

  def msg_ids
    sorted_msg_ids.join("\n")+"\n"
  end

  def msg_count_commands
    min_id = sorted_msg_ids.first
    max_id = sorted_msg_ids.last
    "command: msg_count(#{min_id}, #{max_id})\n"
  end

  private
  def count_summary
    lines = ''
    metrics.map do |code, records|
      lines << "resp_code: #{code}\t\tcount: #{records.count}\n"
    end
    lines
  end

  def latency_summary
    lines = ""

    records = after_sort_and_skip
    lines << "max latentcy:\t" + latency_detail(records[-1]) << "\n"
    lines << "min latentcy:\t" + latency_detail(records[0]) << "\n"
    latencies = records.map{|r| r[:latency]}
    avg = average(latencies)
    vari = variation(latencies, avg)
    lines << "average:\t #{avg}\n"
    lines << "variation:\t #{vari}\n"
  end

  def after_sort_and_skip
    records = metrics['200']
    records.sort_by{|r| r[:latency]}[SKIP_EXTREME_NUM...-SKIP_EXTREME_NUM]
  end


  def latency_detail(record)
    msg_id = record[:msg_id]
    created_at = record[:msg][/CreateTime=>([\d.]*)/, 1]
    created_at = Time.at(created_at.to_f)
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
