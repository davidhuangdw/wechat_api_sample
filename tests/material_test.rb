# encoding: utf-8
require_relative '../lib/wechat_api'
x = WechatApi.new

def token
  app_id = 'wx896e08f0cac4122b'
  secret = '24402383f5917760adf6be3620b67761'
  @token ||= WechatApi.new.get_token(app_id, secret)['access_token']
end

def last_material(type)
  body_hash = {type: type,
               offset: 0,
               count: 20
  }
  p resp= WechatApi.new.get_materials(token, body_hash)
  resp['item'] && resp['item'].last
end

### get materials:
p last_material('news')
p last_material('image')
p last_material('voice')


### add image:
body = {
    type: 'image',
    media: File.open('oracle.png')
}
p x.add_permanent_material(token, body)
p last_material('image')

### add news:
image_media_id = 'zWeOHuOIajY8lFR_KKoI1LyCSG1W8muvmZsuRwf4JKE'
articles = [{
    title: 'spider man',
    thumb_media_id: image_media_id,
    author: 'unknown author',
    digest: 'i\'m a digest',
    show_cover_pic: 1,
    content: '图文消息的具体内容，支持HTML标签，必须少于2万字符，小于1M，且此处会去除JS',
    content_source_url: 'oracle.com'
}]
body_hash = {articles:articles}
p x.add_permanent_news(token, body_hash)
p last_material('news')


