require_relative 'basics'
# http://mp.weixin.qq.com/wiki/5/963fc70b80dc75483a271298a76a8d59.html

class WechatApi
  def get_materials(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/material/batchget_material'
    params = {access_token: token}
    validate_required_fields(body_hash, :type, :offset, :count)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end

  def add_permanent_material(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/material/add_material'
    params = {access_token: token}
    resp_of_post(url:url, params:params, body: body_hash)       # don't .to_json because it contains file data
  end

  def add_permanent_news(token, body_hash)
    url = 'https://api.weixin.qq.com/cgi-bin/material/add_news'
    params = {access_token: token}
    validate_required_fields(body_hash, :articles)
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end

  def download_voice_or_img(token, media_id, file_path)
    url = 'https://api.weixin.qq.com/cgi-bin/material/get_material'
    params = {access_token: token}
    body = {media_id: media_id}.to_json
    download_file(url:url,
                  method: :post,
                  params: params,
                  body: body,
                  file_path: file_path
    )
  end

  private

  def download_file(info)
    validate_required_fields(info, :url, :params, :body, :file_path)
    file = File.open(info[:file_path], 'w')

    method = info[:method] || :get
    req = Typhoeus::Request.new(info[:url], method: method, params:info[:params], body: info[:body])

    req.on_headers do |resp|
      raise RequestError if resp.code != 200
      p resp.headers
    end
    req.on_body{|chunk| file.write(chunk)}
    req.on_complete{|resp| file.close}
    req.run

    file
  end

end


