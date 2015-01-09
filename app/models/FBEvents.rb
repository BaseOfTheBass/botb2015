require 'cgi'

USER_ACCESS_TOKEN = 'CAAJZCxtUnA0oBAOcMS2WZCLqh1FQqNiPltRT78HdeOM6gbgFdLpYf1W7GIPg5rzyPWn3WtenEt91A1RIfYkifTpuNIOLPc4zUwJV0Pvh6wmwkd8UsHCHBfckZCeWZC0Pvino6DZBRWfR7mtSVthZCZBTPjmNwM6ILxs7Su4LJjxqOie6dmqZAUaxLSm4N1V2rsnZAxT8g1iU9OKXXvzVB4ZCxPrPZCx7KecACYZD'
APP_TOKEN = 'gWTyONiQPDZnQ5mBB8nr4kRcRkk'
APP_ID = '703441909777226'
APP_SECRET = 'b8edcf4d4a8a7bf7f1f6002bdf6832f9'
PAGE_ID = '660820424013022'

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
