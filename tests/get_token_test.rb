# encoding: utf-8
require_relative '../lib/wechat_api'

# sandbox: http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index
app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'

x = WechatApi.new

### fetch token:
p x.get_token(app_id, secret)
