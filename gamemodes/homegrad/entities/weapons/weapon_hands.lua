
SWEP.PrintName = "Hands"
SWEP.Category = "Homegrad"
SWEP.Spawnable = GetConVar("developer"):GetBool()

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.BounceWeaponIcon = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.IsMelee = true

local function WhomILookinAt(ply, cone, dist)
	local CreatureTr, ObjTr, OtherTr = nil, nil, nil

	for i = 1, 150 * cone do
		local Vec = (ply:GetAimVector() + VectorRand() * cone):GetNormalized()

		local Tr = util.QuickTrace(ply:GetShootPos(), Vec * dist, {ply})

		if Tr.Hit and not Tr.HitSky and Tr.Entity then
			local Ent, Class = Tr.Entity, Tr.Entity:GetClass()

			if Ent:IsPlayer() or Ent:IsNPC() then
				CreatureTr = Tr
			elseif (Class == "prop_physics") or (Class == "prop_physics_multiplayer") or (Class == "prop_ragdoll") then
				ObjTr = Tr
			else
				OtherTr = Tr
			end
		end
	end

	if CreatureTr then return CreatureTr.Entity, CreatureTr.HitPos, CreatureTr.HitNormal end
	if ObjTr then return ObjTr.Entity, ObjTr.HitPos, ObjTr.HitNormal end
	if OtherTr then return OtherTr.Entity, OtherTr.HitPos, OtherTr.HitNormal end

	return nil, nil, nil
end

SWEP.Instructions = "Your hands, LMB/Reload: raise/lower fists;\nRaised: LMB - punch, RMB - block;\nDown: RMB - pick up item;\nWhile holding an item: Reload - keep item in the air, Use - rotate item in the air"
SWEP.HoldType = "normal"
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.AttackSlowDown = .5
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ReachDistance = 100

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextIdle")
	self:NetworkVar("Bool", 2, "Fists")
	self:NetworkVar("Float", 1, "NextDown")
	self:NetworkVar("Bool", 3, "Blocking")
	self:NetworkVar("Bool", 4, "IsCarrying")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetFists(false)
	self:SetBlocking(false)
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() + .5)
	self:SetFists(false)

	return true
end

function SWEP:CanPickup(ent)
	local pickupWhiteList = {
		["prop_ragdoll"] = true,
		["prop_physics"] = true,
		["prop_physics_multiplayer"] = true
	}

	if ent:IsNPC() then return false end
	if ent:IsPlayer() then return false end
	if ent:IsWorld() then return false end
	local class = ent:GetClass()
	if pickupWhiteList[class] then return true end
	if CLIENT then return true end
	if IsValid(ent:GetPhysicsObject()) then return true end

	return false
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetFists() then return end

	if SERVER then
		self:SetCarrying()
		local ply = self:GetOwner()
		local tr = util.QuickTrace(ply:GetEyeTrace().StartPos, self:GetOwner():GetAimVector() * self.ReachDistance, {self:GetOwner()})

		if IsValid(tr.Entity) and self:CanPickup(tr.Entity) and not tr.Entity:IsPlayer() then
			local Dist = (self:GetOwner():GetShootPos() - tr.HitPos):Length()

			if Dist < self.ReachDistance then
				sound.Play("Flesh.ImpactSoft", self:GetOwner():GetShootPos(), 65, math.random(90, 110))
				self:SetCarrying(tr.Entity, tr.PhysicsBone, tr.HitPos, Dist)
				self:SetNWBool("Pickup", true)
				self:ApplyForce()
			end
		elseif IsValid(tr.Entity) and tr.Entity:IsPlayer() then
			local Dist = (self:GetOwner():GetShootPos() - tr.HitPos):Length()

			if Dist < self.ReachDistance then
				sound.Play("Flesh.ImpactSoft", self:GetOwner():GetShootPos(), 65, math.random(90, 110))
				self:GetOwner():SetVelocity(self:GetOwner():GetAimVector() * 20)
				tr.Entity:SetVelocity(-self:GetOwner():GetAimVector() * 50)
				self:SetNextSecondaryFire(CurTime() + .25)
			end
		end
	end
end

function SWEP:FreezeMovement()
	if self:GetOwner():KeyDown(IN_USE) and self:GetOwner():KeyDown(IN_ATTACK2) and self:GetNWBool("Pickup") then
		return true
	end

	return false
end

function SWEP:ApplyForce()
	local target = self:GetOwner():GetAimVector() * self.CarryDist + self:GetOwner():GetShootPos()
	local phys = self.CarryEnt:GetPhysicsObjectNum(self.CarryBone)

	if IsValid(phys) then
		local TargetPos = phys:GetPos()

		if self.CarryPos then
			TargetPos = self.CarryEnt:LocalToWorld(self.CarryPos)
		end

		local vec = target - TargetPos
		local len, mul = vec:Length(), self.CarryEnt:GetPhysicsObject():GetMass()

		if len > self.ReachDistance then
			self:SetCarrying()

			return
		end

		vec:Normalize()
		local avec, velo = vec * len, phys:GetVelocity() - self:GetOwner():GetVelocity()
		local Force = (avec - velo / 2) * (self.CarryBone > 3 and mul / 10 or mul)
		local ForceMagnitude = Force:Length()

		if ForceMagnitude > 4000 * 1 then
			self:SetCarrying()

			return
		end

		local CounterDir, CounterAmt = velo:GetNormalized(), velo:Length()

		if self.CarryPos then
			phys:ApplyForceOffset(Force, self.CarryEnt:LocalToWorld(self.CarryPos))
		else
			phys:ApplyForceCenter(Force)
		end

		if self:GetOwner():KeyDown(IN_USE) then
			SetAng = SetAng or self:GetOwner():EyeAngles()
			local commands = self:GetOwner():GetCurrentCommand()
			local x,y = commands:GetMouseX(),commands:GetMouseY()
			if self.CarryEnt:IsRagdoll() then
				rotate = Vector(x,y,0)/6
			else
				rotate = Vector(x,y,0)
			end

			phys:AddAngleVelocity(rotate)
		end

		phys:ApplyForceCenter(Vector(0, 0, mul))
		phys:AddAngleVelocity(-phys:GetAngleVelocity() / 10)
	end
end

function SWEP:GetCarrying()
	return self.CarryEnt
end

function SWEP:SetCarrying(ent, bone, pos, dist)
	if IsValid(ent) then
		self.CarryEnt = ent
		self.CarryBone = bone
		self.CarryDist = dist
		self:SetNWBool("Pickup", true)

		if not (ent:GetClass() == "prop_ragdoll") then
			self.CarryPos = ent:WorldToLocal(pos)
		else
			self.CarryPos = nil
		end
	else
		self:SetNWBool("Pickup", false)
		self.CarryEnt = nil
		self.CarryBone = nil
		self.CarryPos = nil
		self.CarryDist = nil
	end
end

function SWEP:Think()
	if IsValid(self:GetOwner()) and self:GetOwner():KeyDown(IN_ATTACK2) and not self:GetFists() then
		if IsValid(self.CarryEnt) then
			self:ApplyForce()
		end
	elseif self.CarryEnt then
		self:SetCarrying()
	end

	if self:GetFists() and self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetNextPrimaryFire(CurTime() + .5)
		self:SetBlocking(true)
	else
		self:SetBlocking(false)
	end

	local HoldType = "fist"

	if self:GetFists() then
		HoldType = "fist"
		local Time = CurTime()

		if self:GetBlocking() then
			self:SetNextDown(Time + 1)
			HoldType = "camera"
		end

		if (self:GetNextDown() < Time) or self:GetOwner():KeyDown(IN_SPEED) then
			self:SetNextDown(Time + 1)
			self:SetFists(false)
			self:SetBlocking(false)
		end
	else
		HoldType = "normal"
	end

	if IsValid(self.CarryEnt) or self.CarryEnt then
		HoldType = "magic"
	end

	if self:GetOwner():KeyDown(IN_SPEED) then
		HoldType = "normal"
	end

	if SERVER then
		self:SetHoldType(HoldType)
	end
end

function SWEP:PrimaryAttack()
	local side = "fists_left"

	if math.random(1, 2) == 1 then
		side = "fists_right"
	end

	self:SetNextDown(CurTime() + 7)

	if not self:GetFists() then
		self:SetFists(true)
		self:SetNextPrimaryFire(CurTime() + .35)

		return
	end

	if self:GetBlocking() then return end
	if self:GetOwner():KeyDown(IN_SPEED) then return end

	self:GetOwner():ViewPunch(Angle(0, 0, math.random(-2, 2)))
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	if SERVER then
		sound.Play("weapons/slam/throw.wav", self:GetPos(), 65, math.random(90, 110))
		self:GetOwner():ViewPunch(Angle(0, 0, math.random(-2, 2)))

		timer.Simple(.075, function()
			if IsValid(self) then
				self:AttackFront()
			end
		end)
	end

	self:SetNextPrimaryFire(CurTime() + .35)
	self:SetNextSecondaryFire(CurTime() + .35)
end

function SWEP:AttackFront()
	if CLIENT then return end
	self:GetOwner():LagCompensation(true)
	local Ent, HitPos = WhomILookinAt(self:GetOwner(), .3, 55)
	local AimVec = self:GetOwner():GetAimVector()

	if IsValid(Ent) or (Ent and Ent.IsWorld and Ent:IsWorld()) then
		local SelfForce, Mul = -150, 1
		
		if self:IsEntSoft(Ent) then
			SelfForce = 25
			sound.Play("Flesh.ImpactHard", HitPos, 65, math.random(90, 110))
		else
			sound.Play("Flesh.ImpactSoft", HitPos, 65, math.random(90, 110))
		end

		local DamageAmt = math.random(3, 5)
		local Dam = DamageInfo()
		Dam:SetAttacker(self:GetOwner())
		Dam:SetInflictor(self.Weapon)
		Dam:SetDamage(DamageAmt * Mul)
		Dam:SetDamageForce(AimVec * Mul ^ 2)
		Dam:SetDamageType(DMG_CLUB)
		Dam:SetDamagePosition(HitPos)
		Ent:TakeDamageInfo(Dam)
		local Phys = Ent:GetPhysicsObject()

		if IsValid(Phys) then
			if Ent:IsPlayer() then
				Ent:SetVelocity(AimVec * SelfForce * 1.5)
			end

			Phys:ApplyForceOffset(AimVec * 5000 * Mul, HitPos)
			self:GetOwner():SetVelocity(-AimVec * SelfForce * .8)
		end

		if Ent:GetClass() == "func_breakable_surf" then
			if math.random(1, 20) == 10 then
				Ent:Fire("break", "", 0)
			end
		end

		if Ent:GetClass() == "func_breakable" then
			if math.random(7, 11) == 10 then
				Ent:Fire("break", "", 0)
			end
		end

	end

	self:GetOwner():LagCompensation(false)
end

--self.CarryDist
--self.CarryPos
--self.CarryBone

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end

	self:SetFists(false)
	self:SetBlocking(false)
	local ent = self:GetCarrying()
	if SERVER then
		local target = self:GetOwner():GetAimVector() * (self.CarryDist or 50) + self:GetOwner():GetShootPos()
		heldents = heldents or {}
		for i,tbl in pairs(heldents) do
			if tbl[2] == self:GetOwner() then heldents[i] = nil end
		end
		if IsValid(ent) then
			--if heldents[ent:EntIndex()] then heldents[ent:EntIndex()] = nil end
			heldents[ent:EntIndex()] = {self.CarryEnt,self:GetOwner(),self.CarryDist,target,self.CarryBone,self.CarryPos}
		end

	end
	--self:SetCarrying()
end

if SERVER then
	hook.Add("Think","hg.heldentities",function()
		heldents = heldents or {}
		for i,tbl in pairs(heldents) do
			if not tbl or not IsValid(tbl[1]) then heldents[i] = nil continue end
			local ent,ply,dist,target,bone,pos = tbl[1],tbl[2],tbl[3],tbl[4],tbl[5],tbl[6]
			local phys = ent:GetPhysicsObjectNum(bone)
			local TargetPos = phys:GetPos()

			if pos then
				TargetPos = ent:LocalToWorld(pos)
			end
			
			local vec = target - TargetPos
			local len, mul = vec:Length(), ent:GetPhysicsObject():GetMass()
			vec:Normalize()
			local avec, velo = vec * len, phys:GetVelocity() - ply:GetVelocity()
			local Force = (avec) * (bone > 3 and mul / 10 or mul)
			if math.abs((tbl[2]:GetPos() - tbl[1]:GetPos()):Length()) < 80 and tbl[2]:GetGroundEntity() != tbl[1] then
				if tbl[6] then
					phys:ApplyForceOffset(Force, ent:LocalToWorld(pos))
				else
					phys:ApplyForceCenter(Force)
				end

				phys:ApplyForceCenter(Vector(0, 0, mul))
				phys:AddAngleVelocity(-phys:GetAngleVelocity() / 10)
			else
				heldents[i] = nil
			end
		end
	end)
end

function SWEP:IsEntSoft(ent)
	return ent:IsNPC() or ent:IsPlayer()
end