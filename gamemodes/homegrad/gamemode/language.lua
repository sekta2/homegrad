homegrad.lang = "en"
homegrad.langs = {}

local langsfiles = file.Find("homegrad/gamemode/lang/*.lua","LUA")

if SERVER then
    for _,path in pairs(langsfiles) do
        AddCSLuaFile("lang/" .. path)
        local LANG = include("lang/" .. path)
        homegrad.langs[LANG.name] = LANG

        homegrad.print("Added language: " .. LANG.name)
    end
else
    for _,path in pairs(langsfiles) do
        local LANG = include("lang/" .. path)
        homegrad.langs[LANG.name] = LANG

        homegrad.print("Added language: " .. LANG.name)
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

function homegrad.LanguageSync()
    local gmodlang = GetConVar("gmod_language"):GetString()

    if homegrad.langs[gmodlang] then
        homegrad.lang = gmodlang
    else
        homegrad.lang = "en"
    end
end

homegrad.LanguageSync()

function LanguageChanged(lang)
    if homegrad.langs[lang] then
        homegrad.lang = lang
    end
end