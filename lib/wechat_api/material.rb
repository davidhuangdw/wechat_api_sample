require_relative 'basics'

class WechatApi
  def get_materials(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/material/batchget_material'
    params = {access_token: token}
    validate_required_fields(body_hash, :type, :offset, :count)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end

  def add_permanent_material(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/material/add_material'
    params = {access_token: token}
    resp_of_post(url:url, params:params, body: body_hash)       # don't .to_json because it contains file data
  end

  def add_permanent_news(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/material/add_news'
    params = {access_token: token}
    validate_required_fields(body_hash, :articles)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end
end


