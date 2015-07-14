require_relative 'basics'
# http://mp.weixin.qq.com/wiki/18/28fc21e7ed87bec960651f0ce873ef8a.html

class WechatApi
  def create_tmp_qrcode(token, body_hash)
    params = {access_token: token}
    url = 'https://api.weixin.qq.com/cgi-bin/qrcode/create'

    body_hash = body_hash.merge(action_name: 'QR_SCENE')
    body_hash[:expire_seconds] ||= 7.days.to_i

    validate_required_fields(body_hash, :action_name, :action_info) #:expire_seconds
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end

  def qrcode_img_url(ticket)
    URI.escape("https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{ticket}")
  end

  def to_short_url(token, body_hash)
    params = {access_token: token}
    url = 'https://api.weixin.qq.com/cgi-bin/shorturl'

    body_hash = body_hash.merge(action: 'long2short')
    validate_required_fields(body_hash, :action, :long_url)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end
end
