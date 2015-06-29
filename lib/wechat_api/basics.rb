# encoding: utf-8
require 'typhoeus'
require 'active_support/all'
require_relative '../exceptions'

class WechatApi
  def get_token(app_id, secret)
    params = {grant_type:'client_credential',
              appid: app_id,
              secret: secret
    }
    url = 'https://api.weixin.qq.com/cgi-bin/token'
    resp_of_get(url: url, params: params)
  end

  def get_ip_list(token)
    params = {access_token: token}
    url = 'https://api.weixin.qq.com/cgi-bin/getcallbackip'
    resp_of_get(url: url, params: params)
  end


  private
  def resp_of_get(info={})
    validate_required_fields(info, :url, :params)
    resp = Typhoeus.get(info[:url], params: info[:params])
    raise RequestError if resp.code != 200
    JSON.parse(resp.body)
  end

  def resp_of_post(info={})
    validate_required_fields(info, :url, :params, :body)
    resp = Typhoeus.post(info[:url], params: info[:params], body: info[:body])
    raise RequestError if resp.code != 200
    JSON.parse(resp.body)
  end

  def value_for_key_path(hash, key_path)
    res = hash
    key_path.each{|k| res=res[k]}
    res
  end

  def validate_required_fields(info, *fields)
    fields.each do |f|
      if info[f.to_sym].nil?
        raise "required field '#{f}' does not existed"
      end
    end
  end

end


