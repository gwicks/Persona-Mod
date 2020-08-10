if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
EFFECT.MainMat = Material("vj_hl/beam")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()

	self.HitPos = self.EndPos - self.StartPos
	self.DieTime = CurTime() +0.6
	self:SetRenderBoundsWS(self.StartPos,self.EndPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if (CurTime() > self.DieTime) then
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	render.SetMaterial(self.MainMat)
	render.DrawBeam(self.StartPos,self.EndPos,math.Rand(18,24),math.Rand(0,1),math.Rand(0,1) +((self.StartPos -self.EndPos):Length() /128),Color(255,255,255,(50 /((self.DieTime -0.5) -CurTime()))))
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/