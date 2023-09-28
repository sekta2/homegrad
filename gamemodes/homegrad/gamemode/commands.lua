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

homegrad.CreateCommand("endround","Ending the round",function(ply,args)
    if ply:IsSuperAdmin() then
        homegrad.EndRound()
    end
end)

homegrad.CreateCommand("fendround","Ending the round",function(ply,args)
    if ply:IsSuperAdmin() then
        homegrad.ForceEndRound()
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