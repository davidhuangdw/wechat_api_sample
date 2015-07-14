# encoding: utf-8
require_relative '../lib/wechat_api'
# http://mp.weixin.qq.com/wiki/18/28fc21e7ed87bec960651f0ce873ef8a.html

app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'

x = WechatApi.new
token = x.get_token(app_id, secret)['access_token']


# create ticket & url:
body_hash = {
    action_info: {scene: {scene_id: '123'}}
}
p res=x.create_tmp_qrcode(token, body_hash)
p url=x.qrcode_img_url(res['ticket'])

# long2short
ticket = 'gQGZ8DoAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xLzgwUTBUbURsazFucVhuc19PV3FuAAIENBGlVQMEgDoJAA=='
p x.to_short_url(token, long_url:url)

short_url = 'http://w.url.cn/s/AFS2bM7'
