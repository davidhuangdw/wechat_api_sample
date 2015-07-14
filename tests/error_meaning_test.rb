# encoding: utf-8
require_relative '../lib/wechat_api'
# http://mp.weixin.qq.com/wiki/17/fa4e1434e57290788bde25603fa2fcbd.html

x = WechatApi.new

p x.error_meaning(42001)
