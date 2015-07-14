require_relative 'basics'
# http://mp.weixin.qq.com/wiki/13/43de8269be54a0a6f64413e4dfa94f39.html

class WechatApi
  def create_menu(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/menu/create'
    params = {access_token: token}
    validate_required_fields(body_hash, :button)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end
end


