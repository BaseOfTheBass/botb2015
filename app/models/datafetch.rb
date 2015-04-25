class Datafetch

  def initialize()
    @now = Time.now
    @cacheDir =  File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__)))) + "/cache"
  end

  def getData(channel,account)
    now_iso = CGI.escape(@now.iso8601)
    apis = {
      'vimeo'=>"http://vimeo.com/api/v2/#{account}/videos.json",
      'soundcloud'=>"http://api.soundcloud.com/users/#{account}/tracks.json?client_id=660f0a677cd5572e6c06dc951c79d052",
      'mixcloud' =>"http://api.mixcloud.com/#{account}/cloudcasts/"
    }
    # undefined channel
    if !apis[channel] then
      return nil
    end

    # cached data
    cache = isCached(channel,account)
    if cache != nil then
      return cache
    end

    # new data fetching
    res = requestApi(apis[channel])
    cacheData(channel,account, res.body)
    return res.body
  end

  def requestApi(url)
    uri = URI.parse(url)
    res = Net::HTTP.get_response(uri)
    return res
  end

  def cacheData(channel,account, json)
    timestamp = @now.strftime("%Y%m%d%H")
    cachelog = "#{@cacheDir}/#{channel}_#{account}_log.txt"
    filename = "#{@cacheDir}/#{channel}_#{account}.json"
    File.open(cachelog, "w") do |file|
      file.write(timestamp)
    end
    File.open(filename, "w") do |file|
      file.write(json)
    end
    return json
  end

  def isCached(channel,account)
    timestamp = @now.strftime("%Y%m%d%H")
    cachelog = "#{@cacheDir}/#{channel}_#{account}_log.txt"
    filename = "#{@cacheDir}/#{channel}_#{account}.json"
    cached_time = "000000"
    if File.exist?(cachelog) then
      File.open(cachelog,"r") do |file|
        cached_time = file.read
      end
    end

    if cached_time == timestamp then
       return File.read(filename, :encoding => Encoding::UTF_8)
    end

    return nil
  end

  def parseVimeo(max=10,account)
    vimeo = JSON.parse(getData('vimeo',account))
    count = 0
    ret = Array.new
    vimeo.each do |item|
      ret[count] = {
        'title'     => item['title'],
        'date'      => item['upload_date'],
        'timestamp' => item['upload_date'].gsub(/([^0-9])/,""),
        'url'       => item['url'],
        'desc'      => item['description'],
        'thumbnail' => item['thumbnail_small'],
        'tags'      => item['tags'],
        'channel'   => 'vimeo'
      }
      if count >= max then
        break
      end
      count += 1
    end
    return ret
  end

  def parseSoundcloud(max=10,account)
    sc = JSON.parse(getData('soundcloud',account))
    count = 0
    ret = Array.new
    sc.each do |item|
      ret[count] = {
        'title'     => item['title'],
        'date'      => item['created_at'].gsub(/\//,"-").gsub(/ \+0000$/,""),
        'timestamp' => item['created_at'].gsub(/ \+0000$/,"").gsub(/([^0-9])/,""),
        'url'       => item['permalink_url'],
        'desc'      => item['description'],
        'thumbnail' => item['artwork_url'],
        'tags'      => item['tag_list'].gsub(/ /, ","),
        'channel'   => 'soundcloud'
      }
      if count >= max then
        break
      end
      count += 1
    end
    return ret
  end

  def parseMixcloud(max=10,account)
    sc = JSON.parse(getData('mixcloud',account))
    count = 0
    ret = Array.new
    sc['data'].each do |item|
      tags = ""
      item['tags'].each do |tagval|
        tags = "#{tags},#{tagval['name']}"
      end
      ret[count] = {
        'title'     => item['name'],
        'date'      => item['created_time'].gsub(/T/," ").gsub(/Z$/,""),
        'timestamp' => item['created_time'].gsub(/([^0-9])/,""),
        'url'       => item['url'],
        'desc'      => "",
        'thumbnail' => item['pictures']['large'],
        'tags'      => tags,
        'channel'   => 'mixcloud'
      }
      if count >= max then
        break
      end
      count += 1
    end
    return ret
  end

  def getLatestProducts(max,accounts)
    accounts = URI.unescape(accounts)
    accounts = JSON.parse(accounts)
    latest = Array.new
    accounts['accounts'].each do |media|
      if media['media'] == "soundcloud" then
        latest = latest.concat(parseSoundcloud(max,media['account']))
      end
      if media['media'] == "mixcloud" then
        latest = latest.concat(parseMixcloud(max,media['account']))
      end

      if media['media'] == "vimeo" then
        latest = latest.concat(parseVimeo(max,media['account']))
      end
    end

    if latest.empty? then
      return "{\"id\":#{accounts['id']}}"
    end

    products = {id: accounts['id'], accounts: latest}
    ret = latest.sort_by { |hash| -hash['timestamp'].to_i }
    ret = {id: accounts['id'], accounts: ret[0]}
    return ret.to_json
  end

end
