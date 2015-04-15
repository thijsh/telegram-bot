do


local dicks = {
  "http://i.imgur.com/A5IdNU7.jpg",
  "http://i.imgur.com/0pEACyI.jpg",
  "http://i.imgur.com/x2NNn9P.jpg",
  "http://i.imgur.com/9FA7NJr.jpg",
  "https://pbs.twimg.com/media/BkZjObxCUAAnhy0.jpg"
}

local nsfw = {
  "http://www.timothysykes.com/wp-content/uploads/2014/09/nsfw.jpg",
  "http://i528.photobucket.com/albums/dd324/geoffhanna/MMOtivational/nsfw.png",
  "http://cdn.theatlantic.com/static/mt/assets/science/nsfw.png",
  "http://rs1img.memecdn.com/warning-nsfw-you-little-rebel_o_1383433.jpg",
  "http://www.craftster.org/pictures/data/500/nsfw_warning.gif",
  "http://blog.joerenken.com/wp-content/uploads/2011/04/Parental-Advisory-Explicit-Content-Logo.gif"
}


function getRandomDicks()
  return dicks[ math.random( #dicks ) ]
end


function getRandomNSFW()
  return nsfw[ math.random( #nsfw ) ]
end


function run(msg, matches)
  local url = nil

  if matches[1] == "!dicks" then
    url = getRandomDicks()
  end

  if matches[1] == "!nsfw" then
    url = getRandomNSFW()
  end

  if url ~= nil then
    local receiver = get_receiver(msg)
    send_photo_from_url(receiver, url)
  else
    return 'Error getting dicks for you, please try again later.'
  end
end


return {
  description = "Gets a random dicks pic",
  usage = {
    "!dicks: Get a random dicks NSFW image. 🔞",
    "!nsfw: Get a random NSFW warning image."
  },
  patterns = {
    "^!dicks$",
    "^!nsfw$"
  },
  run = run
}


end
