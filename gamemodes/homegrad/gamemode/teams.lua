local meta = FindMetaTable("Player")

function meta:HGetTeam()
    return self:GetNWInt("hg.team",1)
end

function meta:IsSpectator()
    return self:GetNWBool("hg.spectator",false)
end

function homegrad.GetSpectators()
    local plys = {}

    for _, ply in pairs(player.GetAll()) do
        if ply:IsSpectator() then plys[#plys + 1] = ply end
    end

    return plys
end

function homegrad.GetNonSpectators()
    local plys = {}

    for _, ply in pairs(player.GetAll()) do
        if not ply:IsSpectator() then plys[#plys + 1] = ply end
    end

    return plys
end

function homegrad.GetSpectatorsNum()
    return #homegrad.GetSpectators()
end

function homegrad.GetNonSpecsPlayersNum()
    return player.GetCount() - #homegrad.GetSpectators()
end

function homegrad.HGetTeamPlayers(id)
    local plys = {}

    for _, ply in pairs(player.GetAll()) do
        if ply:HGetTeam() == id then plys[#plys + 1] = ply end
    end

    return plys
end

function homegrad.HGetTeamPlayersNum(id)
    local plys = 0

    for _, ply in pairs(player.GetAll()) do
        if ply:HGetTeam() == id then plys = plys + 1 end
    end

    return plys
end

if SERVER then
    function meta:HSetTeam(id)
        self:SetNWInt("hg.team",id)
    end

    function meta:SetSpectator(bool)
        self:SetNWBool("hg.spectator",bool)
    end
end