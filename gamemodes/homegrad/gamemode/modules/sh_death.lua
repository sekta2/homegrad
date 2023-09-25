if SERVER then
    hook.Add("PlayerDeathSound","hg.deathsound",function(ply)
        return true
    end)

    hook.Add("PlayerDeathThink","hg.deaththink",function(ply)
        return false
    end)
else
    hook.Add("DrawDeathNotice","hg.hidedeathnotice",function()
        return false
    end)
end