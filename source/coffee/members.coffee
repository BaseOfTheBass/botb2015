class Members

  $loading = null
  $target = null

  constructor: (args)->
    return @

  getList: (target) ->
    $target = target
    $target.innerHTML = ''
    par = this
    url ="/api/members"
    $loading = helper.setLoading $target
    helper.getJson url, par.gotList
    return $loading

  gotList: (json) ->
    json = JSON.parse json

    # remove loading content
    helper.removeLoading($loading)
    for item in json.members
      makeView({
        'id'       : item.id,
        'name'     : item.name,
        'image'    : item.image,
        'bio'      : item.bio,
        'tags'     : item.tags,
        'media'    : item.media
      })
    return

  makeView = (memberData) ->
    create = (el) ->
      return document.createElement(el)

    # CONTEINER
    $container = create('div')
    $container.className = 'member'

    $icon = create('div')
    $icon.className = 'memberIcon'

    $img = create('img')
    $img.id = "memberImage_#{memberData.id}"

    $name = create('h3')
    $name.innerHTML = memberData.name

    $icon.appendChild $img
    $icon.appendChild $name
    $container.appendChild $icon

    # INFO
    $info = create('div')
    $info.className = 'memberInfo'

    $tags = create('p')
    $tags.className = 'memberTags'
    $tags.innerHTML = memberData.tags.join(', ')

    $bio = create('p')
    $bio.id = "memberDescription_#{memberData.id}"
    $bio.className = 'memberDescription'
    $bio.innerHTML = "-"

    $info.appendChild $bio
    $info.appendChild $tags

    if memberData.media
      $media = create('ul')
      $media.className = "memberLinks"

      for key, value of memberData.media
        $mediaItem = create('li')
        url = makeMediaUrl key, value
        $mediaItem.innerHTML = "<a href='#{url}'>#{key}</a>"
        $media.appendChild $mediaItem

      $info.appendChild $media

    $container.appendChild $info

    if memberData.media
      $product = document.createElement('div')
      $product.className = 'memberProduct'
      $product.id = "memberProduct_#{memberData.id}"
      $container.appendChild $product

      getLatestProduct $product, memberData

    $target.appendChild $container
    getBio memberData

  makeMediaUrl = (media,account) ->
    switch media
      when 'soundcloud'
        return "https://soundcloud.com/#{account}"
      when 'mixcloud'
        return "https://mixcloud.com/#{account}"
      when 'vimeo'
        return "https://vimeo.com/#{account}"
    return null

  getLatestProduct = ($target, medias) ->
    media_count = 0
    json= "{\"id\":#{medias.id},"
    json += '"accounts":['
    for key, value of medias.media
      media_count += 1
      json+= "{\"media\":\"#{key}\",\"account\":\"#{value}\"},"

    json = json.slice(0, -1)
    json += ']}'
    if media_count <= 0
      json = "{\"id\":#{media.id},\"accounts\":[]}"
    json = encodeURIComponent(json)

    url ="/api/latest/#{json}?max=1"
    helper.getJson url, GotLatestProduct
    return json

  window.GotLatestProduct = (json) ->
    json  = JSON.parse json
    if !json.accounts
      return this
    url   = json.accounts[0].url
    thumb = json.accounts[0].thumbnail
    title_str = json.accounts[0].title

    # remove loading content
    wrap = document.createElement("a")
    wrap.href=url
    imageWrap = document.createElement("p")
    imageWrap.className = "memberProductImage"
    imageWrap.innerHTML = "<img src='#{thumb}' width='120'>"
    title = document.createElement("h3")
    title.innerHTML = helper.htmlize title_str

    wrap.appendChild(imageWrap)
    wrap.appendChild(title)
    $product = helper.$id "memberProduct_#{json.id}"
    $product.appendChild wrap
    return

  getBio = (data) ->
    url = "/api/bio/#{data.media.mixcloud}"
    helper.getJson url, gotBio, {data: data}
    return

  window.gotBio = (json,data) ->
    json  = JSON.parse json
    data  = data.data
    id = data.id
    bio = json.biog
    image = json.pictures.large
    $img = helper.$id "memberImage_#{data.id}"
    $bio = helper.$id "memberDescription_#{data.id}"

    $img.src = image
    $bio.innerHTML = helper.htmlize bio

    return

module.exports = Members
