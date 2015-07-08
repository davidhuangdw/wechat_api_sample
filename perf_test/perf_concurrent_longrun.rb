require_relative 'lib/wechat_srm_connector'
require_relative 'lib/util'

class OneShot
  attr_reader :wechat_conn, :req_count
  def initialize(wechat_conn, req_count)
    @wechat_conn, @req_count = wechat_conn, req_count
  end
  def run
    hydra = Typhoeus::Hydra.new(max_concurrency: req_count)
    reqs = build_requests(hydra)

    hydra.run
    render_reports(reqs)
  end

  private
  def build_requests(hydra)
    req_count.times.map do
      wechat_conn.push_msg do |info|
        req = Typhoeus::Request.new(info[:url],
                                    method: :post,
                                    params: info[:params],
                                    body: info[:body]
        )
        hydra.queue(req)
        {req:req, msg:info[:msg]}
      end
    end
  end

  def render_reports(reqs)
    reqs.map do |req|
      resp = req[:req].response
      wechat_conn.report_str(resp: resp,
                          msg: req[:msg],
                          timing: resp.total_time
      )
    end
  end
end

interval = 1.seconds
req_count = 30
logfile_period = 6.hours

host = 'http://srm-connector.ljiang.dev.cloud.vitrue.com'
srm_conn = WechatSrmConnector.new(host)

warmup_round = 1

loop do
  reports = OneShot.new(srm_conn, req_count).run
  puts reports

  if warmup_round > 0
    warmup_round -= 1
  else
    puts 'writing'
    log = Util.logfile(Time.now, logfile_period)
    reports.each{|r| log.write(r)}
  end

  sleep interval
end

