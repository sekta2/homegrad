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
SWEP.Primary.Sound = "ak74/ak74_fp.wav"
SWEP.Primary.SoundFar = "ak74/ak74_dist.wav"
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ScopePos = Vector(0,0,0)
SWEP.ScopeAng = Angle(0,0,0)

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:GetAmmoText()
    local ammo,ammobag = self:GetMaxClip1(), self:Clip1()

    if ammobag > ammo - 1 then
        return "Полон"
    elseif ammobag > ammo - ammo / 3 then
        return "~Почти полон"
    elseif ammobag > ammo / 3 then
        return "~Половина"
    elseif ammobag >= 1 then
        return "~Почти пуст"
    elseif ammobag < 1 then
        return "Пуст"
    end
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
    local ammomags = ply:GetAmmoCount( self:GetPrimaryAmmoType() )

    draw.DrawText("Магазин | " .. text, "hg.big", pos.x, pos.y, color_gray1, TEXT_ALIGN_RIGHT )
    draw.DrawText("Магазинов | " .. math.Round(ammomags / ammo), "hg.big", pos.x + 5, pos.y + 25, color_gray, TEXT_ALIGN_RIGHT )
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
    return self:Clip1() > 0 and self.NextShoot < CurTime() and not self:IsReloading()
end

function SWEP:FireBullet(dmg,numbul,spread)
    local ply = self:GetOwner()

    ply:LagCompensation(true)

    local obj = self:LookupAttachment("muzzle")

    local Attachment = self:GetAttachment(obj)

    if not Attachment then
        local Pos,Ang = self:GetPosAng()
        Attachment = {Pos = Pos,Ang = Ang}
    end

    local cone = 0

    local shootOrigin = Attachment.Pos
    local vec = Vector(0,0,0)
    vec:Rotate(Attachment.Ang)
    shootOrigin:Add(vec)

    local shootAngles = Attachment.Ang

    local shootDir = shootAngles:Forward()

    local bullet = {}
    bullet.Num = self.NumBullet or 1
    bullet.Src = shootOrigin
    bullet.Dir = shootDir
    bullet.Spread = Vector(cone,cone,0)
    bullet.Force = self.Primary.Force / 40
    bullet.Damage = self.Primary.Damage * 4
    bullet.AmmoType = self.Primary.Ammo
    bullet.Attacker = self:GetOwner()
    bullet.Tracer = 1
    bullet.TracerName = self.Tracer or "Tracer"
    bullet.IgnoreEntity = not self:GetOwner():IsNPC() and self:GetOwner():GetVehicle() or self:GetOwner()

    bullet.Callback = function(owner,tr,dmgInfo)
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
        self:GetOwner():FireBullets(bullet)
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
    self:EmitSound(Sound( self.Primary.Sound ))

    self.HudShow = 3
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
    local ply = self:GetOwner()

    self.HudShow = 5

    if self:Clip1() >= self:GetMaxClip1() or self:IsReloading() or ply:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then return end

    self:SendWeaponAnim( ACT_VM_RELOAD )
    ply:SetAnimation( PLAYER_RELOAD )
    self:SetNWBool("hg.isreloading",true)
    self.ReloadingTimer = CurTime() + self.ReloadingTime
end

function SWEP:Think()
    local ply = self:GetOwner()

    if self:IsReloading() and self.ReloadingTimer <= CurTime() then
        self:SetNWBool("hg.isreloading",false)

        local need = self:GetMaxClip1() - self:Clip1()
        need = math.min(need,ply:GetAmmoCount(self:GetPrimaryAmmoType()))
        ply:RemoveAmmo(need,self:GetPrimaryAmmoType())
        self:SetClip1(self:Clip1() + need)
    end
end