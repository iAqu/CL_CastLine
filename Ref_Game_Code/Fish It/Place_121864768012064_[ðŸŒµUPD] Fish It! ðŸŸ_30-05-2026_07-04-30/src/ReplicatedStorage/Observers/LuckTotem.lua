-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local RunService = game:GetService("RunService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
Observers.observeTag("LuckTotem", function(p1) --[[ Line: 18 | Upvalues: Trove (copy), RunService (copy) ]]
	local v1 = Trove.new()
	tick()
	local v2 = p1.Parent
	if not v2 then
		return
	end
	local Gems = v2:FindFirstChild("Gems")
	local v3 = p1:WaitForChild("Overhead"):WaitForChild("Content")
	local v4 = p1:GetAttribute("ExpireTime") or 0
	local v5 = Vector3.new()
	local v6 = 0
	if Gems then
		v5 = if Gems:IsA("Model") then Gems:GetPivot().Position else Gems.Position
	end
	v1:Add(RunService.Heartbeat:Connect(function(p1) --[[ Line: 50 | Upvalues: v6 (ref), Gems (copy), v5 (ref), v3 (copy), v4 (copy) ]]
		v6 = v6 + p1
		local v2 = math.sin(v6 * 1.5) * 0.75
		local v32 = v6 * 1
		if Gems then
			local v42 = v5 + Vector3.new(0, v2 + 0.5, 0)
			local _ = CFrame.new(v42) * CFrame.Angles(0, v32, 0)
			if Gems:IsA("Model") then
				Gems:PivotTo(CFrame.new(v42) * CFrame.Angles(0, v32, 0))
			else
				Gems.CFrame = CFrame.new(v42) * CFrame.Angles(0, v32, 0)
			end
		end
		if not v3 then
			return
		end
		local v62 = math.max(v4 - workspace:GetServerTimeNow(), 0)
		local v7 = math.floor(v62 % 60)
		v3.TimerLabel.Text = ("%02i:%02i"):format((v62 - v7) / 60, v7)
	end))
	return function() --[[ Line: 91 | Upvalues: v1 (ref) ]]
		if not v1 then
			return
		end
		v1:Destroy()
		v1 = nil
	end
end)
return {}