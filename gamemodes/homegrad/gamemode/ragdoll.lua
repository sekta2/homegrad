local meta = FindMetaTable("Player")

function meta:IsRagdolled()
    return self:GetNWBool("hg.isragdoll",false)
end

function meta:HGetRagdoll()
    return self:GetNWEntity("hg.ragdoll",self)
end

function meta:GetRagdollCooldown()
    return self:GetNWInt("hg.ragdollcooldown",0)
end

if SERVER then
    util.AddNetworkString("hg.sendragdollcolor")

    function homegrad.SendRagdollColor(ent,clr)
        net.Start("hg.sendragdollcolor")
            net.WriteFloat(ent:EntIndex())
            net.WriteVector(clr)
        net.Broadcast()
    end

    function meta:HCreateRagdoll()
        local ragdoll = ents.Create("prop_ragdoll")
        ragdoll.IsHomegrad = true
        ragdoll:SetNWEntity("hg.ragowner",self)

        ragdoll:SetModel(self:GetModel())
        ragdoll:Spawn()
        ragdoll.GetPlayerColor = function() return self:GetPlayerColor() end
        homegrad.SendRagdollColor(ragdoll,ragdoll:GetPlayerColor())

        ragdoll:AddEFlags(EFL_NO_DAMAGE_FORCES)
        ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        local vel = self:GetVelocity() / 1 + (force or Vector(0,0,0))
        local bonecount = ragdoll:GetPhysicsObjectCount()
        for i = 0, bonecount - 1 do
            local physobj = ragdoll:GetPhysicsObjectNum(i)
            local ragbonename = ragdoll:GetBoneName(ragdoll:TranslatePhysBoneToBone(i))
            local bone = self:LookupBone(ragbonename)
            if bone then
                local bonemat = self:GetBoneMatrix(bone)
                if bonemat then
                    local bonepos = bonemat:GetTranslation()
                    local boneang = bonemat:GetAngles()
                    physobj:SetPos( bonepos,true )
                    physobj:SetAngles( boneang )

                    if not self:Alive() then vel = vel end
                    physobj:AddVelocity(vel)
                end
            end
        end

        return ragdoll
    end

    function meta:MakeRagdoll()
        self:SetNWBool("hg.isragdoll",true)

        local ragdoll = self:HCreateRagdoll()
        local oldrag = self:GetRagdollEntity()
        self:SetNWEntity("hg.ragdoll",ragdoll)
        if IsValid(oldrag) then
            oldrag:Remove()
        end
    end

    function meta:DeMakeRagdoll()
        local ragdoll = self:HGetRagdoll()

        self:SetNWBool("hg.isragdoll",false)
        self:UnSpectate()
        self:Spawn()

        if IsValid(ragdoll) then
            self:SetPos(ragdoll:GetPhysicsObject():GetPos())

            ragdoll:Remove()
        end
    end

    function meta:SetRagdollCooldown(val)
        self:SetNWInt("hg.ragdollcooldown",CurTime() + val)
    end

    function meta:Ragdollize()
        local cooldown = self:GetRagdollCooldown()
        if cooldown <= CurTime() then
            self:SetRagdollCooldown(2)
            if not self:IsRagdolled() and self:Alive() then
                self:MakeRagdoll()
            elseif self:IsRagdolled() and self:Alive() then
                self:DeMakeRagdoll()
            end
        end
    end

    hook.Add("PlayerTick","hg.ragdollspectate",function(ply,mv)
        if ply:IsRagdolled() then
            ply:Spectate(OBS_MODE_FIXED)
        end
    end)

    hook.Add("EntityTakeDamage","hg.ragdolldamage",function(ragdoll,dmg)
        if ragdoll.IsHomegrad then
            local owner = ragdoll:GetNWEntity("hg.ragowner",Entity(1))
            owner:TakeDamageInfo(dmg)
        end
    end)

    concommand.Add("fake2", function(ply)
        if ply:Alive() then
            ply:Ragdollize()
        end
    end)
else
    net.Receive("hg.sendragdollcolor",function()
        local ragdollindex = net.ReadFloat()
        local color = net.ReadVector()
        timer.Simple(0.1,function()
            local ragdoll = Entity(ragdollindex)
            if IsValid(ragdoll) and (ragdoll:IsRagdoll()) then
                ragdoll.GetPlayerColor = function() return color end
            end
        end)
    end)
end