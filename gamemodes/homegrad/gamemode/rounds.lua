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

    function homegrad.MakeSpectateAll()
        for _,ply in pairs(homegrad.GetNonSpectators()) do
            ply:SetDeathSpectator(true)
            ply:KillSilent()
        end
    end

    function homegrad.CleanAllPlayers()
        for _,ply in pairs(homegrad.GetNonSpectators()) do
            ply:SetDeathSpectator(false)
            ply:UnSpectate()
            ply:StripAmmo()
            ply:StripWeapons()
            ply:Spawn()

            ply:SetHealth(150)
            ply:SetMaxHealth(150)
            ply:SetWalkSpeed(100)
            ply:SetRunSpeed(250)
            ply:SetSlowWalkSpeed(75)
            ply:SetLadderClimbSpeed(75)
            ply:SetJumpPower(200)

            ply:SetCanZoom(false)
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

        timer.Simple(0,function()
            if not homegrad.CheckRoundCanStart() then
                homegrad.MakeSpectateAll()
            end
        end)

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
        timer.Simple(3,function()
            if IsValid(victim) and (not victim:Alive()) then
                victim:SetDeathSpectator(true)
            end
        end)
        homegrad.ModeOnDeath(victim,inflictor,attacker)
    end)

    hook.Add("PlayerDisconnected", "hg.roundplayerdisconnect", function(ply)
        ply:Kill()
    end)

    hook.Add("PlayerDeathThink","hg.rounddeaththink",function(ply)
        if ply:GetDeathSpectator() then ply:Spectate(OBS_MODE_ROAMING) end
        return false
    end)

    hook.Add("AllowPlayerPickup","hg.allowpickup", function(ply,ent)
        if ent:GetPhysicsObject():GetMass() >= 15 then
            return false
        end
        return
    end)

    hook.Add("PlayerInitialSpawn","hg.roundinitialplayerspawn",function(ply,_)
        timer.Simple(0, function()
            ply:KillSilent()
        end)

        ply:SetDeathSpectator(true)

        if not homegrad.IsRoundStarted() and homegrad.CheckRoundCanStart() and homegrad.GetNonSpecsPlayersNum() < 3 then
            homegrad.StartRound()
        end
    end)

    hook.Add("UpdateAnimation","hg.updateanim",function(ply,event,data)
        ply:RemoveGesture(ACT_GMOD_NOCLIP_LAYER)
    end)
else
    net.Receive("hg.roundstarted",function()
        local snd = net.ReadString()
        surface.PlaySound(snd)
    end)
end