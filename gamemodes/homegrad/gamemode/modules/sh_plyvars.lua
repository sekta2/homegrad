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

homegrad.names = {
    ["male"] = {
        {"Tommy","hg_name1"},
        {"Frankie","hg_name2"},
        {"Johnny","hg_name3"},
        {"Tony","hg_name4"},
        {"Vinny","hg_name5"},
        {"Joey","hg_name6"},
        {"Bobby","hg_name7"},
        {"Jimmy","hg_name8"},
        {"Charlie","hg_name9"},
        {"Eddie","hg_name10"},
    },
    ["female"] = {
        {"Sophia","hg_name11"},
        {"Isabella","hg_name12"},
        {"Olivia","hg_name13"},
        {"Mia","hg_name14"},
        {"Ava","hg_name15"},
        {"Emma","hg_name16"},
        {"Amelia","hg_name17"},
        {"Harper","hg_name18"},
        {"Charlotte","hg_name19"},
        {"Lily","hg_name20"},
    }
}

local meta = FindMetaTable("Player")

function meta:GetLimbCondition(name)
    if homegrad.limbs[name] then
        return self:GetNWInt("hg.conditionlimb." .. name,100)
    else
        return 0
    end
end

function meta:SetHName(name,localized)
    self:SetNWString("hg.name",name or "Human")
    self:SetNWString("hg.namelocalized",localized or "hg_defaultname")
end

function meta:GetHName()
    return self:GetNWString("hg.name","Human")
end

function meta:GetHNameLocalized()
    return self:GetNWString("hg.namelocalized","hg_defaultname")
end

function meta:SetGender(gender)
    self:SetNWString("hg.gender",gender == "male" and "male" or "female")
end

function meta:GetGender()
    return self:GetNWString("hg.gender","male")
end