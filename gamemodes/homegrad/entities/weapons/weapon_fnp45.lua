SWEP.Base = "hg_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = GetConVar("developer"):GetBool()
SWEP.PrintName = "FNP-45"
SWEP.ScopePos = Vector(1.7,10,0.5)
SWEP.ScopeAng = Angle(-11,0,0)
SWEP.HoldType = "revolver"
SWEP.RunHoldType = "normal"
SWEP.ReloadingTime = 2.5
SWEP.ShootWait = 0.15
SWEP.Slot = 1
SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(-11,0,0)

SWEP.Primary.ClipSize = 15
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ".45 ACP"
SWEP.Primary.Cone = .02
SWEP.Primary.Damage = 18
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "pwb/weapons/fnp45/shoot.wav"
SWEP.Primary.SoundDraw = "pwb/weapons/fnp45/draw.wav"
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WorldModel = "models/pwb/weapons/w_fnp45.mdl"