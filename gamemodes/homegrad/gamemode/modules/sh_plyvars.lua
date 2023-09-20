homegrad.limbs = {
    ["head"] = "ValveBiped.Bip01_Head1",
    ["neck"] = "ValveBiped.Bip01_Neck1",
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