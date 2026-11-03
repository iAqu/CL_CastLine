-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.Packages.Trove)
local FormatValue = require(ReplicatedStorage.Functional.FormatValue)
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 31 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Tool = p1
	}, t)
	v2:init()
	return v2
end
function t.CreateButton(p1) --[[ CreateButton | Line: 41 ]]
	if not p1.Button then
		p1.Button = script.Parent.Assets.Button:Clone()
		p1.Button:WaitForChild("SlotNum")
		p1.Button:WaitForChild("Count")
		local v1 = p1.Tool.TextureId or ""
		p1.Button:WaitForChild("Image").Image = v1
		p1.Button.Visible = v1 ~= ""
	end
end
function t.UpdateSlotNum(p1, p2) --[[ UpdateSlotNum | Line: 56 ]]
	if p2 and p2 ~= "" then
		p1.Button.SlotNum.Text = p2
		p1.Button.SlotNum.Visible = true
	else
		p1.Button.SlotNum.Visible = false
	end
end
function t.UpdateCount(p1) --[[ UpdateCount | Line: 65 | Upvalues: FormatValue (copy) ]]
	local Count = p1.Button:FindFirstChild("Count")
	if Count then
		local v1 = p1.Tool:GetAttribute("Count") or 1
		if v1 == 1 then
			Count.Visible = false
		else
			Count.Text = ("x%*"):format((FormatValue(v1)))
			Count.Visible = true
		end
	end
end
function t.UpdateFavorite(p1) --[[ UpdateFavorite | Line: 82 ]]
	p1.Button.Favorite.Visible = p1.Tool:GetAttribute("Favorite")
end
function t.UpdateEquipped(p1) --[[ UpdateEquipped | Line: 86 | Upvalues: LocalPlayer (copy) ]]
	local v1 = p1.Tool.Parent
	if v1 then
		local Button = p1.Button
		if v1 == LocalPlayer.Character then
			Button.Stroke.Enabled = true
		else
			Button.Stroke.Enabled = false
		end
	end
end
function t.init(p1) --[[ init | Line: 102 ]]
	if not p1.Initialized then
		p1.Initialized = true
		p1:CreateButton()
		p1:UpdateFavorite()
		p1:UpdateEquipped()
		p1:UpdateCount()
		p1:UpdateSlotNum()
	end
end
return t