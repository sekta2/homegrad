local mul = 1

hook.Add("Think","hg.mullerp",function()
    mul = FrameTime() / engine.TickInterval()
end)

function LerpFT(lerp,source,set)
    return Lerp(math.min(lerp * mul,1),source,set)
end

function LerpVectorFT(lerp,source,set)
    return LerpVector(math.min(lerp * mul,1),source,set)
end

function LerpAngleFT(lerp,source,set)
    return LerpAngle(math.min(lerp * mul,1),source,set)
end

function homegrad.ExplodeCommand(str)
    local len = #str
    if len > 100 then return end
    local args = {}
    local mult = false
    local word = ""
    for i = 1, len do
        local c = str:sub(i,i)
        if c == '"' then mult = not mult continue end
        if c == ' ' and not mult then args[#args + 1] = word word = "" continue end
        word = word .. c
    end
    args[#args + 1] = word
    return args
end