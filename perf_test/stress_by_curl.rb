require_relative 'lib/wechat_srm_connector'
require_relative 'lib/util'
require_relative 'lib/parser'
require 'uri'

def get_requests(count)
  host = 'http://srm-connector.jwang.dev.cloud.vitrue.com'
  conn = WechatSrmConnector.new(host)
  count.times.map do
    req = nil
    conn.push_msg{|info| req=info}
    req
  end
end

def curl_command(req)
  url = URI.parse(req[:url])
  query = URI.encode_www_form(req[:params])
  uri = URI::HTTP.build(host:url.host, path:url.path, query: query)
  "curl -X POST -H\"Content-Type: application/json\" --data #{req[:body].inspect} '#{uri}'"
end

req_count = 100
thread_count = 10

reqs = get_requests(req_count)
cmds = reqs.map{|r| curl_command(r)}

file = 'tmp/curl_commands'
f = File.new(file, 'w')
f.write(cmds.join("\n"))

timing =  Benchmark.measure do
  # todo: how to escape in shell commands
  `cat #{file} | xargs -I CMD bash -c "CMD"` # cannot escape
end
puts timing

