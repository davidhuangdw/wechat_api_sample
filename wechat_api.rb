# encoding: utf-8
require 'typhoeus'
require 'rack'
require 'active_support/core_ext/object'
require 'active_support/all'
require_relative 'exceptions'

class WechatApi
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

    JSON.parse(resp.body)['groups']
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

  def add_news(token, articles)
    url = 'https://api.weixin.qq.com/cgi-bin/material/add_news'
    params = {access_token: token}
    body = {access_token:token, articles:articles}.to_json       # have to using json string!!
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
    body ={to_user:users_openids,
           mpnews:{media_id: news_media_id},
           msgtype:'mpnews'
    }.to_json
    resp = Typhoeus.post(url, params: params, body: body)
    raise RequestError if resp.code != 200

    JSON.parse(resp.body)
  end
end


