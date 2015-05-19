do


-- local memebase = "http://memebase.davidvanerkelens.nl/templates.php"
local memebase = "http://memebase.davidvanerkelens.nl/memes.php?id=0%20OR%201%20=%201"
local memeurlprefix = "http://memebase.davidvanerkelens.nl/"

function getRandomMeme(attempt)
  attempt = attempt or 0
  attempt = attempt + 1

  local res,status = http.request(memebase)

  if status ~= 200 then return nil end
  local offset = math.random( string.len(res) ) 
  print("Length of file is "..string.len(res).." and offset "..offset)
  local i = string.find(res, "<img src='", offset)

  -- The memebase sometimes returns an empty result
  if not i and attempt < 10 then
    print('Cannot get those memes, trying another time...')
    return getRandomMeme(attempt)
  end

  local j = string.find(res, "'", i + 10)

  print("String pos "..i.." and "..j)
  local url = memeurlprefix..string.sub(res, i + 10, j - 1)

  -- url = string.sub(data[ math.random( #data ) ], 10)
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
