if SERVER then
    hook.Add("PlayerDeathSound","hg.deathsound",function(ply)
        return true
    end)
else
    hook.Add("DrawDeathNotice","hg.hidedeathnotice",function()
        return false
    end)
end