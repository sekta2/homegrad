sound.Add({
    name = "hg_stunbaton_slash",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 60,
    pitch = {95, 105},
    sound = "weapons/stunstick/stunstick_swing2.wav"
})

sound.Add({
    name = "hg_stunbaton_hit1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 70,
    pitch = {98, 102},
    sound = "weapons/stunstick/stunstick_fleshhit1.wav"
})

sound.Add({
    name = "hg_stunbaton_hit2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 70,
    pitch = {98, 102},
    sound = "weapons/stunstick/stunstick_fleshhit2.wav"
})

sound.Add({
    name = "hg_stunbaton_hitwall1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 70,
    pitch = {98, 102},
    sound = "weapons/stunstick/stunstick_impact1.wav"
})

sound.Add({
    name = "hg_stunbaton_hitwall2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 70,
    pitch = {98, 102},
    sound = "weapons/stunstick/stunstick_impact2.wav"
})

SWEP.Base = "hg_meleebase"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "Stun Baton"

SWEP.ShootWait = 1
SWEP.HoldType = "melee"
SWEP.Slot = 0

SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 30
SWEP.Primary.Force = 1500
SWEP.Primary.Sound = {
    "hg_stunbaton_slash"
}
SWEP.Primary.SoundHit = {
    "hg_stunbaton_hit1",
    "hg_stunbaton_hit2"
}
SWEP.Primary.SoundHitWall = {
    "hg_stunbaton_hitwall1",
    "hg_stunbaton_hitwall2"
}
SWEP.Primary.SoundDraw = "weapons/stunstick/spark2.wav"
SWEP.Primary.EquipSound = "pwb/weapons/knife/cloth.wav"

SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"