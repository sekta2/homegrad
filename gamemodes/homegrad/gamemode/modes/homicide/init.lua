local MODE = {}

MODE.name = "Homicide"
MODE.startsounds = {"snd_jack_hmcd_disaster.mp3","snd_jack_hmcd_shining.mp3","snd_jack_hmcd_panic.mp3"}

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
    local innocents = team.GetPlayers(1)
    local police = team.GetPlayers(3)

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
            return "models/player/group01/male_0" .. math.random(1,9) .. ".mdl"
        else
            return "models/player/group01/female_0" .. math.random(1,6) .. ".mdl"
        end
    end

    function MODE:SelectTraitor()
        local innocents = team.GetPlayers(1)

        local traitor = table.Random(innocents)
        traitor:SetTeam(2)
    end

    function MODE:SelectPolice()
        local innocents = team.GetPlayers(1)

        if table.Count(innocents) > 1 then
            local policeman = table.Random(innocents)
            policeman:SetTeam(3)
        end
    end

    function MODE:FinishRound(winner,traitor)
        net.Start("hc.wintext")
            net.WriteUInt(winner,4)
            net.WriteEntity(traitor)
        net.Broadcast()

        homegrad.EndRound()
    end

    function MODE:OnPlayerDeath(victim,inflictor,attacker)
        local victeam = victim:Team()
        local traitor = team.GetPlayers(2)[1]

        if victeam == 2 then
            self:FinishRound(2,traitor)
        elseif self:GetAlivePlayers() <= 0 then
            self:FinishRound(1,traitor)
        else
            self:FinishRound(3)
        end
    end

    function MODE:SetUp()
        local plys = player.GetAll()

        // Creating primary teams
        team.SetUp(1, "Innocent", Color(155,155,155), false)
        team.SetUp(2, "Traitor", Color(155,0,0), false)
        team.SetUp(3, "Police", Color(0,55,155), false)

        // Making everyone innocent
        for _,ply in pairs(plys) do
            ply:SetTeam(1)
            ply:SetModel(randomModel())
            local color = HSVToColor(math.random(0,360),1,0.5)
            ply:SetPlayerColor(Color(color.r,color.g,color.b):ToVector())
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
        local won, wons = homegrad.GetPhrase("hg_won"), homegrad.GetPhrase("hg_wons")
        local traitorhas = homegrad.GetPhrase("hc_traitorwas")
        if winner == 1 then
            chat.AddText(color_white,won," ",homegrad.GetPhrase("hc_traitor"))
            chat.AddText(color_white,traitorhas," ",traitor:Name())
        elseif winner == 2 then
            chat.AddText(color_white,wons," ",homegrad.GetPhrase("hc_innocents"))
            chat.AddText(color_white,traitorhas," ",traitor:Name())
        else
            chat.AddText(color_white,won," ",homegrad.GetPhrase("hc_friendship"))
        end
    end)
end

return MODE