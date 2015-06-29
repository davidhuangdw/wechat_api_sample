# encoding: utf-8
require_relative '../lib/wechat_api'

# sandbox: http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index
app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'

x = WechatApi.new
token = x.get_token(app_id, secret)['access_token']

### send news to openids:
news_media_id = 'm425Tk9VD4U7AhdzDM3KzUYAYjxv34JBj2gq_jvGODA'
user_openids = %w[oYybev9mXy3IVa_XcPqut8YPUM8k oYybevwdaa79Qx8F_9ML-hmA-vKs]
p user_openids
body_hash = {touser: user_openids,
             mpnews:{media_id: news_media_id},
             msgtype: 'mpnews'
}
p x.send_news_to_users(token, body_hash)


### send news to group:
group_id = 100
body_hash ={filter:{is_to_all: false,
                    group_id: group_id},
            mpnews:{media_id: news_media_id},
            msgtype: 'mpnews'
}
p x.send_news_to_group(token, body_hash)