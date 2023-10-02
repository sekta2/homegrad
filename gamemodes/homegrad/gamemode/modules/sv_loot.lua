homegrad.lootprops = {
    ["models/props_junk/wood_crate001a.mdl"] = true,
    ["models/props_junk/wood_crate001a_damaged.mdl"] = true,
    ["models/props_junk/wood_crate002a.mdl"] = true,
    ["models/props_junk/cardboard_box001a.mdl"] = true,
    ["models/props_junk/cardboard_box001b.mdl"] = true,
    ["models/props_junk/cardboard_box002a.mdl"] = true,
    ["models/props_junk/cardboard_box002b.mdl"] = true,
    ["models/props_junk/cardboard_box003a.mdl"] = true,
    ["models/props_junk/cardboard_box003b.mdl"] = true,
    ["models/props_c17/FurnitureDresser001a.mdl"] = true,
    ["models/props_c17/FurnitureDrawer001a.mdl"] = true,
    ["models/props_c17/FurnitureCupboard001a.mdl"] = true,
    ["models/props_interiors/Furniture_Desk01a.mdl"] = true,
}

homegrad.lootents = {
    "weapon_glock17"
}

hook.Add("EntityRemoved","hg.boxlootspawn",function(ent,fullUpd)
    local model = ent:GetModel()
    local centerpos = ent:OBBCenter()
    local random = math.random(0,100)
    print(homegrad.lootprops[model] and random >= 50)
    if homegrad.lootprops[model] and random >= 50 then
        local randent,_ = table.Random(homegrad.lootents)
        local entl = ents.Create(randent)
        entl:SetPos(ent:GetPos() + centerpos)
        entl:Spawn()
    end
end)