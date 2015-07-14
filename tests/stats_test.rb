# encoding: utf-8
require_relative '../lib/wechat_api'

# http://mp.weixin.qq.com/wiki/3/ecfed6e1a0a03b5f35e5efac98e864b7.html
# sandbox: http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index
app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'

x = WechatApi.new
token = x.get_token(app_id, secret)['access_token']

begin_date = end_date = Time.now-1.day

# user:
type = 'getusersummary'
type = 'getusercumulate'
p x.stats(token, type:type, begin_date:begin_date, end_date:end_date)

# article:
type = 'getarticletotal'
p x.stats(token, type:type, begin_date:begin_date, end_date:end_date)

# msg:
type = 'getupstreammsg'
p x.stats(token, type:type, begin_date:begin_date, end_date:end_date)

# interface:
type = 'getinterfacesummary'
p x.stats(token, type:type, begin_date:begin_date, end_date:end_date)


