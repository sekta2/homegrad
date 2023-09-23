homegrad = {}

function homegrad.print(val)
    print("[Homegrad] " .. val)
end

function homegrad.client(path)
    homegrad.print("Loading " .. path)
    include(path)
end

homegrad.client("languane.lua")

homegrad.client("shared.lua")