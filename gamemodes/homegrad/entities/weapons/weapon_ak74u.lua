sound.Add({
    name = "hg_ak74u_shoot",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "pwb/weapons/aks74u/shoot.wav"
})

sound.Add({
    name = "hg_ak74u_draw",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "pwb/weapons/aks74u/draw.wav"
})

sound.Add({
    name = "hg_ak74u_cloth",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "pwb/weapons/aks74u/cloth.wav"
})

SWEP.Base = "hg_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "AKS-74U"
SWEP.ScopePos = Vector(5.2,4,0.78)
SWEP.ScopeAng = Angle(-8,0,0)
SWEP.HoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.ReloadingTime = 2
SWEP.Slot = 2
SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(-11,-1.5,0)

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "5,45x39mm"
SWEP.Primary.Cone = .03
SWEP.Primary.Damage = 20
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "hg_ak74u_shoot"
SWEP.Primary.SoundDraw = "hg_ak74u_draw"
SWEP.Primary.EquipSound = "hg_ak74u_cloth"
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WorldModel = "models/pwb/weapons/w_aks74u.mdl"