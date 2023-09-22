local MODE = {}

MODE.name = "Homicide"

function MODE:GetLocalizedName()
    return ""
end

function MODE:GetLocalizedDesc()
    return ""
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
    end

    // Selecting a random player as a traitor
    local traitor = table.Random(plys)
    traitor:SetTeam(2)
end

return MODE