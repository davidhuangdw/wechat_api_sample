require_relative '../lib/wechat_api'
# http://mp.weixin.qq.com/wiki/9/6fff6f191ef92c126b043ada035cc935.html
# kf client for pc or wechat: http://dkf.qq.com/index.html

app_id = 'wx896e08f0cac4122b'
secret = '24402383f5917760adf6be3620b67761'
app_id = 'wxd1de833ac6b6ebfe'
secret = '7393cd3d6260e3fcde6fafb6bf6cea5e'


x = WechatApi.new
token = x.get_token(app_id, secret)['access_token']


# fetch customer service staff list:
p x.get_kf_list(token)

# add staff:
body_hash = {
    kf_account: 'david@gh_7d9495d344c6',
    nickname: 'david',
    password: 'david123',
}
p x.add_kfaccount(token, body_hash)

# get wait cases:
p x.get_wait_case(token)