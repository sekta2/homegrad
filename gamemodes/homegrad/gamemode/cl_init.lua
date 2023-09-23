homegrad = {}

function homegrad.print(val)
    print("[Homegrad] " .. val)
end

function homegrad.client(path)
    homegrad.print("Loading " .. path)
    include(path)
end

homegrad.client("language.lua")
homegrad.client("modes.lua")

homegrad.client("shared.lua")