homegrad.lang = "en"
homegrad.langs = {}

local langsfiles = file.Find("homegrad/gamemode/lang/*.lua","LUA")

if SERVER then
    for _,path in pairs(langsfiles) do
        AddCSLuaFile("lang/" .. path)
        local LANG = include("lang/" .. path)
        homegrad.langs[LANG.name] = LANG

        homegrad.print("Added languane: " .. LANG.name)
    end
else
    for _,path in pairs(langsfiles) do
        local LANG = include("lang/" .. path)
        homegrad.langs[LANG.name] = LANG

        homegrad.print("Added languane: " .. LANG.name)
    end
end

function homegrad.GetPhrase(name)
    local curlang = homegrad.lang
    local phrases = homegrad.langs[curlang].phrases

    --[[
        If there is a dictionary, then if there is a word in it, then give the word, otherwise idk.
        If there is a word in the English dictionary then give the word, otherwise idk.
        It's not bad code, it's just very complicated
    --]]
    return phrases and (phrases[name] and phrases[name] or "idk") or homegrad.langs["en"][name] and homegrad.langs["en"][name] or "idk"
end