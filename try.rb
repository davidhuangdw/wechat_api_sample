require_relative 'wechat_api'

# sandbox: http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index
app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'
token = 'If9x4ktPIRHw3LkMIZygqZc02IwlqUl6wfIm3aD7-m0RUeA9Id8IVZIXWD7KDMp1BuMmUQwCBgK-HMU7MyRCL3WUrt8-DCOT8cQ431PqYb4'

x = WechatApi.new

# fetch token:
# app_id = 'wx896e08f0cac4122b'
# secret = '24402383f5917760adf6be3620b67761'
# token = x.get_token(app_id, secret)
# p token

# fetch user list:
# token = 'Cqi4kS3VfekHnfa1k-izR80_qxszaa1x5CO6v7Jc6upCrSoytg-MKbV9vX2L31H5ASVtZO14URYp_2JZwqYZyA4QmpP9vTtZpmy2dqMxEqY'
# p x.get_ip_list(token)
# p x.get_group_list(token)
# p x.get_user_openids(token)

# fetch user info:
# openid = 'oYybev9mXy3IVa_XcPqut8YPUM8k'
# p x.get_user_info(token, openid)

# add material:
# body = {
#     type: 'image',
#     media: File.open('oracle.png')
# }
# p x.add_material(token, body)


# add news:
# media_id = 'zWeOHuOIajY8lFR_KKoI1LyCSG1W8muvmZsuRwf4JKE'
# article = {
#     title: 'random article',
#     thumb_media_id: media_id,
#     author: 'author',
#     digest: 'a digest',
#     show_cover_pic: 1,
#     content: '图文消息的具体内容，支持HTML标签，必须少于2万字符，小于1M，且此处会去除JS',
#     content_source_url: 'oracle.com'
# }.stringify_keys
# p x.add_news(token, article)

# create menu:
# buttons = [
#     {
#       type:"click",
#       name:"今日歌曲",
#       key:"V1001_TODAY_MUSIC"
#     }
# ]
# buttons = buttons*3
# p x.create_menu(token, buttons)
