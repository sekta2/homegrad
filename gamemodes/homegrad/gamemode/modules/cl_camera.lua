local lerped_ang

hook.Add("CalcView","hg.calcview",function(ply,origin,angles,fov,znear,zfar)
    local head = ply:LookupBone(homegrad.limbs["head"][1])
    local eye = ply:GetAttachment(ply:LookupAttachment("eyes"))
    local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
    local ragdoll = ply:GetRagdollEntity()

    local ft = FrameTime() * 15

    if not ply:Alive() and IsValid(ragdoll) then
        local raghead = ragdoll:LookupBone(homegrad.limbs["head"][1])
        local rageye = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))

        local vpos = rageye.Pos + rageye.Ang:Up() * 2 + rageye.Ang:Forward() * 1
        local vang = rageye.Ang

        lerped_ang = LerpAngle(ft,lerped_ang or vang,vang)

        ragdoll:ManipulateBoneScale(raghead,Vector(0,0,0))

        local view = {}

        view.origin = vpos
        view.angles = lerped_ang
        view.fov = fov
        view.drawviewer = false

        return view
    else
        local vpos = eye.Pos + eye.Ang:Up() * 2 + eye.Ang:Forward() * 1
        local vang = ply:GetAimVector():Angle()

        // Scope
        local weapon = ply:GetActiveWeapon()
        local weppos, wepang
        if IsValid(weapon) and (weapon.IsHomegrad and weapon:IsScope()) then
            local pos, ang = weapon:GetScopePos()
            weppos = hand.Pos + hand.Ang:Up() * pos.x - hand.Ang:Forward() * pos.y + hand.Ang:Right() * pos.z
            wepang = hand.Ang + ang
        end

        lerped_ang = LerpAngle(ft,lerped_ang or vang,wepang or vang)

        ply:ManipulateBoneScale(head,Vector(0,0,0))

        local size = Vector(6,6,0)
        local tr = {}
        tr.start = origin
        tr.endpos = vpos
        tr.mins = -size
        tr.maxs = size

        tr.filter = ply
        size = size / 2
        tr.mins = -size
        tr.maxs = size

        tr = util.TraceHull(tr)

        local pos = ply:GetPos()
        pos[3] = tr.HitPos[3] + 1
        local trace = util.TraceLine({start = ply:EyePos(),endpos = pos,filter = ply,mask = MASK_SOLID_BRUSHONLY})
        tr.HitPos[3] = trace.HitPos[3] - 1
        vpos = tr.HitPos

        local view = {}

        view.origin = weppos or vpos
        view.angles = lerped_ang
        view.fov = fov
        view.drawviewer = true

        return view
    end
end)