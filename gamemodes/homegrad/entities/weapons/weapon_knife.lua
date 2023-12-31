sound.Add({
    name = "hg_knife_slash1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 60,
    pitch = {95, 110},
    sound = "pwb/weapons/knife/slash1.wav"
})

sound.Add({
    name = "hg_knife_slash2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 60,
    pitch = {95, 110},
    sound = "pwb/weapons/knife/slash2.wav"
})

sound.Add({
    name = "hg_knife_hit1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 60,
    pitch = {95, 110},
    sound = "pwb/weapons/knife/hit1.wav"
})

sound.Add({
    name = "hg_knife_hit2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 60,
    pitch = {95, 110},
    sound = "pwb/weapons/knife/hit2.wav"
})

sound.Add({
    name = "hg_knife_hit3",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 60,
    pitch = {95, 110},
    sound = "pwb/weapons/knife/hit3.wav"
})

sound.Add({
    name = "hg_knife_hit4",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 60,
    pitch = {95, 110},
    sound = "pwb/weapons/knife/hit4.wav"
})

sound.Add({
    name = "hg_knife_hitwall",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 110},
    sound = "pwb/weapons/knife/hitwall.wav"
})

sound.Add({
    name = "hg_knife_cloth",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 110},
    sound = "pwb/weapons/knife/cloth.wav"
})

SWEP.Base = "hg_meleebase"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "Knife"

SWEP.ShootWait = 0.6
SWEP.HoldType = "knife"
SWEP.Slot = 0

SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 30
SWEP.Primary.Force = 900
SWEP.Primary.Sound = {
    "hg_knife_slash1",
    "hg_knife_slash2"
}
SWEP.Primary.SoundHit = {
    "hg_knife_hit1",
    "hg_knife_hit2",
    "hg_knife_hit3",
    "hg_knife_hit4"
}
SWEP.Primary.SoundHitWall = {
    "hg_knife_hitwall"
}
SWEP.Primary.SoundDraw = "pwb/weapons/knife/deploy.wav"
SWEP.Primary.EquipSound = "hg_knife_cloth"

SWEP.WorldModel = "models/pwb/weapons/w_knife.mdl"