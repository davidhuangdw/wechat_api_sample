# encoding: utf-8
require_relative 'wechat_api'

# sandbox: http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index
app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'
token = '1FsT1Gqf3mR2HF_0qeiQojIaZqcUAAhomc159d0lJ8UHY2YEHr6BTG-thMK4BqsUdwF4azw7kJFI7OAWQrc1L-x2fHOiOhNqU7f4Xfl-nCQ'
openid = 'oYybev9mXy3IVa_XcPqut8YPUM8k'

x = WechatApi.new

### fetch token:
# app_id = 'wx896e08f0cac4122b'
# secret = '24402383f5917760adf6be3620b67761'
# token = x.get_token(app_id, secret)
# p token

### fetch user list:
# token = 'Cqi4kS3VfekHnfa1k-izR80_qxszaa1x5CO6v7Jc6upCrSoytg-MKbV9vX2L31H5ASVtZO14URYp_2JZwqYZyA4QmpP9vTtZpmy2dqMxEqY'
# p x.get_ip_list(token)
# p x.get_group_list(token)
# p x.get_user_openids(token)

### fetch user info:
# openid = 'oYybev9mXy3IVa_XcPqut8YPUM8k'
# p x.get_user_info(token, openid)

### add material:
# body = {
#     type: 'image',
#     media: File.open('oracle.png')
# }
# p x.add_material(token, body)


### add news:
# image_media_id = 'zWeOHuOIajY8lFR_KKoI1LyCSG1W8muvmZsuRwf4JKE'
# articles = [{
#     title: 'random article',
#     thumb_media_id: image_media_id,
#     author: 'author',
#     digest: 'a digest',
#     show_cover_pic: 1,
#     content: '图文消息的具体内容，支持HTML标签，必须少于2万字符，小于1M，且此处会去除JS',
#     content_source_url: 'oracle.com'
# }]
# p x.add_news(token, articles)
# article_media_id = '_b5KL8uVaxYFrQEzIL57kT3pXSpq_J4qvQcXq01DutY'

### create menu:
# buttons = [
#     {
#         type:"click",
#         name:"今日歌曲",
#         key:"V1001_TODAY_MUSIC"
#     },
#     {
#         name:"菜单",
#         sub_button:[
#             {
#                 type:"view",
#                 name:"搜索",
#                 url:"http://www.soso.com/"
#             },
#             {
#                 type:"view",
#                 name:"视频",
#                 url:"http://v.qq.com/"
#             }
#         ]
#     }
# ]
# p x.create_menu(token, buttons)

### upload and send news:
# image_media_id = 'zWeOHuOIajY8lFR_KKoI1LyCSG1W8muvmZsuRwf4JKE'
# articles = [{
#     title: 'random article',
#     thumb_media_id: image_media_id,
#     author: 'author',
#     digest: 'a digest',
#     show_cover_pic: 1,
#     content: '图文消息的具体内容，支持HTML标签，必须少于2万字符，小于1M，且此处会去除JS',
#     content_source_url: 'oracle.com'
# }]
# p x.upload_news(token, articles)

### send news:
# article_media_id = 'Zlg7B5l0eKrYYu6MbrdY8K6wof6qlsEkUpSCmY9Z3UZ5t5hBSYEeBy7XB-y8xBaa'
# user_openids = [openid]
# p x.send_news(token, article_media_id, user_openids)