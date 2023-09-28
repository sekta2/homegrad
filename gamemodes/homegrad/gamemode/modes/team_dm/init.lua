local MODE = {}

MODE.name = "Team Deathmatch"
MODE.startsounds = {"snd_jack_hmcd_deathmatch.mp3"}
MODE.teams = {
    [1] = {
        name = "Counter-Terrorist",
        color = Color(93,121,174)
    },
    [2] = {
        name = "Terrorist",
        color = Color(222,155,53)
    }
}

function MODE:GetLocalizedName()
    return homegrad.GetPhrase("gmname_teamdm")
end

function MODE:GetLocalizedDesc(teamid)
    return teamid == 1 and homegrad.GetPhrase("dm_contr_lore") or
    teamid == 2 and homegrad.GetPhrase("dm_terror_lore") or
    "???"
end

function MODE:GetLocalizedRole(teamid)
    local you = homegrad.GetPhrase("hg_you")
    return teamid == 1 and you .. " " .. homegrad.GetPhrase("dm_contr") or
    teamid == 2 and you .. " " .. homegrad.GetPhrase("dm_terror") or
    "???"
end

function MODE:GetAliveTeam(teamid)
    local plys = homegrad.HGetTeamPlayers(teamid)

    local alive = 0

    for _,ply in pairs(plys) do if ply:Alive() then alive = alive + 1 end end

    return alive
end

if SERVER then
    util.AddNetworkString("tdm.wintext")

    local function randomModel()
        local rand = math.random(0,100)

        if rand >= 50 then
            return "models/player/group01/male_0" .. math.random(1,9) .. ".mdl", "male"
        else
            return "models/player/group01/female_0" .. math.random(1,6) .. ".mdl", "female"
        end
    end

    function MODE:GetWinner()
        local contr = self:GetAliveTeam(1)
        local terror = self:GetAliveTeam(2)

        return (contr > 0 and terror <= 0) and 1 or (terror > 0 and contr <= 0) and 2 or 3
    end

    function MODE:OnEndRound()
        local winner = self:GetWinner()
        net.Start("tdm.wintext")
            net.WriteUInt(winner,4)
        net.Broadcast()
    end

    function MODE:OnPlayerDeath(victim,inflictor,attacker)
        local contr = self:GetAliveTeam(1)
        local terror = self:GetAliveTeam(2)

        if (contr <= 0 and terror > 0) or (terror <= 0 and contr > 0) then
            homegrad.EndRound()
        end
    end

    function MODE:SetUp()
        local plys = player.GetAll()

        // Making everyone innocent
        local del = math.floor(#plys / 2)
        local rand = math.random(0,100)
        for i,ply in pairs(plys) do
            local teamid = rand >= 50 and (i < del and 1 or 2) or (i > del and 1 or 2)
            ply:HSetTeam(teamid)
            local model,gender = randomModel()
            local tblname = table.Random(homegrad.names[gender])
            local name,localname = tblname[1],tblname[2]
            ply:SetModel(model)
            ply:SetGender(gender)
            ply:SetHName(name,localname)
            local color = self.teams[teamid].color:ToVector()
            ply:SetPlayerColor(color)
            ply:Give("weapon_fists")
            if teamid == 1 then
                ply:Give("weapon_m16") ply:GiveAmmo(30 * 6, "5,56x45mm")
                ply:Give("weapon_glock17") ply:GiveAmmo(17 * 6, "9x19mm Parabellum")
            else
                ply:Give("weapon_akm") ply:GiveAmmo(30 * 6, "7,62x39mm")
                ply:Give("weapon_pl14") ply:GiveAmmo(14 * 6, "9x19mm Parabellum")
            end
        end
    end
else
    net.Receive("tdm.wintext",function()
        local winner = net.ReadUInt(4)
        if winner == 1 then
            chat.AddText(color_white,homegrad.GetPhrase("dm_contr_won"))
        elseif winner == 2 then
            chat.AddText(color_white,homegrad.GetPhrase("dm_terror_won"))
        else
            chat.AddText(color_white,homegrad.GetPhrase("hc_friendship_won"))
        end
    end)
end

return MODE