require_relative 'basics'
# http://mp.weixin.qq.com/wiki/14/bb5031008f1494a59c6f71fa0f319c66.html

class WechatApi
  def get_user_openids(token, next_openid=nil)
    params = {access_token: token, next_openid:next_openid}
    url = 'https://api.weixin.qq.com/cgi-bin/user/get'
    body = resp_of_get(url: url, params: params)

    return [] if body['count'].to_i <= 0
    body['data']['openid'].tap do |list|
      next_openid = body['next_openid']
      if next_openid.present?
        remain = get_user_openids(token, next_openid)
        list.concat(remain)
      end
    end
  end

  def get_user_info(token, openid, lang='en')
    params = {access_token: token, openid:openid, lang:lang}
    url = 'https://api.weixin.qq.com/cgi-bin/user/info'
    resp_of_get(url: url, params: params)
  end
end


