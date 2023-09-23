homegrad.currentmode = "homicide"
homegrad.nextmode = "homicide"
homegrad.modes = {}

local _,dirs = file.Find("homegrad/gamemode/modes/*","LUA")

if SERVER then
    for _,path in pairs(dirs) do
        local pathtoinit = "modes/" .. path .. "/init.lua"

        AddCSLuaFile(pathtoinit)
        local MODE = include(pathtoinit)
        homegrad.modes[path] = MODE

        homegrad.print("Added mode: " .. MODE.name)
    end
else
    for _,path in pairs(dirs) do
        local pathtoinit = "modes/" .. path .. "/init.lua"

        local MODE = include(pathtoinit)
        homegrad.modes[path] = MODE

        homegrad.print("Added mode: " .. MODE.name)
    end
end

function homegrad.SetUpMode()
    local curmode = homegrad.modes[homegrad.currentmode]

    curmode:SetUp()
end