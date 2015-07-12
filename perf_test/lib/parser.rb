class Parser
  def parse_log_files(files)
    max_rec = min_rec = nil
    succ_count = fail_count = sum_sq = sum = 0
    max_id = min_id = nil
    counts = Hash.new(0)

    each_record(files) do |rec|
      counts[rec[:resp_code]] += 1
      if(rec[:resp_code] = '200')
        succ_count += 1

        max_id = [max_id, rec[:msg_id]].compact.max
        min_id = [min_id, rec[:msg_id]].compact.min

        sum += rec[:latency]
        sum_sq += rec[:latency]**2

        max_rec = rec unless max_rec && max_rec[:latency]>rec[:latency]
        min_rec = rec unless min_rec && min_rec[:latency]<rec[:latency]
      else
        fail_count += 1
      end
    end

    avg = var = -1
    if succ_count>0
      avg = sum/succ_count
      avg_sq = sum_sq/succ_count
      var = Math.sqrt(avg_sq - avg**2)
    end

    OpenStruct.new(max_rec: max_rec,
                   min_rec: min_rec,
                   max_id: max_id,
                   min_id: min_id,
                   counts: counts,
                   succ_count: succ_count,
                   fail_count: fail_count,
                   latency_avg: avg,
                   latency_var: var,
    )
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
  def each_record(files)
    each_msg_lines(files) do |lines|
      yield parse_lines(lines)
    end
  end

  def each_msg_lines(file_names)
    file_names.each do |fname|
      File.open(fname) do |file|
        file.each_slice(5){|lines| yield lines}
      end
    end
  end
  def last_word(str)
    str.split(/[\s()]+/).reject(&:blank?).last
  end
end

class Summary
  def render(parsed)
    lines = ''
    parsed.counts.each do |code, num|
      lines << "resp_code: #{code}\t\tcount: #{num}\n"
    end
    lines << "max latentcy:\t" + latency_detail(parsed.max_rec) << "\n"
    lines << "min latentcy:\t" + latency_detail(parsed.min_rec) << "\n"
    lines << "average:\t #{parsed.latency_avg}\n"
    lines << "variation:\t #{parsed.latency_var}\n"
    lines << "min_id:\t #{parsed.min_id}\n"
    lines << "max_id:\t #{parsed.max_id}\n"
    lines
  end

  private
  def latency_detail(record)
    msg_id = record[:msg_id]
    created_at = record[:msg][/CreateTime=>([\d.]*)/, 1]
    created_at = Time.at(created_at.to_f)
    latency = record[:latency]
    "#{latency}\t#{msg_id}\t#{created_at}"
  end
end

#
# class Summary
#   SKIP_EXTREME_NUM = 0
#
#   attr_reader :pased
#   def initialize(parsed)
#     @parsed = parsed
#   end
#
#   def overview
#     count_summary + latency_summary
#   end
#
#   def msg_ids
#     sorted_msg_ids.join("\n")+"\n"
#   end
#
#   def msg_count_commands
#     min_id = sorted_msg_ids.first
#     max_id = sorted_msg_ids.last
#     "command: msg_count(#{min_id}, #{max_id})\n"
#   end
#
#   private
#   def count_summary
#     lines = ''
#     metrics.map do |code, records|
#       lines << "resp_code: #{code}\t\tcount: #{records.count}\n"
#     end
#     lines
#   end
#
#   def latency_summary
#     lines = ""
#
#     records = after_sort_and_skip
#     lines << "max latentcy:\t" + latency_detail(records[-1]) << "\n"
#     lines << "min latentcy:\t" + latency_detail(records[0]) << "\n"
#     latencies = records.map{|r| r[:latency]}
#     avg = average(latencies)
#     vari = variation(latencies, avg)
#     lines << "average:\t #{avg}\n"
#     lines << "variation:\t #{vari}\n"
#   end
#
#   def after_sort_and_skip
#     records = metrics['200']
#     records.sort_by{|r| r[:latency]}[SKIP_EXTREME_NUM...-SKIP_EXTREME_NUM]
#   end
#
#
#   def latency_detail(record)
#     msg_id = record[:msg_id]
#     created_at = record[:msg][/CreateTime=>([\d.]*)/, 1]
#     created_at = Time.at(created_at.to_f)
#     latency = record[:latency]
#     "#{latency}\t#{msg_id}\t#{created_at}"
#   end
#
#   def average(values)
#     return nil if values.empty?
#     sum = values.reduce(0, :+)
#     sum.to_f/values.size
#   end
#
#   def variation(values, avg)
#     return nil if values.empty?
#     deltas = values.map{|v| (v-avg).abs}
#     average(deltas)
#   end
#
#   def sorted_records
#     records = metrics['200']
#     @sorted_records ||= records.sort_by{|r| r[:msg_id].to_i}
#   end
#
#   def sorted_msg_ids
#     @sorted_msg_ids ||= sorted_records.map{|r| r[:msg_id]}
#   end
#
# end
