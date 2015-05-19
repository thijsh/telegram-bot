do


local memebase = "http://memebase.davidvanerkelens.nl/templates.php"


function getRandomMeme(attempt)
  attempt = attempt or 0
  attempt = attempt + 1

  local res,status = http.request(memebase)

  if status ~= 200 then return nil end
  print("Result is"..res)
  local data = string.match(res, 'img src="[^"]+')

  -- The memebase sometimes returns an empty result
  if not data and attempt < 10 then
    print('Cannot get those memes, trying another time...')
    return getRandomMeme(attempt)
  end

  url = string.sub(data[ math.random( #data ) ], 10)
  print('Random meme: '..url)
  return url
end


function run(msg, matches)
  local url = nil
  url = getRandomMeme()

  if url ~= nil then
    local receiver = get_receiver(msg)
    send_photo_from_url(receiver, url)
  else
    return 'Error getting meme for you, please try again later.'
  end
end


return {
  description = "Gets a random VIA meme",
  usage = {
    "!meme: Get a VIA meme (NSFW). 🔞"
  },
  patterns = {
    "^!meme$"
  },
  run = run
}


end