-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require("../ServicesLoader/ClientPlotService")
game:GetService("SoundService")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {
	HoldingChanged = require(ReplicatedStorage.Shared.Packages.Signal).new(),
	IsHolding = false
}
local t2 = {}
function OnPromptTriggered(p1) --[[ OnPromptTriggered | Line: 20 | Upvalues: Network (copy) ]]
	Network.FireServer("S_Interact", (tonumber((p1.Name:gsub("Slot", "")))))
end
function CreatePromptForPart(p1) --[[ CreatePromptForPart | Line: 26 | Upvalues: t2 (copy), ReplicatedStorage (copy) ]]
	if not t2[p1] then
		local Attachment = Instance.new("Attachment")
		Attachment.Position = Vector3.new(0, 3, 0)
		Attachment.Parent = p1
		local v1 = ReplicatedStorage.Objects.Prompts.CustomPrompt:Clone()
		v1.Enabled = false
		v1.HoldDuration = 0.5
		v1.ActionText = "Place"
		v1.Parent = Attachment
		p1.ChildRemoved:Connect(UpdatePrompts)
		v1.Triggered:Connect(function() --[[ Line: 43 | Upvalues: p1 (copy) ]]
			OnPromptTriggered(p1)
		end)
		t2[p1] = v1
	end
end
function PartRemoved(p1) --[[ PartRemoved | Line: 49 | Upvalues: t2 (copy) ]]
	if t2[p1] then
		t2[p1]:Destroy()
	end
end
function LoadAllPrompts(p1) --[[ LoadAllPrompts | Line: 55 ]]
	for i, v in ipairs(p1.Slots:GetChildren()) do
		CreatePromptForPart(v)
	end
	p1.Slots.ChildAdded:Connect(CreatePromptForPart)
	p1.Slots.ChildRemoved:Connect(PartRemoved)
	UpdatePrompts(false)
end
function UpdatePrompts() --[[ UpdatePrompts | Line: 68 | Upvalues: t (copy), t2 (copy) ]]
	local IsHolding = t.IsHolding
	for k, v in pairs(t2) do
		if k:FindFirstChildOfClass("Part") then
			if IsHolding then
				v.ActionText = "Replace"
				v.Enabled = true
			end
			v.ActionText = "Pickup"
			v.Enabled = true
		end
		if IsHolding then
			v.ActionText = "Place"
			v.Enabled = true
		end
		v.Enabled = false
	end
end
function OnHoldingChanged(p1) --[[ OnHoldingChanged | Line: 88 ]]
	UpdatePrompts(p1)
end
function t.LoadPlot(p1, p2) --[[ LoadPlot | Line: 94 ]]
	LoadAllPrompts(p2)
end
function t._init() --[[ _init | Line: 100 | Upvalues: t (copy) ]]
	t.HoldingChanged:Connect(OnHoldingChanged)
end
return t