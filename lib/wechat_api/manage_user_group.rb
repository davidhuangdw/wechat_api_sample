require_relative 'basics'

class WechatApi
  def get_user_group(token, user_id)
    url = 'https://api.weixin.qq.com/cgi-bin/groups/getid'
    params = {access_token: token}
    body = {openid: user_id}.to_json
    resp_of_post(url: url, params: params, body: body)
  end

  def change_user_group(token, user_openid, tar_group_id)
    url = 'https://api.weixin.qq.com/cgi-bin/groups/members/update'
    params = {access_token: token}
    body = {openid: user_openid, to_groupid: tar_group_id}.to_json
    resp_of_post(url: url, params: params, body: body)
  end


  def get_group_list(token)
    params = {access_token: token}
    url = 'https://api.weixin.qq.com/cgi-bin/groups/get'
    resp_of_get(url: url, params: params)
  end

  def create_group(token, group_name)
    url = 'https://api.weixin.qq.com/cgi-bin/groups/create'
    params = {access_token: token}
    body = {group:{name:group_name}}.to_json
    resp_of_post(url: url, params: params, body: body)
  end
end


