local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlotUpgradeTransition = require(ReplicatedStorage.Modules.PlotUpgradeTransition)

local transitions = PlotUpgradeTransition.new()
local Controller = Knit.CreateController({ Name = "PlotUpgradeTransitionController", Changed = transitions.Changed })

function Controller:IsPlaying(plot): boolean
	return transitions:IsPlaying(plot)
end

function Controller:KnitStart()
	Knit.GetService("PlotUpgradeService").UpgradeTransition:Connect(function(phase, plot, id, level)
		transitions:Handle(phase, plot, id, level)
	end)
end

return Controller
