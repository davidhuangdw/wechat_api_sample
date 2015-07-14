require_relative 'basics'
# http://mp.weixin.qq.com/wiki/1/70a29afed17f56d537c833f89be979c9.html#.E5.AE.A2.E6.9C.8D.E6.8E.A5.E5.8F.A3-.E5.8F.91.E6.B6.88.E6.81.AF

class WechatApi
  def send_peer_msg(token, openid, media)
    url = 'https://api.weixin.qq.com/cgi-bin/message/custom/send'
    params = {access_token: token}
    body = media.merge(touser: openid).to_json
    resp_of_post(url:url, params:params, body: body)
  end

  def get_msg_records(token, body_hash)
    url = 'https://api.weixin.qq.com/customservice/msgrecord/getrecord'
    params = {access_token: token}
    validate_required_fields(body_hash, :endtime, :pageindex, :pagesize, :starttime)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end
end


