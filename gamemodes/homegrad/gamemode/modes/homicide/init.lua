local MODE = {}

MODE.name = "Homicide"

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

return MODE