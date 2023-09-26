local defaulthud = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudCrosshair"] = true,
}

hook.Add("HUDShouldDraw","hg.hidedefaulthud",function(hud)
    if defaulthud[hud] then return false end
end)

hook.Add("HUDDrawTargetID","hg.hideplayername",function()
    return false
end)

hook.Add("HUDPaint","hg.hudpaint",function()
    local ply = LocalPlayer()

    local teamid = ply:HGetTeam()
    local tc = homegrad.GetModeTeamColor(teamid)
    local roundstarted = homegrad.IsRoundStarted()
    local currentmode = homegrad.GetModeName()
    local nextmode = homegrad.GetNextModeName()
    local yourole = homegrad.GetMRoleName(teamid)
    local youroledesc = homegrad.GetMRoleDesc(teamid)
    local scrw,scrh = ScrW(),ScrH()

    local startRound = homegrad.GetRoundStartTime() + 7 - CurTime()
    local maincolor = Color(255,255,255,math.Clamp(startRound - 0.5,0,1) * 255 )
    local teamcolor = Color(tc.r,tc.g,tc.b,math.Clamp(startRound - 0.5,0,1) * 255 )

    if startRound > 0 and ply:Alive() and roundstarted then
        ply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),3,0.5)

        draw.SimpleText("Текущий: " .. currentmode, "hg.big", scrw - 5, 5, maincolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        draw.SimpleText("Следущий: " .. nextmode, "hg.big", scrw - 5, 25, maincolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        draw.SimpleText(currentmode, "hg.big", scrw / 2, scrh / 8, maincolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText(yourole, "hg.big", scrw / 2, scrh / 2, teamcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(youroledesc, "hg.big", scrw / 2, scrh / 1.2, teamcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)