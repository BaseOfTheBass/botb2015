class CacheControl
  def initialize(host)
    @redis = Redis.new
  end

  def set(key,val)
    @redis.set(key, val)
  end

  def get(key)
    vlue = @redis.get(key)
    return value
  end

end
