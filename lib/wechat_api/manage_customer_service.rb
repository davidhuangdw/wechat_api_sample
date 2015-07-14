require_relative 'basics'
# http://mp.weixin.qq.com/wiki/9/6fff6f191ef92c126b043ada035cc935.html
# kf client for pc or wechat: http://dkf.qq.com/index.html

class WechatApi
  def get_kf_list(token)
    params = {access_token: token}
    url = 'https://api.weixin.qq.com/cgi-bin/customservice/getkflist'
    resp_of_get(url: url, params: params)
  end

  def add_kfaccount(token, body_hash)
    url = 'https://api.weixin.qq.com/customservice/kfaccount/add'
    params = {access_token: token}
    validate_required_fields(body_hash, :kf_account, :nickname, :password)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end

  def get_wait_case(token)
    params = {access_token: token}
    url = 'https://api.weixin.qq.com/customservice/kfsession/getwaitcase'
    resp_of_get(url:url, params:params)
  end
end
