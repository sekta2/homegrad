homegrad.modes = {}

CreateConVar("hg_random_modes","1",FCVAR_LUA_SERVER)

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

function homegrad.GetCurrentMode()
    return GetGlobalString("hg.currentmode","homicide")
end

function homegrad.GetNextMode()
    return GetGlobalString("hg.nextmode","homicide")
end

function homegrad.GetModeName()
    local curmode = homegrad.modes[homegrad.GetCurrentMode()]
    return curmode:GetLocalizedName()
end

function homegrad.GetNextModeName()
    local curmode = homegrad.modes[homegrad.GetNextMode()]
    return curmode:GetLocalizedName()
end

function homegrad.GetMRoleName(teamid)
    local curmode = homegrad.modes[homegrad.GetCurrentMode()]
    return curmode:GetLocalizedRole(teamid)
end

function homegrad.GetMRoleDesc(teamid)
    local curmode = homegrad.modes[homegrad.GetCurrentMode()]
    return curmode:GetLocalizedDesc(teamid)
end

function homegrad.GetModeStartSounds()
    local curmode = homegrad.modes[homegrad.GetCurrentMode()]
    return curmode.startsounds
end

function homegrad.GetModeTeams()
    local curmode = homegrad.modes[homegrad.GetCurrentMode()]
    return curmode.teams
end

function homegrad.GetModeTeamName(id)
    local teams = homegrad.GetModeTeams()
    return teams[id] and teams[id].name or "???"
end

function homegrad.GetModeTeamColor(id)
    local teams = homegrad.GetModeTeams()
    return teams[id] and teams[id].color or "???"
end

function homegrad.GetModeCanLoot()
    local curmode = homegrad.modes[homegrad.GetCurrentMode()]
    return curmode.lootenabled
end

function homegrad.GetModeLootTable()
    local curmode = homegrad.modes[homegrad.GetCurrentMode()]
    return curmode.loottable
end

function homegrad.SetUpMode()
    local curmode = homegrad.modes[homegrad.GetCurrentMode()]
    curmode:SetUp()
end

if SERVER then
    function homegrad.ModeOnDeath(victim,inflictor,attacker)
        local curmode = homegrad.modes[homegrad.GetCurrentMode()]
        curmode:OnPlayerDeath(victim,inflictor,attacker)
    end

    function homegrad.ModeOnEnd()
        local curmode = homegrad.modes[homegrad.GetCurrentMode()]
        curmode:OnEndRound()
    end

    function homegrad.SetCurrentMode(curmode)
        SetGlobalString("hg.currentmode",curmode)
    end

    function homegrad.SetNextMode(nextmode)
        SetGlobalString("hg.nextmode",nextmode)
    end

    function homegrad.ProcessNextMode()
        local random = GetConVar("hg_random_modes"):GetBool()
        if random then
            homegrad.SetCurrentMode(homegrad.GetNextMode())
            local _,nextround = table.Random(homegrad.modes)
            homegrad.SetNextMode(nextround)
        else
            homegrad.SetCurrentMode(homegrad.GetNextMode())
        end
    end
end