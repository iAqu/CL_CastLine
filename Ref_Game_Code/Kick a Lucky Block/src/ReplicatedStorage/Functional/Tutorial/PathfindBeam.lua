-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local DisplayArrow = require(ReplicatedStorage.Functional.Tutorial.DisplayArrow)
local LocalPlayer = game:GetService("Players").LocalPlayer
return function(p1, p2) --[[ Line: 16 | Upvalues: Trove (copy), DisplayArrow (copy), PathfindingService (copy), RunService (copy), LocalPlayer (copy) ]]
	if p1 and p2 then
		if typeof(p2) == "Instance" and p2:IsA("BasePart") then
			p2 = p2.Position
		end
		if typeof(p2) == "Vector3" and typeof(p1) == "Vector3" then
			local v1 = Trove.new()
			local function Cleanup() --[[ Cleanup | Line: 32 | Upvalues: v1 (copy), DisplayArrow (ref) ]]
				v1:Destroy()
				DisplayArrow(nil)
			end
			local v2 = PathfindingService:CreatePath({
				AgentRadius = 4,
				AgentHeight = 5,
				AgentCanJump = false,
				WaypointSpacing = 50
			})
			v2:ComputeAsync(p1, p2)
			local t = {}
			for i, v in ipairs((v2:GetWaypoints())) do
				local v4 = v1:Clone(script.Part)
				v4.Position = v.Position * Vector3.new(1, 0, 1) + Vector3.new(0, p1.Y, 0)
				v4.Parent = workspace.Debris
				table.insert(t, v4)
			end
			local v6 = nil
			local v7 = nil
			v1:Add(RunService.PreRender:Connect(function() --[[ Line: 60 | Upvalues: t (copy), v1 (copy), DisplayArrow (ref), v7 (ref), v6 (ref), LocalPlayer (ref) ]]
				if #t == 0 then
					v1:Destroy()
					DisplayArrow(nil)
				elseif not v7 then
					if not v6 then
						if #t == 1 then
							v7 = true
							DisplayArrow(t[1])
							return
						end
						v6 = table.remove(t, 1)
						if v6 then
							DisplayArrow(v6)
						else
							v1:Destroy()
							DisplayArrow(nil)
							return
						end
					end
					if LocalPlayer.Character and LocalPlayer:DistanceFromCharacter(v6.Position) < 10 then
						v6:Destroy()
						v6 = nil
					end
				end
			end))
			return Cleanup
		end
	end
end