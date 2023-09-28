function homegrad.IsRoundStarted()
    return GetGlobalBool("hg.roundstarted",false)
end

function homegrad.GetRoundStartTime()
    return GetGlobalFloat("hg.roundtime",0)
end

function homegrad.GetRoundTime()
    return CurTime() - homegrad.GetRoundStartTime()
end

if SERVER then
    util.AddNetworkString("hg.roundstarted")

    function homegrad.PlayAllSound(snd)
        net.Start("hg.roundstarted")
            net.WriteString(snd)
        net.Broadcast()
    end

    function homegrad.CleanAllPlayers()
        for _,ply in pairs(player.GetAll()) do
            ply:StripAmmo()
            ply:StripWeapons()
            ply:Spawn()
        end
    end

    function homegrad.SetRoundTime(time)
        SetGlobalFloat("hg.roundtime",time)
    end

    function homegrad.StartRound()
        game.CleanUpMap()
        homegrad.CleanAllPlayers()
        homegrad.SetRoundTime(CurTime())
        homegrad.SetUpMode()
        homegrad.PlayAllSound(table.Random(homegrad.GetModeStartSounds()))
        SetGlobalBool("hg.roundstarted",true)
    end

    function homegrad.StartNextRound()
        homegrad.ProcessNextMode()
        homegrad.StartRound()
    end

    function homegrad.EndRound()
        SetGlobalBool("hg.roundstarted",false)
        homegrad.ModeOnEnd()

        timer.Simple(5,function()
            homegrad.StartNextRound()
        end)
    end

    function homegrad.ForceEndRound()
        SetGlobalBool("hg.roundstarted",false)
        homegrad.ModeOnEnd()

        homegrad.StartNextRound()
    end

    hook.Add("PlayerDeath","hg.rounddeath",function(victim,inflictor,attacker)
        if not homegrad.IsRoundStarted() then return end
        homegrad.ModeOnDeath(victim,inflictor,attacker)
    end)
else
    net.Receive("hg.roundstarted",function()
        local snd = net.ReadString()
        surface.PlaySound(snd)
    end)
end