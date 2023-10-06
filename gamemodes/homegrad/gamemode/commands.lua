homegrad.commands = homegrad.commands or {}

function homegrad.CreateCommand(name,helptext,callback)
    homegrad.commands[name] = {
        name = name,
        helptext = helptext,
        callback = callback
   }
end

homegrad.CreateCommand("test","This is test",function(ply,args)
    ply:ChatPrint("Hi! This is test.")
end)

homegrad.CreateCommand("levelnext","Select next mode",function(ply,args)
    if ply:IsAdmin() then -- It will also return true if the player is Player:IsSuperAdmin by default. https://wiki.facepunch.com/gmod/Player:IsAdmin
        local mode = args[2]
        homegrad.SetNextMode(homegrad.modes[mode] and mode or "homicide")
        homegrad.print(ply:Nick() .. " Changed next mode to " .. tostring(mode))
    else
        ply:ChatPrint("You are not an admin.")
    end
end)

homegrad.CreateCommand("levelstart","Start the round",function(ply,args)
    if ply:IsAdmin() then
        homegrad.StartRound()
        homegrad.print(ply:Nick() .. " Started round")
    else
        ply:ChatPrint("You are not an admin.")
    end
end)

homegrad.CreateCommand("levelend","Ending the round",function(ply,args)
    if ply:IsAdmin() then
        homegrad.EndRound()
        homegrad.print(ply:Nick() .. " Ended round")
    else
        ply:ChatPrint("You are not an admin.")
    end
end)

homegrad.CreateCommand("forcelevelend","Forcing round end",function(ply,args)
    if ply:IsAdmin() then
        homegrad.ForceEndRound()
        homegrad.print(ply:Nick() .. " Forced round end")
    else
        ply:ChatPrint("You are not an admin.")
    end
end)

if SERVER then
    hook.Add("PlayerSay","hg.commandsexec",function(ply,text,teamb)
        local exploded = homegrad.ExplodeCommand(text)
        local command = string.Replace(exploded[1],"!","")
        if string.len(command) > 1 and homegrad.commands[command] then
            timer.Simple(0,function() homegrad.commands[command].callback(ply,exploded) end)
        end
    end)
end