-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Thread = require(ReplicatedStorage.Packages.Thread)
local t = {
	Color3.fromRGB(59, 158, 9),
	Color3.fromRGB(180, 155, 14),
	Color3.fromRGB(180, 65, 12),
	Color3.fromRGB(16, 115, 182),
	Color3.fromRGB(148, 33, 142)
}
Thread:Execute(1, function() --[[ Line: 16 | Upvalues: CollectionService (copy), t (copy) ]]
	for i, v in ipairs((CollectionService:GetTagged("DiscoPart"))) do
		local v2
		local Color = v.Color
		local v4 = table.find(t, (Color3.fromRGB(Color.R * 255 // 1, Color.G * 255 // 1, Color.B * 255 // 1)))
		if v4 then
			local v5 = table.clone(t)
			table.remove(v5, v4)
			v2 = v5[math.random(1, #v5)]
		else
			v2 = t[math.random(1, #t)]
		end
		v.Color = v2
	end
end)
return {}