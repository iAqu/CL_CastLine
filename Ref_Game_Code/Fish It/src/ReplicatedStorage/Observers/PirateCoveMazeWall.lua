-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Modules.Util.TweenUtil)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local v1 = Net:RemoteEvent("GainAccessToMaze")
local Islands = workspace:WaitForChild("Islands")
Observers.observePlayer(function(p1) --[[ Line: 20 | Upvalues: UserPriority (copy), Replion (copy), Islands (copy), Players (copy), v1 (copy) ]]
	if not UserPriority:IsTradePlaza() then
		Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 25 | Upvalues: Islands (ref), Players (ref), v1 (ref) ]]
			local PirateCoveWall = Islands["Pirate\'s Cove"]:FindFirstChild("PirateCoveWall")
			local v12 = p1:Get("UnlockedPirateMaze")
			if not PirateCoveWall then
				warn("Failed to find Pirate Cove Wall")
				return
			end
			if v12 then
				PirateCoveWall:Destroy()
				return
			end
			local v2 = PirateCoveWall:FindFirstChildWhichIsA("ProximityPrompt", true)
			if v2 then
				v2.Triggered:Connect(function(p1) --[[ Line: 36 | Upvalues: Players (ref), v1 (ref) ]]
					if p1 ~= Players.LocalPlayer then
						return
					end
					v1:FireServer()
				end)
			else
				warn("Failed to find prompt!!")
			end
		end)
	end
end)
v1.OnClientEvent:Connect(function() --[[ Line: 48 | Upvalues: UserPriority (copy), Islands (copy) ]]
	if UserPriority:IsTradePlaza() then
		return
	end
	local PirateCoveWall = Islands["Pirate\'s Cove"]:FindFirstChild("PirateCoveWall")
	if not PirateCoveWall then
		return
	end
	Explosion(PirateCoveWall)
end)
function Emit(p1) --[[ Emit | Line: 60 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			local v1 = v:GetAttribute("EmitCount") or 1
			local v2 = v:GetAttribute("EmitDelay") or 0
			if v2 then
				task.delay(v2, function() --[[ Line: 68 | Upvalues: v (copy), v1 (copy) ]]
					v:Emit(v1)
				end)
				continue
			end
			v:Emit(v1)
		end
	end
end
function Explosion(p1) --[[ Explosion | Line: 77 | Upvalues: ReplicatedStorage (copy), TweenService (copy) ]]
	p1.Prompt.ProximityPrompt.Enabled = false
	local TNT = ReplicatedStorage.Assets.SearchItems.TNT.TNT
	local t = {}
	for v1, v2 in p1.TNT:GetChildren() do
		local v3 = TNT:Clone()
		v3:PivotTo(v2.CFrame)
		v3.Parent = v2.Parent
		for v4, v5 in v2.Fuse:GetChildren() do
			v5.Enabled = true
		end
		table.insert(t, v3)
		local v6 = v1 * 0.25 + 1
		task.delay(v6, Emit, v2)
		task.delay(v6, v3.Destroy, v3)
	end
	task.wait(1.5)
	for v7, v8 in p1.Rocks:GetChildren() do
		local v9 = TweenService:Create(v8, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), {
			Transparency = 1
		})
		v9.Completed:Once(function() --[[ Line: 104 | Upvalues: v9 (copy) ]]
			v9:Play()
		end)
		v9:Play()
	end
	task.wait(1)
	p1:Destroy()
end
return {}