# encoding: utf-8
require_relative '../lib/wechat_api'

# sandbox: http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index
app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'

x = WechatApi.new
token = x.get_token(app_id, secret)['access_token']

openids=x.get_user_openids(token)
openid = openids.first

### create_group:
group_name = 'another test'
p x.create_group(token, group_name)

### get group:
p resp=x.get_group_list(token)
groups = resp['groups']
p x.get_user_group(token, openid)

### change group:
p group_id = groups.last['id']
p x.change_user_group(token, openid, group_id)
p x.get_user_group(token, openid)
