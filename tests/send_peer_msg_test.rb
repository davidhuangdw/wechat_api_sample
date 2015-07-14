# encoding: utf-8
require_relative '../lib/wechat_api'
# http://mp.weixin.qq.com/wiki/1/70a29afed17f56d537c833f89be979c9.html#.E5.AE.A2.E6.9C.8D.E6.8E.A5.E5.8F.A3-.E5.8F.91.E6.B6.88.E6.81.AF

app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'

x = WechatApi.new
token = x.get_token(app_id, secret)['access_token']
openid = x.get_user_openids(token).first


### text to peer:
media = {msgtype: 'text', text: {content: 'hello, david!'}}
p x.send_peer_msg(token, openid, media)

### image to peer:
image_media_id = 'zWeOHuOIajY8lFR_KKoI1LyCSG1W8muvmZsuRwf4JKE'
media = {msgtype: 'image', image: {media_id: image_media_id}}
p x.send_peer_msg(token, openid, media)

### voice to peer:
voice_media_id = 'I0k1bX-pXP8BKKc2QA7Bm6gzqIVrlQQ2jkIFbJfWhuA'
media = {msgtype: 'voice', voice: {media_id: voice_media_id}}
p x.send_peer_msg(token, openid, media)

### news to peer:
pic_url = 'http://img.boqiicdn.com/Data/BK/A/1407/25/img26201406265643_y.jpg'
pic_url2 = 'http://image6.huangye88.cn/2013/04/02/6e68a072f56c48f8.jpg'
media = {msgtype:"news",
         news:{
             articles: [
                 {
                     title:"Happy Day",
                     description:"Is Really A Happy Day",
                     url:"qq.com",
                     picurl: pic_url
                 },
                 {
                     title:'Another puppy',
                     description:"Is Really A Happy Day",
                     url:"qq.com",
                     picurl: pic_url2
                 },
                 {
                     title:'Another puppy',
                     description:"Is Really A Happy Day",
                     url:"qq.com",
                     picurl: pic_url2
                 },
                 {
                     title:'Another puppy',
                     description:"Is Really A Happy Day",
                     url:"qq.com",
                     picurl: pic_url2
                 },
             ]
         }
}
p x.send_peer_msg(token, openid, media)

### get records:
end_time = Time.now + 2.days
start_time = Time.now - 2.days
body_hash = {endtime: end_time.to_i,
             starttime: start_time.to_i,
             pagesize: 50,
             pageindex: 1
}
p x.get_msg_records(token, body_hash)
