ENT.Base 			= "npc_vj_per_character_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= "NPC"

ENT.VJ_PersonaNPC = true
ENT.VJ_Persona_HasTheme = true

if CLIENT then
	local lerp_hp = 0
	
	function ENT:PlayMusic(bMode)
		if GetConVarNumber("vj_persona_music") == 1 then
			local ply = LocalPlayer()
			ply.VJ_Persona_ThemeTrack = self.Theme
			ply.VJ_Persona_Theme = CreateSound(ply,ply.VJ_Persona_ThemeTrack)
			ply.VJ_Persona_Theme:SetSoundLevel(0)
			ply.VJ_Persona_Theme:ChangeVolume(60)
			ply.VJ_Persona_Theme:Play()
			ply.VJ_Persona_ThemeT = CurTime() +self.ThemeT
		end
	end
	
	function ENT:ToggleTheme(bMode)
		self.VJ_Persona_HasTheme = bMode
		if bMode == true then -- Turn on
			self:PlayMusic()
		else -- Turn off
			if ply.VJ_Persona_Theme then ply.VJ_Persona_Theme:FadeOut(1) end
			ply.VJ_Persona_ThemeT = 0
		end
	end
	
	function ENT:Think()
		local ply = LocalPlayer()
		if GetConVarNumber("vj_persona_music") == 0 then
			if ply.VJ_Persona_Theme then ply.VJ_Persona_Theme:Stop() end
		end
		if ply.VJ_Persona_ThemeT == nil then ply.VJ_Persona_ThemeT = 0 end
		if self.VJ_Persona_HasTheme then
			if ply.VJ_Persona_Theme == nil or ply.VJ_Persona_ThemeT < CurTime() then
				if ply.VJ_Persona_Theme then ply.VJ_Persona_Theme:Stop() end
				self:PlayMusic()
			end
		end
	end
	
	function ENT:Initialize()
		self.Theme = "cpthazama/persona4/music/boss_yu.mp3"
		self.ThemeT = 168
	end
	
	function ENT:OnRemove()
		local found = false
		for _,v in pairs(ents.FindByClass(self:GetClass())) do
			if v != self then
				found = true
				break
			end
		end
		local ply = LocalPlayer()
		if ply.VJ_Persona_ThemeTrack == self.Theme && found == false then
			ply.VJ_Persona_Theme:FadeOut(2)
			ply.VJ_Persona_ThemeT = 0
			ply.VJ_Persona_ThemeTrack = "common/null.wav"
		end
	end

	net.Receive("vj_persona_hud_yu",function(len,pl)
		local delete = net.ReadBool()
		local ent = net.ReadEntity()
		hook.Add("HUDPaint","VJ_Persona_HUD_Yu",function()
			local persona = ent:GetPersona()
			local card = persona:GetNWString("SpecialAttack")
			local name = ent:GetPersonaName()
			draw.RoundedBox(1,ScrW() /1.79,ScrH() -120,220,80,Color(0,0,0,150))
			draw.SimpleText("Persona: " .. string.SetChar(name,1,string.upper(string.sub(name,1,1))),"VJFont_Trebuchet24_SmallMedium",ScrW() /1.75,ScrH() -115,Color(255,255,255,255),0,0)

			if persona then
				draw.SimpleText("Skill Card: " .. card,"VJFont_Trebuchet24_SmallMedium",ScrW() /1.75,ScrH() -68,Color(255,255,255,255),0,0)
			end

			local hp = ent:GetSP()
			local maxhp = ent:GetMaxSP()
			local hp_r = 200
			local hp_g = 0
			local hp_b = 255
			lerp_hp = Lerp(5 *FrameTime(),lerp_hp,hp)
			draw.RoundedBox(0,ScrW() /1.75,ScrH() -95,180,20,Color(hp_r,hp_g,hp_b,40))
			draw.RoundedBox(0,ScrW() /1.75,ScrH() -95,(190 *math.Clamp(lerp_hp,0,maxhp)) /maxhp,20,Color(hp_r,hp_g,hp_b,255))
			surface.SetDrawColor(hp_r,hp_g,hp_b,255)
			surface.DrawOutlinedRect(ScrW() /1.75,ScrH() -95,180,20)

			local finalhp = tostring(string.format("%.0f", lerp_hp).."/"..maxhp)
			local distlen = string.len(finalhp)
			local move = 0
			if distlen > 1 then
				move = move -(0.009 *(distlen -1))
			end
			draw.SimpleText(finalhp,"VJFont_Trebuchet24_SmallMedium", ScrW() /(1.6 -move),ScrH() -94,Color(255,255,255,255),0,0)
		end)
		if delete == true then hook.Remove("HUDPaint","VJ_Persona_HUD_Yu") end
	end)
end