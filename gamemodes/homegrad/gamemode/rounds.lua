function homegrad.IsRoundStarted()
    GetGlobalBool("hg.roundstarted",false)
end

if SERVER then
    function homegrad.StartRound()
        SetGlobalBool("hg.roundstarted",true)
    end

    function homegrad.EndRound()
        SetGlobalBool("hg.roundstarted",true)
    end
end