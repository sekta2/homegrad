homegrad = {}

function homegrad.print(val)
    print("[Homegrad] " .. val)
end

function homegrad.server(path)
    homegrad.print("Loading " .. path)
    include(path)
end

function homegrad.client(path)
    AddCSLuaFile(path)
end

function homegrad.shared(path)
    homegrad.print("Loading " .. path)
    AddCSLuaFile(path)
    include(path)
end

homegrad.shared("util.lua")
homegrad.shared("teams.lua")
homegrad.client("fonts.lua")
homegrad.shared("language.lua")
homegrad.shared("modes.lua")
homegrad.shared("rounds.lua")
homegrad.shared("commands.lua")

homegrad.shared("shared.lua")
homegrad.client("cl_init.lua")