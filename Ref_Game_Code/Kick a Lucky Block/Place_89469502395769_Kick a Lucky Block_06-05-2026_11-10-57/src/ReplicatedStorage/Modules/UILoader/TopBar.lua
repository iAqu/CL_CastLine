-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
require(ReplicatedStorage.Modules.ControllerLoader.TeleportController)
local v1 = require("../ControllerLoader/PlotHitboxController")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local PlacedVisualizer = require(ReplicatedStorage.Modules.ControllerLoader.PlacedVisualizer)
local GetOfflineCash = require(ReplicatedStorage.Shared.Functional.GetOfflineCash)
local TopBar = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("HUD").TopBar
local v2 = Trove.new()
local t = {
	State = ""
}
local t2 = {
	InPlot = {
		OnEnter = function() --[[ OnEnter | Line: 31 | Upvalues: TopBar (copy), PlacedVisualizer (copy), GetOfflineCash (copy), v2 (copy) ]]
			TopBar.InPlot.Visible = true
			TopBar.InPlot:TweenPosition(UDim2.fromScale(0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.15, true)
			local function UpdateOfflineEarnings() --[[ UpdateOfflineEarnings | Line: 36 | Upvalues: PlacedVisualizer (ref), GetOfflineCash (ref), TopBar (ref) ]]
				local v1 = GetOfflineCash(PlacedVisualizer.MyBrainrots)
				if v1 then
					TopBar.InPlot.TextLabel.Text = ("Your brainrots earn <font color = \"#71ff13\">$%*</font>/Day offline! \240\159\152\136"):format(v1)
				end
			end
			local v1 = GetOfflineCash(PlacedVisualizer.MyBrainrots)
			if v1 then
				TopBar.InPlot.TextLabel.Text = ("Your brainrots earn <font color = \"#71ff13\">$%*</font>/Day offline! \240\159\152\136"):format(v1)
			end
			v2:Connect(PlacedVisualizer.MyBrainrotsChanged, UpdateOfflineEarnings)
		end,
		OnLeave = function() --[[ OnLeave | Line: 49 | Upvalues: TopBar (copy), v2 (copy) ]]
			TopBar.InPlot.Visible = false
			TopBar.InPlot.Position = UDim2.fromScale(0.5, -1)
			v2:Clean()
		end
	},
	Hide = {
		OnEnter = function() --[[ OnEnter | Line: 57 ]] end,
		OnLeave = function() --[[ OnLeave | Line: 61 ]] end
	}
}
function GoToState(p1) --[[ GoToState | Line: 70 | Upvalues: t (copy), t2 (copy) ]]
	if p1 and t.State ~= p1 then
		local v1 = t2[t.State] and t2[t.State].OnLeave
		if v1 then
			v1()
		end
		t.State = p1
		local v2 = t2[p1] and t2[p1].OnEnter
		if v2 then
			v2()
		end
	end
end
function InitializeStateChanges() --[[ InitializeStateChanges | Line: 92 | Upvalues: v1 (copy) ]]
	local function CheckInPlot(p1) --[[ CheckInPlot | Line: 94 ]]
		if p1 then
			GoToState("InPlot")
		else
			GoToState("Hide")
		end
	end
	if v1.IsInPlot then
		GoToState("InPlot")
	else
		GoToState("Hide")
	end
	v1.PlayerInPlot:Connect(CheckInPlot)
end
function t._init() --[[ _init | Line: 108 ]]
	InitializeStateChanges()
end
return t