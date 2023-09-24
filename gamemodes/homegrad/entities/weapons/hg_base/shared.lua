SWEP.Base = "weapon_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "hg_weaponbase"
SWEP.IsHomegrad = true
SWEP.ScopePos = Vector(0,0,0)
SWEP.ScopeAng = Angle(0,0,0)

function SWEP:IsScope()
    local ply = self:GetOwner()
    if ply:IsNPC() then return end

    return not ply:IsSprinting() and ply:KeyDown(IN_ATTACK2)
end

function SWEP:GetScopePos()
    return self.ScopePos, self.ScopeAng
end