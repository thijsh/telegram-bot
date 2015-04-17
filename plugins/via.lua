do


local via_logo = "https://svia.nl/static/img/via.png"

function run(msg, matches)
  local url = via_logo

  if url ~= nil then
    local receiver = get_receiver(msg)
    send_photo_from_url(receiver, url)
  else
    return 'Error getting VIA logo for you, please try again later.'
  end
end


return {
  description = "Post VIA represent logo each time via is mentioned",
  usage = {
    "something something VIA: Show the VIA logo"
  },
  patterns = {
    "VIA",
    "Via",
    "via"
  },
  run = run
}


end
