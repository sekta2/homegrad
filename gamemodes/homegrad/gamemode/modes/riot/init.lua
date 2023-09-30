local MODE = {}

MODE.name = "Riot"
MODE.startsounds = {"snd_jack_hmcd_disaster.mp3","snd_jack_hmcd_shining.mp3","snd_jack_hmcd_panic.mp3","snd_jack_hmcd_deathmatch.mp3"}
MODE.teams = {
    [1] = {
        name = "Police",
        color = Color(50,50,200)
    },
    [2] = {
        name = "Rebel",
        color = Color(220,160,50)
    }
}

function MODE:GetLocalizedName()
    return homegrad.GetPhrase("gmname_riot")
end

function MODE:GetLocalizedDesc(teamid)
    return teamid == 1 and homegrad.GetPhrase("ri_police_lore") or
    teamid == 2 and homegrad.GetPhrase("ri_rebel_lore") or
    "???"
end

function MODE:GetLocalizedRole(teamid)
    local you = homegrad.GetPhrase("hg_you")
    return teamid == 1 and you .. " " .. homegrad.GetPhrase("hc_police") or
    teamid == 2 and you .. " " .. homegrad.GetPhrase("ri_rebel") or
    "???"
end

function MODE:GetAliveTeam(teamid)
    local plys = homegrad.HGetTeamPlayers(teamid)

    local alive = 0

    for _,ply in pairs(plys) do if ply:Alive() then alive = alive + 1 end end

    return alive
end

if SERVER then
    util.AddNetworkString("riot.wintext")

    local function randomModel()
        local rand = math.random(0,100)

        if rand >= 50 then
            return "models/player/group01/male_0" .. math.random(1,9) .. ".mdl", "male"
        else
            return "models/player/group01/female_0" .. math.random(1,6) .. ".mdl", "female"
        end
    end

    local function randomModelPolice()
        return "models/kerry/nypd_v2/male_0" .. math.random(3,9) .. ".mdl", "male"
    end

    function MODE:GetWinner()
        local police = self:GetAliveTeam(1)
        local rebels = self:GetAliveTeam(2)

        return (police > 0 and rebels <= 0) and 1 or (rebels > 0 and police <= 0) and 2 or 3
    end

    function MODE:OnEndRound()
        local winner = self:GetWinner()
        net.Start("riot.wintext")
            net.WriteUInt(winner,4)
        net.Broadcast()
    end

    function MODE:OnPlayerDeath(victim,inflictor,attacker)
        local police = self:GetAliveTeam(1)
        local rebels = self:GetAliveTeam(2)

        if (police <= 0 and rebels > 0) or (rebels <= 0 and police > 0) then
            homegrad.EndRound()
        end
    end

    function MODE:SetUp()
        local plys = homegrad.GetNonSpectators()

        // Making half the players police and the other half rebels
        local del = math.Round(#plys / 2)
        local rand = math.random(0,100)
        for i,ply in pairs(plys) do
            local teamid = rand >= 50 and (i <= del and 1 or 2) or (i <= del and 2 or 1)
            ply:HSetTeam(teamid)
            local model,gender
            if teamid == 1 then model,gender = randomModelPolice()
            else model,gender = randomModel() end
            local tblname = table.Random(homegrad.names[gender])
            local name,localname = tblname[1],tblname[2]
            ply:SetModel(model)
            ply:SetGender(gender)
            ply:SetHName(name,localname)
            local color = self.teams[teamid].color:ToVector()
            ply:SetPlayerColor(color)
            ply:Give("weapon_fists")
            ply:AllowFlashlight(true)
            if teamid == 1 then
                local randw = math.Rand(0,100)
                if randw < 70 then
                    ply:Give("weapon_glock17") ply:GiveAmmo(17 * 3, "9x19mm Parabellum")
                elseif randw < 35 then
                    ply:Give("weapon_m16") ply:GiveAmmo(30, "5,56x45mm") -- Че ебанутый
                end
            end
        end
    end
else
    net.Receive("riot.wintext",function()
        local winner = net.ReadUInt(4)
        if winner == 1 then
            chat.AddText(color_white,homegrad.GetPhrase("ri_police_won"))
        elseif winner == 2 then
            chat.AddText(color_white,homegrad.GetPhrase("ri_rebel_won"))
        else
            chat.AddText(color_white,homegrad.GetPhrase("hc_friendship_won"))
        end
    end)
end

return MODE
