require_relative 'lib/wechat_srm_connector'
require_relative 'lib/util'
require_relative 'lib/parser'
require_relative 'lib/thread_pool'
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

def stress_test(req_count, thread_count, host)
  reports = [] #thread_count.times.map{[]}
  pool = ThreadPool.new(thread_count, req_count) do |ithread, index|
    srm_conn = WechatSrmConnector.new(host)
    srm_conn.run do
      result = push_msg
      reports[index] = report_str(result)
    end
  end

  total_time = Benchmark.measure do
    pool.run
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

host = 'http://srm-connector.ljiang.dev.cloud.vitrue.com'

# host = 'http://srm-connector.jwang.dev.cloud.vitrue.com'
time = Time.now
(5..80).step(5) do |thread_count|
  req_count = thread_count*20
  logfile = "tmp/stress_thread_#{thread_count}_#{req_count}_#{time.to_i}.txt"
  res = stress_test(req_count, thread_count, host)
  puts res
  File.write(logfile, res)

  cool_down_time = req_count*0.5
  sleep cool_down_time
end

