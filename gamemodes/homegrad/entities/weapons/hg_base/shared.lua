SWEP.Base = "weapon_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "hg_weaponbase"
SWEP.IsHomegrad = true
SWEP.Reloading = false
SWEP.HudShow = 0

SWEP.HoldType = "ar2"
SWEP.RunHoldType = "passive"

SWEP.ReloadingTime = 2.5
SWEP.ReloadingTimer = 0

SWEP.NextShoot = 0
SWEP.ShootWait = 0.1

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 100
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = Sound("ak74/ak74_fp.wav")
SWEP.Primary.SoundDraw = Sound("ak74/ak74_draw.wav")
SWEP.Primary.EquipSound = Sound("ak74/ak74_cloth.wav")
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ScopePos = Vector(0,0,0)
SWEP.ScopeAng = Angle(0,0,0)
SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(0,0,0)

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:GetAmmoText()
    local ammo,ammobag = self:GetMaxClip1(), self:Clip1()

    if ammobag > ammo - 1 then
        return homegrad.GetPhrase("hg_full")
    elseif ammobag > ammo - ammo / 3 then
        return homegrad.GetPhrase("hg_almost_full")
    elseif ammobag > ammo / 3 then
        return homegrad.GetPhrase("hg_half")
    elseif ammobag >= 1 then
        return homegrad.GetPhrase("hg_almost_empty")
    elseif ammobag < 1 then
        return homegrad.GetPhrase("hg_empty")
    end
end

function SWEP:Equip(owner)
    owner:EmitSound(self.Primary.EquipSound)
end

function SWEP:IsReloading()
    return self:GetNWBool("hg.isreloading",false)
end

function SWEP:DrawHUD()
    show = math.Clamp(self.HudShow or 0,0,1)
    self.HudShow = Lerp(2 * FrameTime(),self.HudShow or 0,0)

    color_gray = Color(225,215,125,190 * show)
    color_gray1 = Color(225,215,125,255 * show)

    local ply = LocalPlayer()

    local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
    local pos = (hand.Pos + hand.Ang:Forward() * 7 + hand.Ang:Up() * 5 + hand.Ang:Right() * -1):ToScreen()

    local text = self:GetAmmoText()
    local ammo = self:GetMaxClip1()
    local ammomags = ply:GetAmmoCount(self:GetPrimaryAmmoType())

    local pos1,pos2 = self:GetDebugPos()

    if GetConVar("developer"):GetBool() then
        local pos11 = pos1:ToScreen()
        local pos22 = pos2:ToScreen()
        --[[surface.DrawLine(pos11.x, pos11.y, pos22.x, pos22.y)
        draw.DrawText("x", "hg.big", pos22.x, pos22.y, color_white, TEXT_ALIGN_RIGHT)
        draw.DrawText("+", "hg.big", pos11.x, pos11.y, color_white, TEXT_ALIGN_RIGHT)]]
        debugoverlay.Line(pos1, pos2, 5, color_whine, false)
        debugoverlay.Box(pos1, Vector(.5,.5,.5), Vector(-.5,-.5,-.5), 5, color_white, false)
        debugoverlay.Box(pos2, Vector(.5,.5,.5), Vector(-.5,-.5,-.5), 5, color_white, false)
    end

    draw.DrawText(homegrad.GetPhrase("hg_magazine") .. " | " .. text, "hg.big", pos.x, pos.y, color_gray1, TEXT_ALIGN_RIGHT)
    draw.DrawText(homegrad.GetPhrase("hg_magazines") .. " | " .. math.Round(ammomags / ammo), "hg.big", pos.x + 5, pos.y + 25, color_gray, TEXT_ALIGN_RIGHT)
end

function SWEP:IsScope()
    local ply = self:GetOwner()
    if ply:IsNPC() then return end

    return not ply:IsSprinting() and ply:KeyDown(IN_ATTACK2)
end

function SWEP:GetScopePos()
    return self.ScopePos, self.ScopeAng
end

function SWEP:CanPrimaryAttack()
    return self:Clip1() > 0 and self.NextShoot < CurTime() and not self:IsReloading() and not self:GetOwner():IsSprinting()
end

function SWEP:Deploy()
    self:EmitSound(self.Primary.SoundDraw)
end

function SWEP:SetDebugPos(pos1,pos2)
    self:SetNWVector("pos1",pos1)
    self:SetNWVector("pos2",pos2)
end

function SWEP:GetDebugPos()
    return self:GetNWVector("pos1",Vector(0,0,0)), self:GetNWVector("pos2",Vector(0,0,0))
end

function SWEP:FireBullet(dmg,numbul,spread)
    local ply = self:GetOwner()

    ply:LagCompensation(true)

    local obj = self:LookupAttachment("muzzle")
    local Attachment = self:GetOwner():GetActiveWeapon():GetAttachment(obj)

    local cone = self.Primary.Cone

    local shootOrigin = Attachment.Pos
    local vec = self.addPos or Vector(0,0,0)
    vec:Rotate(Attachment.Ang)
    shootOrigin:Add(vec)

    local shootAngles = Attachment.Ang
    local ang = self.addAng or Angle(0,0,0)
    shootAngles:Add(ang)

    local shootDir = shootAngles:Forward()

    local bullet = {}
    bullet.Num = self.NumBullet or 1
    bullet.Src = shootOrigin
    bullet.Dir = shootDir
    bullet.Spread = Vector(cone,cone,0)
    bullet.Force = self.Primary.Force / 40
    bullet.Damage = self.Primary.Damage * 4
    bullet.AmmoType = self.Primary.Ammo
    bullet.Attacker = ply
    bullet.Tracer = 1
    bullet.TracerName = self.Tracer or "Tracer"
    bullet.IgnoreEntity = not ply:IsNPC() and ply:GetVehicle() or ply

    bullet.Callback = function(owner,tr,dmgInfo)
        self:SetDebugPos(tr.StartPos,tr.HitPos)
        if self.Primary.Ammo == "buckshot" then
            local k = math.max(1 - tr.StartPos:Distance(tr.HitPos) / 750,0)
            dmgInfo:ScaleDamage(k)
        end

        local effectdata = EffectData()
        effectdata:SetEntity(tr.Entity)
        effectdata:SetOrigin(tr.HitPos)
        effectdata:SetStart(tr.StartPos)

        effectdata:SetSurfaceProp(tr.SurfaceProps)
        effectdata:SetDamageType(DMG_BULLET)
        effectdata:SetHitBox(tr.HitBox)

        util.Effect("Impact",effectdata,true,true)
    end

    if SERVER then
        self:TakePrimaryAmmo(1)
        ply:FireBullets(bullet)
    end
    self:SetLastShootTime()

    ply:LagCompensation(false)

    local effectdata = EffectData()
    effectdata:SetOrigin(shootOrigin)
    effectdata:SetAngles(shootAngles)
    effectdata:SetScale(self:IsScope() and 0.1 or 1)
    effectdata:SetNormal(shootDir)
    util.Effect(self.Efect or "MuzzleEffect",effectdata)
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end

    self:FireBullet(5,1,1)
    self.NextShoot = CurTime() + self.ShootWait
    self:EmitSound(self.Primary.Sound)

    self.HudShow = 3
end

function SWEP:SecondaryAttack()
    return false
end

function SWEP:Reload()
    local ply = self:GetOwner()

    self.HudShow = 5
    if self:Clip1() >= self:GetMaxClip1() or self:IsReloading() or ply:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then return end

    ply:SetAnimation(PLAYER_RELOAD)
    self:SetNWBool("hg.isreloading",true)
    self.ReloadingTimer = CurTime() + self.ReloadingTime
end

function SWEP:Think()
    local ply = self:GetOwner()

    if ply:IsSprinting() then
        self:SetHoldType(self.RunHoldType)
    else
        self:SetHoldType(self.HoldType)
    end
    if self:IsReloading() and self.ReloadingTimer <= CurTime() then
        self:SetNWBool("hg.isreloading",false)

        local need = self:GetMaxClip1() - self:Clip1()
        need = math.min(need,ply:GetAmmoCount(self:GetPrimaryAmmoType()))
        ply:RemoveAmmo(need,self:GetPrimaryAmmoType())
        self:SetClip1(self:Clip1() + need)
    end
end
