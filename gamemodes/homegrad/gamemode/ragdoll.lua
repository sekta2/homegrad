local meta = FindMetaTable("Player")

function meta:IsRagdolled()
    return self:GetNWBool("hg.isragdoll",false)
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
        ragdoll:SetModel(self:GetModel())
        ragdoll:Spawn()
        ragdoll.GetPlayerColor = function() return self:GetPlayerColor() end
        homegrad.SendRagdollColor(ragdoll,ragdoll:GetPlayerColor())

        ragdoll:AddEFlags(EFL_NO_DAMAGE_FORCES)
        ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        local vel = self:GetVelocity() / 1 + (force or Vector(0,0,0))
        local bonecount = ragdoll:GetPhysicsObjectCount()
        for i = 0, bonecount - 1 do
            local physobj = ragdoll:GetPhysicsObjectNum( i )
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
    end

    function meta:MakeRagdoll()
        self:SetNWBool("hg.isragdoll",true)

        self:HCreateRagdoll()
        self:GetRagdollEntity():Remove()
    end
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