class FBEvents
  def getEvents()
    host = 'https://graph.facebook.com'
    ver = 'v2.2'
    param = 'events?access_token='
    param2 = '&format=json&limit=10'
    api = "#{host}/#{ver}/#{PAGE_ID}/#{param}#{USER_ACCESS_TOKEN}#{param2}"
    uri = URI.parse(api)
    res = Net::HTTP.get_response(uri)
    return res
  end
end
