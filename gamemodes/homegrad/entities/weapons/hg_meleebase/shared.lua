SWEP.Base = "weapon_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "hg_meleebase"
SWEP.IsHomegrad = true
SWEP.IsMelee = true

SWEP.NextShoot = 0

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 100
SWEP.Primary.Spread = 0
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

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

    owner:LagCompensation(true)

    self.NextShoot = CurTime() + self.ShootWait

    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    owner:SetAnimation( PLAYER_ATTACK1 )

    local startPos = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
    local endPos = startPos + owner:GetAngles():Forward() * 80

    local tr = util.TraceHull({
        start = startPos,
        endpos = endPos,
        filter = owner,
        mins = Vector( -16, -16, 0 ),
        maxs = Vector( 16, 16, 0 ),
        mask = MASK_SHOT_HULL,
    })

    if SERVER then
        if IsValid(tr.Entity) then
            if tr.Entity:IsPlayer() then
                local snd = self.Primary.SoundHit[math.random(1,#self.Primary.SoundHit)]
                owner:EmitSound(snd)
                tr.Entity:TakeDamage(self.Primary.Damage,owner,self)
                tr.Entity:SetLastHitGroup(tr.HitGroup)
                util.Decal("Impact.Flesh", startPos, endPos, owner)
            else
                local snd = self.Primary.SoundHitWall[math.random(1,#self.Primary.SoundHitWall)]
                owner:EmitSound(snd)
                local negr = ents.Create("prop_ragdoll")
                negr:SetModel("models/player/group01/male_03.mdl")
                negr:SetPos(tr.Entity:GetPos())
                negr:Spawn()
                negr:SetColor(Color(1,0,0))
                tr.Entity:Remove()
                util.Decal("Scorch", startPos, endPos, owner)
            end
        else
            if tr.Hit then
                local snd = self.Primary.SoundHitWall[math.random(1,#self.Primary.SoundHitWall)]
                owner:EmitSound(snd)
            else
                local snd = self.Primary.Sound[math.random(1,#self.Primary.Sound)]
                owner:EmitSound(snd)
            end
        end
    end
end