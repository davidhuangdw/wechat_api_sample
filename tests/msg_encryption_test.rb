require 'typhoeus'
require 'active_support/all'

def signature(token, timestamp, nonce)
  checksum = [token, timestamp, nonce].sort.join
  Digest::SHA1.hexdigest(checksum)
end

ENCODING_AES_KEY = 'I97Y6pmHU56mx5TAHdaJTSsV9bylieHJlhYI2GCMKj6'
APP_ID = 'wx896e08f0cac4122b'
TOKEN = 'david'

msg = '<xml> <Encrypt><![CDATA[vD4ZrebSNqGXyZfRIM36Dx5EzNlDgT0mG5YkIwg+Zd4QKmmTF6NTH5t+Y2uK VfIN1wDjorK8ydXhqRDvIpwMgE9WdyS115TGSouRos33G1+QkK2rrxbRjdti IMHLBLJDTTM5mGQXkWpVl+xRhuk5YOzNN3hdv9Aek/IBC7WztPGI9TLNqcdl Vmwlcl0nrCb/ulrbFtHCWD03Avhaa1tX2gs0HOF4L/uey8oItXwVdM7HgnbF argSCQq85XKoFzhpNQpy2GWPqDS+0RktsmiTlP85a1lcLSPHBvfwtL07Kwd9 BGWENcngdE7fCPExGEfRk6JzHZfQemxC2MONubJLZd/ioTvjaYTxg5OAOwQy UDkmzVbJNwI6stZRGs0dLT6YNItgoCwoK46Ioq8Y5Sym6mXLpO4ljNjauR5R +FXM9UyVlXo+1AUvX4TGHDINK/kW9dmeTeqFeskaTi6buy/7iMCNdei/16WB PB73Xemepc96VuOZSLTwwV8n21kOwxFYC0lHyac6/3J6PZhPcwYdkWl3Zefc 6LyBqfFP2dE59SNgkownRo3Bv1mNEycwAtCtXOvZO7vUA6CpxCFfOvOW4lwc YdmJfW/dAgvI/IAFin5fCe9HFSQwhv9Kgd5ZghhJbwQ0pHiYu298t0yI0BAa gYSxk0gYq1mmA9il5JQL16mAHHZGxZqaJ71Mf70/KYwtD4SQvqeoxCwD+vZt V7omoH3OZ+JaoIptFMsTPxDa4p1W2dibebz/2NUclAz4b8kfM13VU7F1f4Va MUA9hOzSVv6hVf1KrMRUwaBUjJAEe6RT0VU2Bsbv+p0LZ+DCqRzfog517/0V m98jL68/WRlPp8hy2yj7V4LRUqAHCI2F7fRk0RXYVj57bYkXFPO+nlpE0zq9 3i1fH0REQ0tIdSErToOtmvstbmKtEqY6TZvWcidTmxQyabvncocYHeYfy5I6 Dl2eutpLFPlt1wIwnZZRYyzZ3p72Cxw940w/hRIeZgkiFh98kiInhSYu8nFK 74cSaZ5OrZEunq22HbEHbr+4zJGmeFe49oLmkrpxifTunBJsDEi3CePEQINh xr75ajgqCbc2czklj5muGqYIIU7hGTde5Nf4iMRMY4gHVm+p/WuhYSEC80Mw 69vNrinHV/l3Rd3BzCyIVlGDFBrECKXa7RgfSqNMDE1kw3F/uEc9+0yySAZG jWPFdJ7Oja4LJbLRP85u+EBDw1YucBp1tTRyGjzw5bU4L0B+EU9IkXGjt8A=]]> </Encrypt> <MsgSignature><![CDATA[82efc8e03a44ce739aa641a9c22333f2b55a8b3c]]></MsgSignature> <TimeStamp>1436984252</TimeStamp> <Nonce><![CDATA[1234]]></Nonce> </xml>'

msg_hash = Hash.from_xml(msg)['xml'].symbolize_keys
p msg_hash

msg_signature, timestamp, nonce = msg_hash.values_at(:MsgSignature, :TimeStamp, :Nonce)
params = {timestamp: msg_hash[:TimeStamp],
          nonce: msg_hash[:Nonce],
          signature: signature(TOKEN, timestamp, nonce),
          encrypt_type: 'aes',
          msg_signature: msg_signature,
}

body = msg
url = 'http://push_url.mzou.dev.cloud.vitrue.com/receive'
resp = Typhoeus.post(url, params:params, body:body)
p resp.body
