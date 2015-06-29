require_relative 'basics'

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


