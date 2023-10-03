SWEP.Base = "weapon_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "hg_meleebase"
SWEP.IsHomegrad = true
SWEP.IsMelee = true

SWEP.NextShoot = 0
SWEP.HoldType = "knife"
SWEP.ViewModel = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 100
SWEP.Primary.Force = 1000

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
    self:EmitSound(self.Primary.SoundDraw)
end

function SWEP:CanPrimaryAttack()
    return self.NextShoot < CurTime()
end

function SWEP:Equip(owner)
    owner:EmitSound(self.Primary.EquipSound)
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end

    local owner = self:GetOwner()

    owner:LagCompensation(true)

    self.NextShoot = CurTime() + self.ShootWait
    owner:SetAnimation(PLAYER_ATTACK1)

    local startPos = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
    local endPos = startPos + owner:GetAngles():Forward() * 80

    local tr = util.TraceHull({
        start = startPos,
        endpos = endPos,
        filter = owner,
        mins = Vector(-16, -16, 0),
        maxs = Vector(16, 16, 0),
        mask = MASK_SHOT_HULL,
   })

    if SERVER then
        if IsValid(tr.Entity) then
            if tr.Entity:IsPlayer() then
                local snd = self.Primary.SoundHit[math.random(1,#self.Primary.SoundHit)]
                owner:EmitSound(snd, 60, math.random(95,105))
                tr.Entity:TakeDamage(self.Primary.Damage,owner,self)
                tr.Entity:SetLastHitGroup(tr.HitGroup)
                util.Decal("Impact.Flesh", startPos, endPos, owner)
            elseif tr.Entity:IsRagdoll() then
                local snd = self.Primary.SoundHit[math.random(1,#self.Primary.SoundHit)]
                owner:EmitSound(snd, 60, math.random(95,105))
                tr.Entity:TakeDamage(self.Primary.Damage,owner,self)
                util.Decal("Impact.Flesh", startPos, endPos, owner)
            else
                local snd = self.Primary.SoundHitWall[math.random(1,#self.Primary.SoundHitWall)]
                owner:EmitSound(snd, 60, math.random(95,105))
                util.Decal("ManhackCut", startPos, endPos, owner)
                if IsValid(tr.Entity) then
                    tr.Entity:TakeDamage(self.Primary.Damage,owner,self)
                end
            end
            local phys = tr.Entity:GetPhysicsObjectNum(tr.PhysicsBone)

            if IsValid(phys) then
                local pushvec = tr.Normal * self.Primary.Force
                local pushpos = tr.HitPos

                phys:ApplyForceOffset(pushvec, pushpos)
            end
        else
            if tr.Hit then
                local snd = self.Primary.SoundHitWall[math.random(1,#self.Primary.SoundHitWall)]
                util.Decal("ManhackCut", startPos, endPos, owner)
                owner:EmitSound(snd, 60, math.random(95,105))
            else
                local snd = self.Primary.Sound[math.random(1,#self.Primary.Sound)]
                owner:EmitSound(snd, 60, math.random(95,105))
            end
        end
    end

    owner:LagCompensation(false)
end

function SWEP:SecondaryAttack()
    return false
end