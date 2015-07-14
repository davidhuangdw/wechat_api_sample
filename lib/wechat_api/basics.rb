# encoding: utf-8
require 'typhoeus'
require 'active_support/all'
require_relative 'error_meaning'
require_relative '../exceptions'

# sandbox: http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index
# http://mp.weixin.qq.com/wiki/11/0e4b294685f817b95cbed85ba5e82b8f.html

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
    parse_body(resp)
  end

  def resp_of_post(info={})
    validate_required_fields(info, :url, :params, :body)
    resp = Typhoeus.post(info[:url], params: info[:params], body: info[:body])
    raise RequestError if resp.code != 200
    parse_body(resp)
  end

  def parse_body(resp)
    body = JSON.parse(resp.body) rescue {json_parse_err_body_str: resp.body}
    errcode, errmsg = body.values_at(*%w[errcode errmsg])
    if errcode.present? && errcode.to_i!=0
      puts %Q{
           errcode: #{errcode}
           errmsg: #{errmsg}
           err_meaning: #{error_meaning(errcode)}
           }
    end
    body
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


