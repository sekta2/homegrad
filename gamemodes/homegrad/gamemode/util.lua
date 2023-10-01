local plymeta = FindMetaTable("Player")

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

function plymeta:HGEyeTrace(dist)
    local eye = self:GetAttachment(self:LookupAttachment("eyes"))
    if not eye then return end

    local tr = {}
    tr.start = eye.Pos
    tr.endpos = tr.start + self:GetAngles():Forward() * dist or 80
    tr.filter = self
    return util.TraceLine(tr)
end

if CLIENT then
    function draw.Circle(x, y, radius, seg)
        local cir = {}

        cir[#cir + 1] = {x = x, y = y, u = 0.5, v = 0.5}
        for i = 0, seg do
            local a = math.rad((i / seg) * -360)
            cir[#cir + 1] = {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5}
        end

        local a = math.rad(0) -- This is needed for non absolute segment counts
        -- perfomance moment
        cir[#cir + 1] = {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5}

        surface.DrawPoly(cir)
    end
end