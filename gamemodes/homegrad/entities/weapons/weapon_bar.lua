sound.Add({
    name = "hg_crowbar_slash",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 60,
    pitch = {95, 110},
    sound = "weapons/slam/throw.wav"
})

sound.Add({
    name = "hg_crowbar_hit1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 110},
    sound = "physics/body/body_medium_impact_hard1.wav"
})

sound.Add({
    name = "hg_crowbar_hit2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 70,
    pitch = {95, 110},
    sound = "physics/body/body_medium_impact_hard2.wav"
})

sound.Add({
    name = "hg_crowbar_hit3",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 70,
    pitch = {95, 110},
    sound = "physics/body/body_medium_impact_hard3.wav"
})

sound.Add({
    name = "hg_crowbar_hitwall1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 70,
    pitch = {95, 110},
    sound = "weapons/crowbar/crowbar_impact1.wav"
})

sound.Add({
    name = "hg_crowbar_hitwall2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 70,
    pitch = {95, 110},
    sound = "weapons/crowbar/crowbar_impact2.wav"
})

SWEP.Base = "hg_meleebase"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = GetConVar("developer"):GetBool()
SWEP.AdminOnly = false
SWEP.PrintName = "Crowbar"

SWEP.ShootWait = 1
SWEP.HoldType = "melee2"
SWEP.Slot = 0

SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 40
SWEP.Primary.Sound = {
    "hg_crowbar_slash"
}
SWEP.Primary.SoundHit = {
    "hg_crowbar_hit1",
    "hg_crowbar_hit2",
    "hg_crowbar_hit3"
}
SWEP.Primary.SoundHitWall = {
    "hg_crowbar_hitwall1",
	"hg_crowbar_hitwall2"
}
SWEP.Primary.SoundDraw = "pwb/weapons/knife/cloth.wav"

SWEP.WorldModel = "models/weapons/w_crowbar.mdl"