-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {
	Model = nil,
	ModelAdded = require(ReplicatedStorage.Shared.Packages.Signal).new()
}
function OnNewPlot(p1) --[[ OnNewPlot | Line: 13 | Upvalues: t (copy) ]]
	local v1 = workspace.Plots:FindFirstChild(p1) or workspace.Plots:WaitForChild(p1)
	t.Model = v1
	task.defer(function() --[[ Line: 16 | Upvalues: t (ref), v1 (copy) ]]
		t.ModelAdded:Fire(v1)
	end)
end
function t._init(p1) --[[ _init | Line: 21 | Upvalues: Network (copy), t (copy) ]]
	Network.OnClientEvent("PlotAdded"):Connect(OnNewPlot)
	t.ModelAdded:Wait()
end
return t