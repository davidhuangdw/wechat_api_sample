require_relative 'basics'
# http://mp.weixin.qq.com/wiki/3/ecfed6e1a0a03b5f35e5efac98e864b7.html

class WechatApi
  # types:
  # getusersummary, getusercumulate
  # getarticlesummary, getarticletotal, getuserread, getuserreadhour, getusershare, getusersharehour
  # getupstreammsg, getupstreammsghour, getupstreammsgweek, getupstreammsgmonth, getupstreammsgdist, getupstreammsgdistweek, getupstreammsgdistmonth
  # getinterfacesummary, getinterfacesummaryhour

  def stats(token, body_hash)
    params = {access_token: token}
    validate_required_fields(body_hash, :type, :begin_date, :end_date)
    url = "https://api.weixin.qq.com/datacube/#{body_hash[:type]}"

    body_hash = {
        begin_date: fmt_date(body_hash[:begin_date]),
        end_date: fmt_date(body_hash[:end_date])
    }
    resp_of_post(url:url, params:params, body: body_hash.to_json)
  end

  private
  def fmt_date(time)
    time.to_time.strftime('%Y-%m-%d')
  end
end
