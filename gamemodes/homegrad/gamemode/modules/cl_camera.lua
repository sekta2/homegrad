local lerped_ang

hook.Add("CalcView","hg.calcview",function(ply,origin,angles,fov,znear,zfar)

    local head = ply:LookupBone(homegrad.limbs["head"][1])
    local eye = ply:GetAttachment(ply:LookupAttachment("eyes"))
    local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))

    local ft = FrameTime() * 15

    local vpos = eye.Pos + eye.Ang:Up() * 2 + eye.Ang:Forward() * 1
    local vang = ply:GetAimVector():Angle()

    lerped_ang = LerpAngle(ft,lerped_ang or vang,vang)

    ply:ManipulateBoneScale(head,Vector(0,0,0))

    local view = {}

    view.origin = vpos
    view.angles = lerped_ang
    view.fov = fov
    view.drawviewer = true

    return view
end)