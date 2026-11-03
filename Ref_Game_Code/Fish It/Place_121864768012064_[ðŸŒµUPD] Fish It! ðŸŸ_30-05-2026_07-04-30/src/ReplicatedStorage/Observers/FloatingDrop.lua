-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Packages.spr)
local t = {}
Observers.observeTag("FloatingDrop", function(p1) --[[ Line: 16 | Upvalues: HttpService (copy), t (copy) ]]
	local v1 = HttpService:GenerateGUID(false)
	local v2 = p1:GetAttribute("Speed")
	t[v1] = {
		StartTime = workspace:GetServerTimeNow(),
		OriginalCFrame = p1.CFrame,
		Container = p1,
		Speed = v2
	}
	return function() --[[ Line: 27 | Upvalues: t (ref), v1 (copy) ]]
		t[v1] = nil
	end
end)
RunService:BindToRenderStep("UpdateDrops", Enum.RenderPriority.Camera.Value, function() --[[ Line: 32 | Upvalues: t (copy) ]]
	local v1 = tick()
	for k, v in pairs(t) do
		local v2
		local v3 = v1 - v.StartTime
		if v.Speed then
			v2 = v.OriginalCFrame * CFrame.fromOrientation(0, math.fmod(v3 * v.Speed, 360), 0)
		else
			local v6 = Vector3.new(0, 1, 0) * (math.cos(v3) * 0.5)
			v2 = (v.OriginalCFrame + v6) * CFrame.Angles(0, math.sin(2 * v3), 0)
		end
		v.Container.CFrame = v2
	end
end)
return {}