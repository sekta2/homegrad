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
    {"weapon_glock17",0.05},
    {"weapon_knife",0.3},
    {"weapon_bar",0.5},
}

hook.Add("PropBreak","hg.boxlootspawn",function(ply,ent)
    local model = ent:GetModel()
    local centerpos = ent:OBBCenter()
    local random = math.random(0,100)
    local lootents = homegrad.GetModeLootTable() and homegrad.GetModeLootTable() or homegrad.lootents
    local randent,_ = table.Random(lootents)

    if homegrad.lootprops[model] and random <= (50 * randent[2]) and homegrad.GetModeCanLoot() then
        local entl = ents.Create(randent[1])
        entl:SetPos(ent:GetPos() + centerpos)
        entl:Spawn()
    end
end)