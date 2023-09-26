homegrad.ammos = {
    "5,45x39mm",
    "7,62x39mm",
    "9mm Parabellum",
}

for _,ammo in pairs(homegrad.ammos) do
    game.AddAmmoType({
        name = ammo,
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 2000,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    })
end

timer.Simple(1,function()
    game.BuildAmmoTypes()
end)