-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local v1 = CFrame.new(25.5, 26, 0)
local v2 = 0
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {
	IsInPlot = false,
	PlayerInPlot = Signal.new()
}
function InitializeHitboxTouched(p1) --[[ InitializeHitboxTouched | Line: 21 | Upvalues: LocalPlayer (copy), t (copy), RunService (copy), v2 (ref) ]]
	local v1 = OverlapParams.new()
	v1.FilterType = Enum.RaycastFilterType.Include
	local function UpdateParams() --[[ UpdateParams | Line: 25 | Upvalues: v1 (copy), LocalPlayer (ref) ]]
		v1.FilterDescendantsInstances = { LocalPlayer.Character }
	end
	local function CheckInPlot() --[[ CheckInPlot | Line: 29 | Upvalues: p1 (copy), v1 (copy), t (ref) ]]
		local v12 = workspace:GetPartsInPart(p1, v1)
		if #v12 > 0 and not t.IsInPlot then
			t.IsInPlot = true
			t.PlayerInPlot:Fire(t.IsInPlot)
		elseif #v12 == 0 and t.IsInPlot then
			t.IsInPlot = false
			t.PlayerInPlot:Fire(t.IsInPlot)
		end
	end
	RunService.PreRender:Connect(function(p1) --[[ Line: 40 | Upvalues: v2 (ref), CheckInPlot (copy) ]]
		v2 = v2 + p1
		if v2 > 0.25 then
			v2 = 0
			CheckInPlot()
		end
	end)
	v1.FilterDescendantsInstances = { LocalPlayer.Character }
	LocalPlayer.CharacterAdded:Connect(UpdateParams)
end
function t.LoadHitbox(p1, p2) --[[ LoadHitbox | Line: 52 | Upvalues: v1 (copy) ]]
	local v12 = p2:GetPivot():ToWorldSpace(v1)
	local v2 = script.PlotHitbox:Clone()
	v2.CFrame = v12
	v2.Parent = workspace.Debris
	InitializeHitboxTouched(v2)
end
return t