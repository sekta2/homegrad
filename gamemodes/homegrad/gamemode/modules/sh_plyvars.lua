homegrad.limbs = {
    ["head"] = {"ValveBiped.Bip01_Head1",HITGROUP_HEAD},
    ["neck"] = {"ValveBiped.Bip01_Neck1",HITGROUP_HEAD},
    ["chest"] = {"ValveBiped.Bip01_Neck1",HITGROUP_CHEST},
    ["stomach"] = {"ValveBiped.Bip01_Neck1",HITGROUP_STOMACH},
    ["leftarm"] = {"ValveBiped.Bip01_Neck1",HITGROUP_LEFTARM},
    ["rightarm"] = {"ValveBiped.Bip01_Neck1",HITGROUP_RIGHTARM},
    ["leftleg"] = {"ValveBiped.Bip01_Neck1",HITGROUP_LEFTLEG},
    ["rightleg"] = {"ValveBiped.Bip01_Neck1",HITGROUP_RIGHTLEG},
}

local meta = FindMetaTable("Player")

function meta:GetLimbCondition(name)
    if homegrad.limbs[name] then
        return self:GetNWInt("hg.conditionlimb." .. name,100)
    else
        return 0
    end
end

if SERVER then
    
else
    
end