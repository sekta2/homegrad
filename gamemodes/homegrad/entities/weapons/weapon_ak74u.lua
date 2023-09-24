SWEP.Base = "hg_base"

SWEP.Author = "Homegrad"
SWEP.Category = "Homegrad"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "AKS-74U"
SWEP.ScopePos = Vector(5.2,4,0.78)
SWEP.ScopeAng = Angle(-8,0,0)

SWEP.ViewModel = "models/pwb/weapons/w_aks74u.mdl"
SWEP.WorldModel	= "models/pwb/weapons/w_aks74u.mdl"

function SWEP:Initialize()
    self:SetHoldType("ar2")
end