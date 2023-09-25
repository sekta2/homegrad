hook.Add("HUDPaint","hg.hudpaint",function()
    local ply = LocalPlayer()

    local teamid = ply:Team()
    local roundstarted = homegrad.IsRoundStarted()
    local currentmode = homegrad.GetModeName()
    local nextmode = homegrad.GetNextModeName()
    local yourole = homegrad.GetMRoleName(teamid)
    local youroledesc = homegrad.GetMRoleDesc(teamid)
    local scrw,scrh = ScrW(),ScrH()

    ply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),3,0.5)

    draw.SimpleText("Текущий: " .. currentmode, "hg.big", scrw - 5, 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    draw.SimpleText("Следущий: " .. nextmode, "hg.big", scrw - 5, 25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

    draw.SimpleText(currentmode, "hg.big", scrw / 2, scrh / 8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    draw.SimpleText(yourole, "hg.big", scrw / 2, scrh / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(youroledesc, "hg.big", scrw / 2, scrh / 1.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)