SWEP.Base = "weapon_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "hg_meleebase"
SWEP.IsHomegrad = true
SWEP.IsMelee = true

SWEP.ShootWait = 0.1

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 100
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = {
    "pwb/weapons/knife/slash1.wav",
    "pwb/weapons/knife/slash2.wav",
}
SWEP.Primary.SoundHit = {
    "pwb/weapons/knife/hit1.wav",
    "pwb/weapons/knife/hit2.wav",
    "pwb/weapons/knife/hit3.wav",
    "pwb/weapons/knife/hit4.wav",
}
SWEP.Primary.SoundHitWall = {
    "pwb/weapons/knife/hitwall.wav",
}
SWEP.Primary.SoundDraw = "pwb/weapons/knife/deploy.wav"
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
    self:EmitSound(Sound(self.Primary.SoundDraw))
end