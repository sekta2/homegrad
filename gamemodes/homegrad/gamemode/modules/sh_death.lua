local meta = FindMetaTable("Player")

function meta:GetDeathSpectator()
    return self:GetNWBool("hg.deathspectator",true)
end

if SERVER then
    hook.Add("PlayerDeathSound","hg.deathsound",function(ply)
        return true
    end)

    function meta:SetDeathSpectator(bool)
        self:SetNWBool("hg.deathspectator",bool)
    end
else
    hook.Add("DrawDeathNotice","hg.hidedeathnotice",function()
        return false
    end)
end