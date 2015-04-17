-- Saves the number of messages from a user and implements anti-spam

do


local socket = require('socket') 
local _file_settings = './data/spam.lua'
local _settings


function update_user_settings(msg)
  -- Save user to stats table
  local from_id = tostring(msg.from.id)
  local to_id = tostring(msg.to.id)
  local user_name = get_name(msg)
  -- print ('New message from '..user_name..'['..from_id..']'..' to '..to_id)
  -- If last name is nil dont save last_name.
  local user_last_name = msg.from.last_name
  local user_print_name = msg.from.print_name
  if _settings[to_id] == nil then
    -- print ('New stats key to_id: '..to_id)
    _settings[to_id] = {}
  end
  if _settings[to_id][from_id] == nil then
    -- print ('New stats key from_id: '..to_id)
    _settings[to_id][from_id] = {
      user_id = from_id,
      name = user_name,
      last_name = user_last_name,
      print_name = user_print_name,
      msg_num = 1
    }
  else
    -- print ('Updated '..to_id..' '..from_id)
    local actual_num = _settings[to_id][from_id].msg_num
    _settings[to_id][from_id].msg_num = actual_num + 1
    _settings[to_id][from_id].user_id = from_id
    _settings[to_id][from_id].last_name = user_last_name
  end
end


function read_file_settings( )
  local f = io.open(_file_settings, "r+")
  -- If file doesn't exists
  if f == nil then
    -- Create a new empty table
    print ('Created user SPAM stats file '.._file_settings)
    serialize_to_file({ enabled={} }, _file_settings)
  else
    print ('SPAM stats loaded: '.._file_settings)
    f:close() 
  end
  return loadfile (_file_settings)()
end


local function process_settings()
  -- Erase the counters
  for to_id,to  in pairs(_settings) do
    for from_id,from in pairs(_settings[to_id]) do
      _settings[to_id][from_id].msg_num = 0
    end
  end

  -- Save stats to file
  serialize_to_file(_settings, _file_settings)
end


local function get_settings_status( msg )
  -- vardump(stats)
  local text = ""
  local to_id = tostring(msg.to.id)
  local rank = {}

  -- Show spam limit setting
  if _settings.enabled ~= nil and _settings.enabled[to_id] ~= nil and _settings.enabled[to_id].limit ~= nil then
    text = text.."SPAM LIMIT ENFORCED: ".._settings.enabled[to_id].limit.."\n"
  end

  for id, user in pairs(_settings[to_id]) do
    table.insert(rank, user)
  end

  table.sort(rank, function(a, b) 
      if a.msg_num and b.msg_num then
        return a.msg_num > b.msg_num
      end
    end
  )

  for id, user in pairs(rank) do
    -- Previous versions didn't save that
    user_id = user.user_id or ''
    print(">> ", id, user.name)
    if user.last_name == nil then
      text = text..user.name.." ["..user_id.."]: "..user.msg_num.."\n"
    else
      text = text..user.name.." "..user.last_name.." ["..user_id.."]: "..user.msg_num.."\n"
    end
  end
  print("usuarios: "..text)
  return text
end


local function enable_limit(id, limit)
  if _settings.enabled == nil then
    _settings.enabled = {}
  end
  _settings.enabled[id] = {
    limit = limit
  }
  process_settings()
  local text = "SPAM message limit set to "..limit.." per 5 minute interval. Message counters have been reset."
  print(text)
  return text
end


local function run(msg, matches)
  print ("Spam command: "..matches[1])
  if matches[1] == "stats" then
    if msg.to.type == 'chat' or is_sudo(msg) then
      return get_settings_status(msg)
    else
      return 'Stats works only chats'
    end
  elseif matches[1] == "limit" then
    return enable_limit(tostring(msg.to.id), tonumber(matches[2]))
  elseif matches[1] == "blocked" then
    return "SPAM BLOCKED: "..matches[2]
  elseif matches[1] == "reset" then
    process_settings()
  else 
    update_user_settings(msg)
  end
end


local function filter_spam(msg)
  -- Allow privileged users
  if is_sudo(msg) then return msg end

  -- Check if SPAM blocking is enabled
  local from_id = tostring(msg.from.id)
  local to_id = tostring(msg.to.id)
  
  if _settings.enabled[to_id] == nil then return msg end
  if _settings[to_id] == nul then return msg end
  if _settings.enabled[to_id].limit ~= nil and _settings[to_id][from_id] ~= nil then
    -- BLOCK message
    if _settings.enabled[to_id].limit == _settings[to_id][from_id].msg_num then
      text = "Message limit of ".._settings.enabled[to_id].limit.." was exceeded."
      msg.text = "!spam blocked "..text
      print("SPAM BLOCKED: "..text)
    end
    -- BLOCK silently
    if _settings.enabled[to_id].limit < _settings[to_id][from_id].msg_num then
      msg.text = ""
    end
    -- Increase counter here
    local actual_num = _settings[to_id][from_id].msg_num
    _settings[to_id][from_id].msg_num = actual_num + 1
  end

  -- Always return message
  return msg
end


_settings = read_file_settings()


return {
  description = "Plugin to implement anti-SPAM.", 
  usage = "!spam stats: Returns SPAM statistics",
  patterns = {
    "^!spam (stats)$",
    "^!spam (reset)$",
    "^!spam (blocked) (.*)$",
    "^!spam (limit) ([0-9]+)$",
    "^!spam (notext) (enable|disable)$",
    "^!spam (noimages) (enable|disable)$",
    ".*"
    }, 
  run = run,
  cron = process_settings,
  pre_process = filter_spam
}


end
