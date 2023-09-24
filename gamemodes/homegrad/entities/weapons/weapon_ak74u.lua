SWEP.Base = "hg_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "AKS-74U"
SWEP.ScopePos = Vector(5.2,4,0.78)
SWEP.ScopeAng = Angle(-8,0,0)
SWEP.Primary.Automatic = false

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 100
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "ak74/ak74_fp.wav"
SWEP.Primary.SoundFar = "ak74/ak74_dist.wav"
SWEP.Primary.Force = 0

SWEP.Cooldown = CurTime()

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo    = "none"

SWEP.ViewModel = "models/pwb/weapons/w_aks74u.mdl"
SWEP.WorldModel    = "models/pwb/weapons/w_aks74u.mdl"

function SWEP:Initialize()
    self:SetHoldType("ar2")
end

function SWEP:FireBullet(dmg,numbul,spread)
    --if self:Clip1() <= 0 then return end

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
    if self.Cooldown > CurTime() then return end

    self:FireBullet(5,1,1)
    self.Cooldown = CurTime() + 0.1
    self:EmitSound(Sound( self.Primary.Sound ))
end

function SWEP:SecondaryAttack()
end