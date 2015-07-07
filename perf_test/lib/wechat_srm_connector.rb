require 'typhoeus'
require 'active_support/all'
require 'benchmark'

class WechatSrmConnector
  attr_reader :host
  def initialize(host)
    @host, @network = host, 'wechat'
  end

  def run(&blk)
    instance_eval(&blk)
  end

  def add_resource
  end

  def get_token(publisher_openid)
    url = host + '/api/token'
    params = {type: @network, identifier:publisher_openid}
    resp=Typhoeus.get(url, params:params)
    JSON.parse(resp.body)
  end

  def push_msg(msg=generate_msg)
    token, nonce, timestamp = 'david', '123', Time.now.to_s
    url = host + "/api/dm/wechat/receive/#{token}"
    params = {timestamp:timestamp,
              nonce:nonce,
              signature: signature(token, timestamp, nonce)
    }
    body = {xml:msg}.to_json

    resp = nil
    return yield(msg:msg, url:url, params:params, body:body) if block_given?
    timing = Benchmark.measure do
      resp = Typhoeus.post(url, params:params, body:body)
    end
    {msg:msg, timing: timing, resp: resp}
  end

  def generate_msg(content='blank content')
    # msg_id = next_msg_id
    create_time = Time.now
    msg_id = (create_time.to_f*1000_000).to_i
    openid = 'oYybev9mXy3IVa_XcPqut8YPUM8k'
    publisher_openid = 'gh_7d9495d344c6'
    {
        MsgType: 'text',
        MsgId: msg_id.to_s,
        CreateTime: create_time.to_f,
        FromUserName: openid,
        ToUserName: publisher_openid,
        Content: "#{msg_id} : #{Time.at(create_time)} : #{content}",
    }
  end

  def report_str(res)
    rpt = '-'*70
    rpt << "\nresp_code: #{res[:resp].code}"
    rpt << "\nmsg_id: #{res[:msg][:MsgId]}"
    rpt << "\nmsg: #{res[:msg]}"
    rpt << "\nlatency: #{res[:timing]}"
    rpt
  end

  private
  def next_msg_id
    @msg_id ||= 100_000
    @msg_id += 1
  end

  def signature(token, timestamp, nonce)
    checksum = [token, timestamp, nonce].sort.join
    Digest::SHA1.hexdigest(checksum)
  end
end

