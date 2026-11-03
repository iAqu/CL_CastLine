-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Shared.Packages.Observers)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local t = {}
function ObservePart(p1) --[[ ObservePart | Line: 11 ]]
	local v1 = p1:FindFirstAncestorOfClass("Model")
	if v1 and v1.Parent == workspace.Plots then
		local TextLabel = (p1:FindFirstChild("SurfaceGui") or p1:WaitForChild("OwnerGUI")):WaitForChild("TextLabel")
		local function UpdateGUI() --[[ UpdateGUI | Line: 20 | Upvalues: v1 (copy), TextLabel (copy) ]]
			TextLabel.Text = v1:GetAttribute("Owner") or "None"
		end
		TextLabel.Text = v1:GetAttribute("Owner") or "None"
		v1:GetAttributeChangedSignal("Owner"):Connect(UpdateGUI)
	end
end
function t._init() --[[ _init | Line: 29 | Upvalues: Observers (copy), Tags (copy) ]]
	Observers.observeTag(Tags.PlotOwnerPart, ObservePart, { workspace:WaitForChild("Plots") })
end
return t