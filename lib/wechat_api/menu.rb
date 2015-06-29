require_relative 'basics'

class WechatApi
  def create_menu(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/menu/create'
    params = {access_token: token}
    validate_required_fields(body_hash, :button)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end
end


