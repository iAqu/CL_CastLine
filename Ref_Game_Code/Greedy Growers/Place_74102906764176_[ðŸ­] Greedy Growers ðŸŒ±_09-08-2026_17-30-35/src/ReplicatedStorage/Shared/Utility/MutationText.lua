-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig)
local t = {}
local v1 = Color3.fromRGB(255, 255, 255)

local function colorTag(p1, p2) --[[ colorTag | Line: 21 ]]
	return string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(p2.R * 255), math.round(p2.G * 255), math.round(p2.B * 255), p1)
end

function t.build(p1) --[[ build | Line: 32 | Upvalues: MutationConfig (copy), colorTag (copy), v1 (copy) ]]
	local v12 = MutationConfig.OrderKeys(p1)

	if #v12 == 0 then
		return ""
	end

	local t = {}

	for v2, v3 in v12 do
		local v4 = MutationConfig.Mutations[v3]

		table.insert(t, colorTag(v4.displayName, v4.textColor))
	end

	return table.concat(t, colorTag(" + ", v1))
end
function t.coloredName(p1) --[[ coloredName | Line: 45 | Upvalues: MutationConfig (copy) ]]
	local v1 = MutationConfig.Mutations[p1]
	local v2

	if v1 then
		local textColor = v1.textColor
		local v8 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(textColor.R * 255), math.round(textColor.G * 255), math.round(textColor.B * 255), v1.displayName)

		v2 = if v8 then v8 else ""
	else
		v2 = ""
	end

	return v2
end
function t.apply(p1, p2) --[[ apply | Line: 53 | Upvalues: MutationConfig (copy), CollectionService (copy), t (copy) ]]
	if not p1 then
		return
	end

	local v1 = MutationConfig.OrderKeys(p2)

	if p1:GetAttribute("rarity") == "CHARGED" then
		CollectionService:RemoveTag(p1, "ShinyTextLabel")

		local v2 = p1:FindFirstChildWhichIsA("UIGradient")

		if v2 then
			v2:Destroy()
		end

		p1:SetAttribute("rarity", nil)
	end

	p1.RichText = true

	if #v1 == 1 and v1[1] == "Charged" then
		p1.Text = "Charged"
		p1:SetAttribute("rarity", "CHARGED")
		CollectionService:AddTag(p1, "ShinyTextLabel")
	else
		p1.Text = t.build(v1)
	end

	p1.Visible = if #v1 > 0 then true else false
end

return t