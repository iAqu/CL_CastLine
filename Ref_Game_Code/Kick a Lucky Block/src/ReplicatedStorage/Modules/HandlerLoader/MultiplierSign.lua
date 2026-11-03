-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Shared.Packages.Observers)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local t = {}
function ObservePart(p1) --[[ ObservePart | Line: 11 ]]
	local TextLabel = (p1:FindFirstChild("SurfaceGui") or p1:WaitForChild("SurfaceGui")):WaitForChild("TextLabel")
	local function UpdateGUI() --[[ UpdateGUI | Line: 15 | Upvalues: p1 (copy), TextLabel (copy) ]]
		TextLabel.Text = ("x%* Multi"):format(p1:GetAttribute("Multiplier") or 1)
	end
	TextLabel.Text = ("x%* Multi"):format(p1:GetAttribute("Multiplier") or 1)
	p1:GetAttributeChangedSignal("Multiplier"):Connect(UpdateGUI)
end
function t._init() --[[ _init | Line: 24 | Upvalues: Observers (copy), Tags (copy) ]]
	Observers.observeTag(Tags.CoinMultiPart, ObservePart, { workspace:WaitForChild("Plots") })
end
return t