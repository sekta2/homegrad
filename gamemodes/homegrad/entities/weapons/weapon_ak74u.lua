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