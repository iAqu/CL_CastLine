-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Part = function(p1) --[[ Part | Line: 3 ]]
		return p1.CFrame
	end,
	MeshPart = function(p1) --[[ MeshPart | Line: 6 ]]
		return p1.CFrame
	end,
	Bone = function(p1) --[[ Bone | Line: 9 ]]
		return p1.WorldCFrame
	end,
	Attachment = function(p1) --[[ Attachment | Line: 12 ]]
		return p1.WorldCFrame
	end
}