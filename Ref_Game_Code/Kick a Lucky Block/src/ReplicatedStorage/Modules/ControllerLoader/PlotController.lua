-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientPlotService = require(ReplicatedStorage.Modules.ServicesLoader.ClientPlotService)
game:GetService("TweenService")
local PlotHitboxController = require(ReplicatedStorage.Modules.ControllerLoader.PlotHitboxController)
local v1 = require("../ControllerLoader/SlotUpgradeController")
local v2 = require("../ControllerLoader/PlotIconController")
local PlacementController = require(ReplicatedStorage.Modules.ControllerLoader.PlacementController)
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {
	Loaded = false
}
function LoadRebirthButton(p1) --[[ LoadRebirthButton | Line: 22 | Upvalues: ReplicatedStorage (copy) ]]
	local CashMultiplier = p1.Decorations:WaitForChild("CashMultiplier")
	local v1 = ReplicatedStorage.Objects.Prompts.CustomPrompt:Clone()
	v1.Parent = CashMultiplier
	v1.ActionText = "Upgrade"
	v1.HoldDuration = 0
	v1.Triggered:Connect(function() --[[ Line: 30 ]] end)
end
function LoadPlot(...) --[[ LoadPlot | Line: 35 | Upvalues: v1 (copy), PlotHitboxController (copy), v2 (copy), PlacementController (copy) ]]
	v1:PlaceSign(...)
	PlotHitboxController:LoadHitbox(...)
	v2:LoadIcon(...)
	PlacementController:LoadPlot(...)
end
function t.LoadPlot(p1, p2) --[[ LoadPlot | Line: 44 ]]
	if not p1.Loaded then
		p1.Loaded = true
		LoadPlot(p2)
	end
end
function t._init() --[[ _init | Line: 53 | Upvalues: ClientPlotService (copy), t (copy) ]]
	if ClientPlotService.Model then
		t:LoadPlot(ClientPlotService.Model)
	else
		ClientPlotService.ModelAdded:Connect(function(...) --[[ Line: 57 | Upvalues: t (ref) ]]
			t:LoadPlot(...)
		end)
	end
end
return t