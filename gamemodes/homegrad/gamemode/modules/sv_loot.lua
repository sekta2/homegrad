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
    // Loot class and mul of rarity
    {"weapon_glock17",0.2},
    {"weapon_knife",0.25},
    {"weapon_bar",0.3},
}

hook.Add("EntityRemoved","hg.boxlootspawn",function(ent,fullUpd)
    local model = ent:GetModel()
    local centerpos = ent:OBBCenter()
    local random = math.random(0,100)
    local randent,_ = table.Random(homegrad.lootents)

    if homegrad.lootprops[model] and random >= (50 * randent[2]) then
        local entl = ents.Create(randent[1])
        entl:SetPos(ent:GetPos() + centerpos)
        entl:Spawn()
    end
end)