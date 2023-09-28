local MODE = {}

MODE.name = "Homicide"
MODE.startsounds = {"snd_jack_hmcd_disaster.mp3","snd_jack_hmcd_shining.mp3","snd_jack_hmcd_panic.mp3","snd_jack_hmcd_deathmatch.mp3"}
MODE.teams = {
    [1] = {
        name = "Innocent",
        color = Color(155,155,155)
    },
    [2] = {
        name = "Traitor",
        color = Color(155,55,55)
    },
    [3] = {
        name = "Police",
        color = Color(0,55,155)
    }
}

function MODE:GetLocalizedName()
    return homegrad.GetPhrase("gmname_homicide")
end

function MODE:GetLocalizedDesc(teamid)
    return teamid == 1 and homegrad.GetPhrase("hc_innocent_lore") or
    teamid == 2 and homegrad.GetPhrase("hc_traitor_lore") or
    teamid == 3 and homegrad.GetPhrase("hc_police_lore") or
    "???"
end

function MODE:GetLocalizedRole(teamid)
    local you = homegrad.GetPhrase("hg_you")
    return teamid == 1 and you .. " " .. homegrad.GetPhrase("hc_innocent") or
    teamid == 2 and you .. " " .. homegrad.GetPhrase("hc_traitor") or
    teamid == 3 and you .. " " .. homegrad.GetPhrase("hc_police") or
    "???"
end

function MODE:GetAlivePlayers()
    local innocents = homegrad.HGetTeamPlayers(1)
    local police = homegrad.HGetTeamPlayers(3)

    local alive = 0

    for _,ply in pairs(innocents) do if ply:Alive() then alive = alive + 1 end end
    for _,ply in pairs(police) do if ply:Alive() then alive = alive + 1 end end

    return alive
end

if SERVER then
    util.AddNetworkString("hc.wintext")

    local function randomModel()
        local rand = math.random(0,100)

        if rand >= 50 then
            return "models/player/group01/male_0" .. math.random(1,9) .. ".mdl", "male"
        else
            return "models/player/group01/female_0" .. math.random(1,6) .. ".mdl", "female"
        end
    end

    function MODE:SelectTraitor()
        local innocents = homegrad.HGetTeamPlayers(1)

        local traitor = table.Random(innocents)
        traitor:HSetTeam(2)
        traitor:Give("weapon_knife")
    end

    function MODE:SelectPolice()
        local innocents = homegrad.HGetTeamPlayers(1)

        if table.Count(innocents) > 1 then
            local policeman = table.Random(innocents)
            policeman:HSetTeam(3)
            policeman:Give("weapon_glock17")
            policeman:GiveAmmo(17 * 6,"9x19mm Parabellum")
        end
    end

    function MODE:GetWinner()
        local allalive = self:GetAlivePlayers()
        local traitor = homegrad.HGetTeamPlayers(2)[1]
        local traitoralive = traitor:Alive()

        return (traitoralive and allalive <= 0) and 1 or (not traitoralive and allalive > 0) and 2 or 3
    end

    function MODE:OnEndRound()
        local winner = self:GetWinner()
        local traitor = homegrad.HGetTeamPlayers(2)[1]
        net.Start("hc.wintext")
            net.WriteUInt(winner,4)
            net.WriteEntity(traitor)
        net.Broadcast()
    end

    function MODE:OnPlayerDeath(victim,inflictor,attacker)
        local victeam = victim:HGetTeam()

        if victeam == 2 then
            homegrad.EndRound()
        elseif self:GetAlivePlayers() <= 0 then
            homegrad.EndRound()
        end
    end

    function MODE:SetUp()
        local plys = player.GetAll()

        // Making everyone innocent
        for _,ply in pairs(plys) do
            ply:HSetTeam(1)
            local model,gender = randomModel()
            local tblname = table.Random(homegrad.names[gender])
            local name,localname = tblname[1],tblname[2]
            ply:SetModel(model)
            ply:SetGender(gender)
            ply:SetHName(name,localname)
            local color = HSVToColor(math.random(0,360),1,0.5)
            ply:SetPlayerColor(Color(color.r,color.g,color.b):ToVector())
            ply:Give("weapon_fists")
        end

        // Selecting a random player as a traitor
        self:SelectTraitor()

        // Selecting a random player as a police
        if math.random(0,100) >= 50 then
            for i = 1, math.Rand(1,2) do // 1 or 2 policeman's
                self:SelectPolice()
            end
        end
    end
else
    net.Receive("hc.wintext",function()
        local winner = net.ReadUInt(4)
        local traitor = net.ReadEntity()
        local traitorhas = homegrad.GetPhrase("hc_traitorwas")
        if winner == 1 then
            chat.AddText(color_white,homegrad.GetPhrase("hc_traitor_won"))
            chat.AddText(color_white,traitorhas," ",traitor:Name())
        elseif winner == 2 then
            chat.AddText(color_white,homegrad.GetPhrase("hc_innocent_won"))
            chat.AddText(color_white,traitorhas," ",traitor:Name())
        else
            chat.AddText(color_white,homegrad.GetPhrase("hc_friendship_won"))
            chat.AddText(color_white,traitorhas," ",traitor:Name())
        end
    end)
end

return MODE