SWEP.Base = "weapon_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "hg_meleebase"
SWEP.IsHomegrad = true
SWEP.IsMelee = true

SWEP.NextShoot = 0
SWEP.ShootWait = 0.1

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 100
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = {}
SWEP.Primary.SoundHit = {}
SWEP.Primary.SoundHitWall = {}
SWEP.Primary.SoundDraw = ""
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModel = "models/pwb/weapons/w_knife.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_knife.mdl"

function SWEP:Initialize()
    self:SetHoldType("knife")
end

function SWEP:Deploy()
    self:EmitSound(self.Primary.SoundDraw)
    self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:CanPrimaryAttack()
    return self.NextShoot < CurTime()
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end

    local owner = self:GetOwner()

    self.NextShoot = CurTime() + self.ShootWait

    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    owner:SetAnimation( PLAYER_ATTACK1 )

    local tr = util.TraceHull({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * 64,
        filter = owner,
        mins = Vector( -16, -16, 0 ),
        maxs = Vector( 16, 16, 0 ),
        mask = MASK_SHOT_HULL,
    })

    if SERVER then
        if IsValid(tr.Entity) then
            if tr.Entity:IsPlayer() then
                local snd = self.Primary.SoundHit[math.Rand(1,#self.Primary.SoundHit)]
                owner:EmitSound(snd)
            else
                local snd = self.Primary.SoundHitWall[math.Rand(1,#self.Primary.SoundHitWall)]
                owner:EmitSound(snd)
            end
            tr.Entity:TakeDamage(self.Primary.Damage,owner,self)
        else
            
        end
    end
end