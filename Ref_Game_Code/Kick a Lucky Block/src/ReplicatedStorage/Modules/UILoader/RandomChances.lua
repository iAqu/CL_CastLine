-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local v1 = PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")
local v2 = PlayerGui:FindFirstChild("HUD") or PlayerGui:WaitForChild("HUD")
local RandomChances = v1.RandomChances
local BrainrotTemplate = RandomChances.Color.ScrollingFrame.BrainrotTemplate
local RandomButton = v2.LeftPanel.RandomBrainrot.RandomButton
local t = {}
function LoadChances() --[[ LoadChances | Line: 24 | Upvalues: EntitiesData (copy), BrainrotTemplate (copy) ]]
	for k, v in pairs(EntitiesData.LuckyBlocks.RandomBrainrot.Pool) do
		local v1 = v.Name
		local v3 = BrainrotTemplate:Clone()
		v3:WaitForChild("NameLabel").Text = v1
		v3:WaitForChild("ImageLabel").Image = EntitiesData.Brainrots[v1].Image or ""
		v3:WaitForChild("ChanceLabel").Text = ("%%%*"):format(v.Chance)
		v3.Visible = true
		v3.Parent = BrainrotTemplate.Parent
	end
end
function CycleThroughBrainrots() --[[ CycleThroughBrainrots | Line: 39 | Upvalues: RandomButton (copy), TweenService (copy) ]]
	local t = { "rbxassetid://98819253605646", "rbxassetid://123257811507033", "rbxassetid://139276568556211", "rbxassetid://122209550117388", "rbxassetid://93119742533311" }
	task.spawn(function() --[[ Line: 48 | Upvalues: t (copy), RandomButton (ref) ]]
		while true do
			for i = 1, #t do
				RandomButton.Icon.Image = t[i]
				task.wait(3)
			end
		end
	end)
	local v1 = TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local v2 = TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
	RandomButton.Icon.UIScale.Scale = 0.9
	TweenService:Create(RandomButton.Icon.UIScale, v1, {
		Scale = 1.1
	}):Play()
	TweenService:Create(RandomButton.Sunburst, v2, {
		Rotation = RandomButton.Sunburst.Rotation + 360
	}):Play()
end
function InitConnections() --[[ InitConnections | Line: 65 | Upvalues: RandomButton (copy), RandomChances (copy) ]]
	RandomButton.Hint.Activated:Connect(function() --[[ Line: 66 | Upvalues: RandomChances (ref) ]]
		RandomChances.Visible = not RandomChances.Visible
	end)
	RandomChances.Close.Activated:Connect(function() --[[ Line: 70 | Upvalues: RandomChances (ref) ]]
		RandomChances.Visible = false
	end)
end
function t._init() --[[ _init | Line: 75 ]]
	LoadChances()
	InitConnections()
	CycleThroughBrainrots()
end
return t