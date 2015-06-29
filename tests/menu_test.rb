# encoding: utf-8
require_relative '../lib/wechat_api'

# sandbox: http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index
app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'

x = WechatApi.new
token = x.get_token(app_id, secret)['access_token']

### create menu:
buttons = [
    {
        type: "click",
        name: "event_button",
        key: "V1001_TODAY_MUSIC"
    },
    {
        name: "sub_urls",
        sub_button:[
            {
                type: "view",
                name: "搜索",
                url: "http://www.soso.com/"
            },
            {
                type: "view",
                name: "视频",
                url: "http://v.qq.com/"
            }
        ]
    }
]
body_hash = {button: buttons}
p x.create_menu(token, body_hash)
