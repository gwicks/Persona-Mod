include('shared.lua')

SWEP.PrintName        = "No Weapons"
SWEP.Author           = ""
SWEP.Purpose          = ""
SWEP.Instructions     = ""
SWEP.Slot             = 0
SWEP.SlotPos          = 0
SWEP.DrawAmmo         = false
SWEP.DrawCrosshair    = false

function SWEP:ShouldDrawViewModel()
	return false
end

function SWEP:DrawWorldModel()
	return false
end