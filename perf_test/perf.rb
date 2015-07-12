require_relative 'lib/wechat_srm_connector'
require_relative 'lib/util'

warming_skip_count = 10
interval = 10.seconds

host = 'http://srm-connector.ljiang.dev.cloud.vitrue.com'
host = 'http://srm-connector.mzou.dev.cloud.vitrue.com'
srm_conn = WechatSrmConnector.new(host)
loop do
  result = srm_conn.push_msg
  report = srm_conn.report_str(result)

  puts report
  if warming_skip_count > 0
    warming_skip_count -= 1
    puts "#{warming_skip_count} remain to skip writing log"
  else
    msg_time = result[:msg][:CreateTime]
    log = Util.logfile(msg_time)
    log.write(report)
  end

  sleep interval
end

