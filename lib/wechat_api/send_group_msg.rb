require_relative 'basics'

class WechatApi
  def send_news_to_users(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/message/mass/send'
    params = {access_token: token}
    validate_required_fields(body_hash, :mpnews, :msgtype, :touser)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end

  def send_news_to_group(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/message/mass/sendall'
    params = {access_token: token}
    validate_required_fields(body_hash, :mpnews, :msgtype, :filter)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end
end


