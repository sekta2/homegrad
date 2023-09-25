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

function homegrad.GetModeName()
    local curmode = homegrad.modes[homegrad.currentmode]
    return curmode:GetLocalizedName()
end

function homegrad.GetNextModeName()
    local curmode = homegrad.modes[homegrad.nextmode]
    return curmode:GetLocalizedName()
end

function homegrad.GetMRoleName(teamid)
    local curmode = homegrad.modes[homegrad.currentmode]
    return curmode:GetLocalizedRole(teamid)
end

function homegrad.GetMRoleDesc(teamid)
    local curmode = homegrad.modes[homegrad.currentmode]
    return curmode:GetLocalizedDesc(teamid)
end

function homegrad.GetModeStartSounds()
    local curmode = homegrad.modes[homegrad.currentmode]
    return curmode.startsounds
end

function homegrad.SetUpMode()
    local curmode = homegrad.modes[homegrad.currentmode]
    curmode:SetUp()
end