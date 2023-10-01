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

    if not roundstarted and homegrad.GetNonSpecsPlayersNum() < 2 then
        draw.SimpleText(homegrad.GetPhrase("hg_need_more_players"), "hg.big", scrw / 2, scrh / 1.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if ply:Alive() then
        local Tr = ply:HGEyeTrace(100)
        if not Tr then return end

        local Size = math.max(1 - Tr.Fraction, 0.1)
        local col

        local ent = Tr.Entity
        if ent:IsPlayer() then
            col = ent:GetPlayerColor():ToColor()
        elseif ent.GetPlayerColor ~= nil then
            col = ent.playerColor:ToColor()
        end
        if ent:IsPlayer() and ent:GetMoveType() ~= MOVETYPE_NOCLIP then
            col.a = 255 * Size * 2
            draw.DrawText(homegrad.GetPhrase(ent:GetHNameLocalized()) or ent:Name(), "hg.bigname", Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y + 30, col, TEXT_ALIGN_CENTER)
        end

        if ply:GetActiveWeapon().IsMelee == true and Tr.Hit then
            local circlecol = Color(250,250,250,250 * Size)
            surface.SetDrawColor(circlecol)
            draw.NoTexture()
            draw.Circle(Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y, 32 * Size, 32)
        end
    end

    if ply:GetMoveType() == MOVETYPE_NOCLIP or (ply:GetDeathSpectator() or ply:IsSpectator()) then
        for _, v in ipairs(player.GetAll()) do --ESP
            if not v:Alive() or v == ply then continue end

            local ent = IsValid(v:GetNWEntity("Ragdoll")) and v:GetNWEntity("Ragdoll") or v
            local screenPosition = ent:GetPos():ToScreen()
            local x, y = screenPosition.x, screenPosition.y
            local teamColor = v:GetPlayerColor():ToColor()
            local distance = ply:GetPos():Distance(v:GetPos())
            local factor = 1 - math.Clamp(distance / 1024, 0, 1)
            local size = math.max(10, 32 * factor)
            local alpha = math.max(255 * factor, 80)

            local text = v:Name()
            surface.SetFont("Trebuchet18")
            local tw, th = surface.GetTextSize(text)

            surface.SetDrawColor(teamColor.r, teamColor.g, teamColor.b, alpha * 0.5)
            --surface.SetMaterial(gradient_d)
            surface.DrawTexturedRect(x - size / 2 - tw / 2, y - th / 2, size + tw, th)

            surface.SetTextColor(255, 255, 255, alpha)
            surface.SetTextPos(x - tw / 2, y - th / 2)
            surface.DrawText(text)

            local barWidth = math.Clamp((v:Health() / 150) * (size + tw), 0, size + tw)
            local healthcolor = v:Health() / 150 * 255

            surface.SetDrawColor(255, healthcolor, healthcolor, alpha)
            surface.DrawRect(x - barWidth / 2, y + th / 1.5, barWidth, ScreenScale(1))
        end
    end
end)

hook.Add("ScoreboardShow","hg.shownextround",function()
    shownextround = 15
end)