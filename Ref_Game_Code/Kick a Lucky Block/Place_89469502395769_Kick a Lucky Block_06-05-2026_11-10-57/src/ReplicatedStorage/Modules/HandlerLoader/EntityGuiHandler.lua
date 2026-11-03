-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Shared.Packages.Observers)
local t = {}
local v1 = tick()
local t2 = {}
local CurrentCamera = workspace.CurrentCamera
function UpdateGuis() --[[ UpdateGuis | Line: 22 | Upvalues: CurrentCamera (copy), t2 (copy) ]]
	local Position = CurrentCamera.CFrame.Position
	for k in pairs(t2) do
		if k then
			if k:IsA("BillboardGui") then
				local Adornee = k.Adornee
				if Adornee then
					local MaxDistance = k.MaxDistance
					local Magnitude = (Adornee.Position - Position).Magnitude
					if MaxDistance < Magnitude and k.Enabled then
						k.Enabled = false
					end
					if Magnitude <= MaxDistance and not k.Enabled then
						k.Enabled = true
					end
				end
			end
			continue
		end
		t2[k] = nil
	end
end
function OnPreRender() --[[ OnPreRender | Line: 49 | Upvalues: v1 (ref) ]]
	local v12 = tick()
	if v12 - v1 > 0.25 then
		v1 = v12
		UpdateGuis()
	end
end
function OnNewGUI(p1) --[[ OnNewGUI | Line: 57 | Upvalues: t2 (copy) ]]
	t2[p1] = true
	return function() --[[ Line: 60 | Upvalues: t2 (ref), p1 (copy) ]]
		t2[p1] = false
	end
end
function t._init(p1) --[[ _init | Line: 67 | Upvalues: Observers (copy), RunService (copy) ]]
	Observers.observeTag("EntityGui", OnNewGUI, {
		game:GetService("Players"),
		workspace.Entities,
		workspace.Debris,
		workspace.Plots
	})
	RunService.PreRender:Connect(OnPreRender)
end
return t