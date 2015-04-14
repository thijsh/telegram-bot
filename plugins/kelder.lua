local kelder_file = './data/kelder.lua'
local kelder_table
local niveau = 0;



function read_kelder_file()
    --[[
    return {}

    local f = io.open(kelder_file, "r+")

    if f == nil then
        reset_kelder()
    else
        print ('Kelder niveau loaded: '..kelder_file)
        f:close()
    end
    return loadfile (kelder_file)()
    ]]
end


function reset_kelder()
    niveau = 0
    --[[]
    print ('Created a new quotes file on '..kelder_file)
    serialize_to_file({}, kelder_file)
    ]]
end


function save_kelder(from_id, change)
    niveau = niveau + change
    if change == 1 then
        return "Niveau gestegen naar "..niveau
    else
        return "Niveau gezakt naar "..niveau
    end

    --[[
    local to_id = tostring(msg.to.id)

    if msg.text:sub(11):isempty() then
        return "Usage: !addquote quote"
    end

    if kelder_table == nil then
        kelder_table = {}
    end

    if kelder_table[to_id] == nil then
        print ('New quote key to_id: '..to_id)
        kelder_table[to_id] = {}
    end

    local quotes = kelder_table[to_id]
    quotes[#quotes+1] = msg.text:sub(11)

    serialize_to_file(kelder_table, kelder_file)

    return "Niveau "..niveau
    ]]
end


function kelder_niveau()
    return "Kelder niveau is nu "..niveau
    --[[
    local to_id = tostring(msg.to.id)
    local quotes_phrases

    kelder_table = read_kelder_file()
    quotes_phrases = kelder_table[to_id]

    return quotes_phrases[math.random(1,#quotes_phrases)]
    ]]
end



function run(msg, matches)
    if msg.text == "!kelder +1" then
        return save_kelder(1)
    elseif msg.text == "!kelder -1" then
        return save_kelder(-1)
    elseif msg.text == "!kelder reset" then
        return reset_kelder()
    else
        return kelder_niveau()
    end
end


return {
    description = "Kelder niveau plugin, voor het bijhouden van het VIA kelder niveau",
    usage = "!kelder +1, !kelder -1, !kelder reset, !kelder niveau",
    patterns = {
        "^!kelder(.*)$"
    },
    run = run
}
