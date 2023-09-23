local MODE = {}

MODE.name = "Homicide"

function MODE:GetLocalizedName()
    return homegrad.GetPhrase("gmname_homicide")
end

function MODE:GetLocalizedDesc()
    return homegrad.GetPhrase("gmdesc_homicide")
end

local function randomModel()
    local rand = math.random(0,100)

    if rand >= 50 then
        return "models/player/group01/male_0" .. math.random(1,9) .. ".mdl"
    else
        return "models/player/group01/female_0" .. math.random(1,6) .. ".mdl"
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
    local traitor = table.Random(plys)
    traitor:SetTeam(2)
end

return MODE