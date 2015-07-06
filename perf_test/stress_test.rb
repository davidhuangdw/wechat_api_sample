require_relative 'lib/wechat_srm_connector'
require_relative 'lib/util'
require_relative 'lib/parser'
require 'benchmark'

def parse(reports)
  parser = Parser.new
  metrics = Hash.new{|h,k|h[k] = []}
  reports.flatten.each do |report|
    lines = report.split("\n")
    parsed = parser.parse_lines(lines)
    metrics[parsed[:resp_code]] << parsed
  end
  metrics
end
def overview(reports)
  parser = Parser.new
  metrics = Hash.new{|h,k|h[k] = []}
  reports.flatten.each do |report|
    lines = report.split("\n")
    parsed = parser.parse_lines(lines)
    metrics[parsed[:resp_code]] << parsed
  end

  Summary.new(metrics).overview
end

# def warmup(srm_conn)
#   warmup_count = 5
#   warmup_count.times do |i|
#     srm_conn.run do
#       result = push_msg
#       report = report_str(result)
#       puts report
#       puts "warming up remain: #{warmup_count-1-i}."
#     end
#   end
# end

# host = 'http://srm-connector.ljiang.dev.cloud.vitrue.com'
# srm_conn = WechatSrmConnector.new(host)
# warmup(srm_conn)

def stress_test(req_count, thread_count, host)
  per_count = req_count/thread_count
  reports = thread_count.times.map{[]}

  threads = thread_count.times.map do |i|
    Thread.new do
      srm_conn = WechatSrmConnector.new(host)
      per_count.times.map do |j|
        srm_conn.run do
          result = push_msg
          reports[i][j] = report_str(result)
        end
      end
    end
  end

  total_time = Benchmark.measure do
    sleep 0.001
    threads.each{|t| t.join}
  end

  metrics = parse(reports)
  success_req_count = metrics['200'].count
  throughput = success_req_count/total_time.real

  res = ''
  res << total_time.to_s << "\n"
  res << "Total time: #{total_time.real}" << "\n"
  res << "Throughput: #{throughput} req/s" << "\n"
  res << '-'*70 << "\n"
  res << Summary.new(metrics).overview << "\n"
end

# host = 'http://srm-connector.ljiang.dev.cloud.vitrue.com'
host = 'http://srm-connector.jwang.dev.cloud.vitrue.com'
time = Time.now
(30..100).step(10) do |thread_count|
  req_count = thread_count*20
  logfile = "tmp/stress_#{thread_count}_#{req_count}_#{time.to_i}.txt"
  res = stress_test(req_count, thread_count, host)
  puts res
  File.write(logfile, res)
end

