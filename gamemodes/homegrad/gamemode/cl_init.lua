homegrad = {}

function homegrad.print(val)
    print("[Homegrad] " .. val)
end

function homegrad.client(path)
    homegrad.print("Loading " .. path)
    include(path)
end

homegrad.client("util.lua")
homegrad.client("teams.lua")
homegrad.client("fonts.lua")
homegrad.client("language.lua")
homegrad.client("modes.lua")
homegrad.client("rounds.lua")
homegrad.client("commands.lua")

homegrad.client("shared.lua")