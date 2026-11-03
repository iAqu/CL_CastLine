-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
RunService.RenderStepped:Connect(function(p1) --[[ Line: 7 | Upvalues: CollectionService (copy) ]]
	local v2 = p1 * 60 * 3
	for i, v in ipairs((CollectionService:GetTagged("AnimateTier"))) do
		v.Rotation = v.Rotation + v2
	end
end)
return {}