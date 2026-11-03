-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PackService_Client = require(ReplicatedStorage.Modules.ServicesLoader.PackService_Client)
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local PacksData = require(ReplicatedStorage.Shared.Data.PacksData)
local LuckyBlockTool = script.LuckyBlockTool
local PityFrame = LuckyBlockTool.PityFrame
local t = {}
function Initialize() --[[ Initialize | Line: 20 | Upvalues: LuckyBlockTool (copy) ]]
	local LocalPlayer = game:GetService("Players").LocalPlayer
	LuckyBlockTool.Enabled = false
	LuckyBlockTool.Parent = LocalPlayer.PlayerGui
end
function GetNextInPity(p1, p2) --[[ GetNextInPity | Line: 26 ]]
	local v1 = 999
	local v2 = nil
	for i, v in ipairs(p1) do
		if p2 <= v.Pity and v.Pity < v1 then
			v1 = v.Pity
			v2 = v.Name
		end
	end
	return v2, v1
end
function t.ShowPity(p1, p2) --[[ ShowPity | Line: 41 | Upvalues: PacksData (copy), PackService_Client (copy), EntitiesData (copy), PityFrame (copy), LuckyBlockTool (copy) ]]
	local v1 = PacksData.Pity[p2]
	if v1 then
		local v2 = PackService_Client.Pity[p2] or 0
		local v3, v4 = GetNextInPity(v1, v2)
		PityFrame.ImageLabel.Image = if EntitiesData.Brainrots[v3] then EntitiesData.Brainrots[v3].Image or "" else ""
		PityFrame.Pity.Text = ("%*/%*"):format(v2, v4)
		LuckyBlockTool.Enabled = true
	end
end
function t.Hide(p1) --[[ Hide | Line: 57 | Upvalues: LuckyBlockTool (copy) ]]
	LuckyBlockTool.Enabled = false
end
function t._init(p1) --[[ _init | Line: 63 ]]
	Initialize()
end
return t