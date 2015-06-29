# encoding: utf-8
require 'typhoeus'
require 'rack'
require 'active_support/all'
require_relative 'exceptions'

class OldCode
  def get_token(app_id, secret)
    params = {grant_type:'client_credential',
              appid: app_id,
              secret: secret
    }
    url = 'https://api.weixin.qq.com/cgi-bin/token'
    resp = Typhoeus.get(url, params: params)
    raise GetTokenError if resp.code != 200

    JSON.parse(resp.body)['access_token']
  end

  def get_ip_list(token)
    params = {access_token: token}
    url = 'https://api.weixin.qq.com/cgi-bin/getcallbackip'
    resp = Typhoeus.get(url, params: params)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)['ip_list']
  end

  def get_group_list(token)
    params = {access_token: token}
    url = 'https://api.weixin.qq.com/cgi-bin/groups/get'
    resp = Typhoeus.get(url, params: params)
    raise RequestError if resp.code != 200

    p resp.body
    JSON.parse(resp.body)['groups']
  end

  def create_group(token, group_name)
    url = 'https://api.weixin.qq.com/cgi-bin/groups/create'
    params = {access_token: token}
    body = {group:{name:group_name}}.to_json
    resp = Typhoeus.post(url, params: params, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end

  def get_group_id(token, user_id)
    url = 'https://api.weixin.qq.com/cgi-bin/groups/getid'
    params = {access_token: token}
    body = {openid: user_id}.to_json
    resp = Typhoeus.post(url, params: params, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end

  def change_group(token, user_id, group_id)
    url = 'https://api.weixin.qq.com/cgi-bin/groups/members/update'
    params = {access_token: token}
    body = {openid: user_id, to_groupid: group_id}.to_json
    resp = Typhoeus.post(url, params: params, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)

  end

  def get_user_openids(token, next_openid=nil)
    params = {access_token: token, next_openid:next_openid}
    url = 'https://api.weixin.qq.com/cgi-bin/user/get'
    resp = Typhoeus.get(url, params: params)
    raise RequestError if resp.code != 200

    body = JSON.parse(resp.body)
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
    resp = Typhoeus.get(url, params: params)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end

  def add_material(token, body)
    url = 'https://api.weixin.qq.com/cgi-bin/material/add_material'
    body = body.merge(access_token: token)
    resp = Typhoeus.post(url, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end

  def get_materials(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/material/batchget_material'
    params = {access_token: token}
    validate_required_fields(body_hash, :type, :offset, :count)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end

  def add_news(token, articles)
    url = 'https://api.weixin.qq.com/cgi-bin/material/add_news'
    params = {access_token: token}
    body = {articles:articles}.to_json       # have to using json string!!
    resp = Typhoeus.post(url, params: params, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end

  def create_menu(token, buttons)
    url = 'https://api.weixin.qq.com/cgi-bin/menu/create'
    params = {access_token: token}
    body = {access_token:token, button:buttons}.to_json
    resp = Typhoeus.post(url, params: params, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end

  def upload_news(token, articles)
    url = 'https://api.weixin.qq.com/cgi-bin/media/uploadnews'
    params = {access_token: token}
    body = {access_token:token, articles:articles}.to_json       # have to using json string!!
    resp = Typhoeus.post(url, params: params, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end

  def send_news(token, news_media_id, users_openids)
    url = 'https://api.weixin.qq.com/cgi-bin/message/mass/send'
    params = {access_token: token}
    body ={touser:users_openids,
           mpnews:{media_id: news_media_id},
           msgtype:'mpnews'
    }.to_json
    resp = Typhoeus.post(url, params: params, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end

  def send_news_to_group(token, media_id, group_id)
    url = 'https://api.weixin.qq.com/cgi-bin/message/mass/sendall'
    params = {access_token: token}
    body ={filter:{
              is_to_all: false,
              group_id: group_id,
           },
           mpnews:{media_id: media_id},
           msgtype:'mpnews'
    }.to_json
    resp = Typhoeus.post(url, params: params, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end

  def reply_to_customer(token, openid, media)
    url = 'https://api.weixin.qq.com/cgi-bin/message/custom/send'
    params = {access_token: token}
    body = media.merge(touser: openid).to_json
    resp_of_post(url:url, params:params, body: body)
  end

  def get_replies(token, body_hash)
    url = 'https://api.weixin.qq.com/customservice/msgrecord/getrecord'
    params = {access_token: token}
    validate_required_fields(body_hash, :endtime, :pageindex, :pagesize, :starttime)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end





  private
  def resp_of_post(info={})
    validate_required_fields(info, :url, :params, :body)
    resp = Typhoeus.post(info[:url], params: info[:params], body: info[:body])
    raise RequestError if resp.code != 200

    resp = JSON.parse(resp.body)
    key_path = info[:key_path] || []
    value_for_key_path(resp, key_path)
  end

  def value_for_key_path(hash, key_path)
    res = hash
    key_path.each{|k| res=res[k]}
    res
  end

  def validate_required_fields(info, *fields)
    fields.each do |f|
      raise "required field '#{f}' does not existed" unless info[f.to_sym].present?
    end
  end

end


