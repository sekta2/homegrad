local defaulthud = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudCrosshair"] = true,
    ["CHudDamageIndicator"] = true,
    ["CHudGeiger"] = true
}

hook.Add("HUDShouldDraw","hg.hidedefaulthud",function(hud)
    if defaulthud[hud] then return false end
end)

hook.Add("HUDDrawTargetID","hg.hideplayername",function()
    return false
end)

hook.Add("HUDDrawPickupHistory","hg.hidehistory",function()
    return false
end)

local shownextround = 0

hook.Add("HUDPaint","hg.hudpaint",function()
    local ply = LocalPlayer()

    local teamid = ply:HGetTeam()
    local tc = homegrad.GetModeTeamColor(teamid)
    local roundstarted = homegrad.IsRoundStarted()
    local currentmode = homegrad.GetModeName()
    local nextmode = homegrad.GetNextModeName()
    local yourole = homegrad.GetMRoleName(teamid)
    local yourname = homegrad.GetPhrase("hg_your_name")
    local namelocalized = homegrad.GetPhrase(ply:GetHNameLocalized())
    local youroledesc = homegrad.GetMRoleDesc(teamid)
    local scrw,scrh = ScrW(),ScrH()

    local startRound = homegrad.GetRoundStartTime() + 7 - CurTime()
    local maincolor = Color(255,255,255,math.Clamp(startRound - 0.5,0,1) * 255)
    local teamcolor = Color(tc.r,tc.g,tc.b,math.Clamp(startRound - 0.5,0,1) * 255)

    shownextround = Lerp(2 * FrameTime(),shownextround or 0,0)

    if shownextround > 0 then
        draw.SimpleText("Текущий: " .. currentmode, "hg.big", scrw - 5, 5, Color(255,255,255,shownextround * 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        draw.SimpleText("Следущий: " .. nextmode, "hg.big", scrw - 5, 25, Color(255,255,255,shownextround * 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    if not roundstarted then shownextround = 3 end

    if startRound > 0 and ply:Alive() and roundstarted and not ply:IsSpectator() then
        ply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),3,0.5)

        shownextround = 15

        draw.SimpleText(currentmode, "hg.big", scrw / 2, scrh / 8, maincolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText(yourname .. " " .. namelocalized, "hg.big", scrw / 2, (scrh / 2) - 10, teamcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(yourole, "hg.big", scrw / 2, (scrh / 2) + 10, teamcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(youroledesc, "hg.big", scrw / 2, scrh / 1.2, teamcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)

hook.Add("ScoreboardShow","hg.shownextround",function()
    shownextround = 15
end)