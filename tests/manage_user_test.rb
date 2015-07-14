# encoding: utf-8
require_relative '../lib/wechat_api'
# http://mp.weixin.qq.com/wiki/14/bb5031008f1494a59c6f71fa0f319c66.html

# sandbox: http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index
app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'

x = WechatApi.new
token = x.get_token(app_id, secret)['access_token']

### fetch user list:
p x.get_ip_list(token)
p openids=x.get_user_openids(token)

### fetch user info:
openid = openids.first
p x.get_user_info(token, openid)
