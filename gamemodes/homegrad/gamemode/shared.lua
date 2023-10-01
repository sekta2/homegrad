DeriveGamemode("sandbox")

homegrad = homegrad or {}

// Modules

local sv = file.Find("homegrad/gamemode/modules/sv_*.lua","LUA")
local sh = file.Find("homegrad/gamemode/modules/sh_*.lua","LUA")
local cl = file.Find("homegrad/gamemode/modules/cl_*.lua","LUA")

if SERVER then
    for _,path in pairs(sv) do
        homegrad.server("modules/" .. path)
    end

    for _,path in pairs(sh) do
        homegrad.shared("modules/" .. path)
    end

    for _,path in pairs(cl) do
        homegrad.client("modules/" .. path)
    end
else
    for _,path in pairs(sh) do
        homegrad.client("modules/" .. path)
    end

    for _,path in pairs(cl) do
        homegrad.client("modules/" .. path)
    end
end