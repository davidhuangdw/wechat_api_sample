require_relative 'wechat_srm_connector'

def report_str(res)
  rpt = '-'*70
  rpt << "\nresp_code: #{res[:resp].code}"
  rpt << "\nmsg_id: #{res[:msg][:MsgId]}"
  rpt << "\nmsg: #{res[:msg]}"
  rpt << "\nlatency: #{res[:timing]}"
  rpt
end

def logfile(time, period = 12.hour)
  round = time.to_i/period*period
  if @last_round != round
    @last_round = round
    @log_file.close if @log_file

    fname = 'tmp/' + 'perf_' + Time.at(round).strftime('%m-%d-%I') + '.log'
    @log_file = File.new(fname, 'a')
  end
  @log_file
end



interval = 10.seconds
srm_conn = WechatSrmConnector.new
loop do
  result = srm_conn.push_msg
  report = report_str(result)

  msg_time = result[:msg][:CreateTime]
  log = logfile(msg_time)
  log.write(report)

  sleep interval
end

