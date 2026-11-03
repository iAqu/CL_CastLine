-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = require("../ServicesLoader/ClientIndexService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local v2 = require("@game/ReplicatedStorage/Shared/Data/EntitiesData")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local MutationData = require(ReplicatedStorage.Shared.Data.MutationData)
local FormatInfNumber = require(ReplicatedStorage.Functional.FormatInfNumber)
local Index = (PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")).Index
local ScrollingFrame = Index.Holder.ScrollingFrame
local Brainrot = ScrollingFrame.Brainrot
local v4 = Trove.new()
local t = {
	SelectedMutation = "None",
	MutationChanged = Signal.new()
}
function BuildUI() --[[ BuildUI | Line: 36 | Upvalues: v1 (copy), v2 (copy), Brainrot (copy), FormatInfNumber (copy), ScrollingFrame (copy) ]]
	local count = 0
	for i, v in ipairs(v1.List) do
		count = count + 1
		if count == 15 then
			task.wait()
			count = 0
		end
		local v12 = v2.Brainrots[v]
		assert(v12, (("Missing entity entry for brainrot named %*"):format(v)))
		local v3 = Brainrot:Clone()
		v3.Name = v
		v3:WaitForChild("CPSLabel").Text = ("$%*/s"):format((FormatInfNumber(v12.CPS)))
		v3:WaitForChild("Icon").Image = v12.Image
		v3:WaitForChild("NameLabel").Text = v
		v3.Icon.ImageColor3 = Color3.fromRGB()
		v3.NameLabel.Visible = false
		v3.Parent = ScrollingFrame
	end
	Brainrot.Visible = false
end
function UpdateUI() --[[ UpdateUI | Line: 63 | Upvalues: v1 (copy), t (copy), MutationData (copy), ScrollingFrame (copy), v2 (copy), FormatInfNumber (copy) ]]
	local v12 = v1.Mobs[t.SelectedMutation]
	local v22 = if t.SelectedMutation == "None" or not MutationData.Buffs[t.SelectedMutation] then 1 else MutationData.Buffs[t.SelectedMutation].Value or 1
	for i, v in ipairs(ScrollingFrame:GetChildren()) do
		if v:IsA("Frame") then
			local v3 = v.Name
			local v4 = v2.Brainrots[v3]
			if v4 then
				if table.find(v12, v3) then
					v.Icon.ImageColor3 = Color3.new(255/255, 255/255, 255/255)
					v.NameLabel.Visible = true
					v.CPSLabel.Text = ("$%*/s"):format((FormatInfNumber(v4.CPS * v22)))
				end
				v.Icon.ImageColor3 = Color3.new(0/255, 0/255, 0/255)
				v.NameLabel.Visible = false
				v.CPSLabel.Text = ("$%*/s"):format((FormatInfNumber(v4.CPS * v22)))
			end
		end
	end
end
function InitButtons() --[[ InitButtons | Line: 91 | Upvalues: Index (copy), t (copy) ]]
	for i, v in ipairs(Index.Buttons:GetChildren()) do
		if v:IsA("GuiButton") then
			v.Activated:Connect(function() --[[ Line: 94 | Upvalues: t (ref), v (copy) ]]
				t.SelectedMutation = v.Name
				t.MutationChanged:Fire()
			end)
		end
	end
	Index.Top.Main.Close.Activated:Connect(function() --[[ Line: 101 | Upvalues: Index (ref) ]]
		Index.Visible = false
	end)
end
function HandleGamepad() --[[ HandleGamepad | Line: 106 | Upvalues: GuiService (copy), ScrollingFrame (copy), v4 (copy), UserInputService (copy), Index (copy) ]]
	GuiService:Select(ScrollingFrame)
	v4:Add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 109 | Upvalues: Index (ref) ]]
		if not p2 and p1.KeyCode == Enum.KeyCode.ButtonB then
			Index.Visible = false
		end
	end))
	v4:Connect(Index:GetPropertyChangedSignal("Visible"), function() --[[ Line: 119 | Upvalues: Index (ref), v4 (ref) ]]
		if not Index.Visible then
			v4:Clean()
		end
	end)
	v4:Add(function() --[[ Line: 125 | Upvalues: GuiService (ref) ]]
		GuiService.SelectedObject = nil
	end)
end
function VisibleChanged() --[[ VisibleChanged | Line: 130 | Upvalues: Index (copy), ClientProfile (copy) ]]
	if Index.Visible then
		UpdateUI()
		if ClientProfile.Device ~= ClientProfile.DeviceTypes.Console then
			return
		end
		HandleGamepad()
	end
end
function t._init() --[[ _init | Line: 140 | Upvalues: Index (copy), t (copy) ]]
	BuildUI()
	InitButtons()
	VisibleChanged()
	Index:GetPropertyChangedSignal("Visible"):Connect(VisibleChanged)
	t.MutationChanged:Connect(UpdateUI)
end
return t