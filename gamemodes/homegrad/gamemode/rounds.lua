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
        for _,ply in pairs(homegrad.GetNonSpectators()) do
            ply:UnSpectate()
            ply:StripAmmo()
            ply:StripWeapons()
            ply:Spawn()
            ply:SetWalkSpeed(100)
            ply:SetRunSpeed(250)
        end
    end

    function homegrad.SetRoundTime(time)
        SetGlobalFloat("hg.roundtime",time)
    end

    function homegrad.CheckRoundCanStart()
        return homegrad.GetNonSpecsPlayersNum() >= 2
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
            if homegrad.CheckRoundCanStart() then
                homegrad.StartNextRound()
            end
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

    hook.Add("PlayerDeathThink","hg.rounddeaththink",function(ply)
        ply:Spectate(OBS_MODE_ROAMING)
        return false
    end)

    hook.Add("AllowPlayerPickup","hg.allowpickup", function(ply,ent)
        if ent:GetPhysicsObject():GetMass() >= 15 then
            return false
        end
        return
    end)

    hook.Add("PlayerInitialSpawn","hg.roundinitialplayerspawn",function(ply,_)
        ply:Kill()
        ply:Spectate(OBS_MODE_ROAMING)
        if not homegrad.IsRoundStarted() and homegrad.CheckRoundCanStart() and homegrad.GetNonSpecsPlayersNum() < 3 then
            homegrad.StartRound()
        end
    end)
else
    net.Receive("hg.roundstarted",function()
        local snd = net.ReadString()
        surface.PlaySound(snd)
    end)
end