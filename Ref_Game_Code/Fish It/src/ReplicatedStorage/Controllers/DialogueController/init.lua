-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ProximityPromptService = game:GetService("ProximityPromptService")
game:GetService("RunService")
game:GetService("UserInputService")
game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Net = require(ReplicatedStorage.Packages.Net)
local Signal = require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Thread)
require(ReplicatedStorage.Packages.Observers)
require(script.Internal.Types)
local DialogueTree = require(script.Internal.DialogueTree)
local v1 = Net:RemoteEvent("ToggleTridentLevels")
local v2 = Net:RemoteEvent("ResetTridentLevels")
local v3 = Signal.new()
local v4 = false
local v5 = nil
local v6 = false
local t = {}
function t.New(p1, p2, p3) --[[ New | Line: 31 | Upvalues: t (copy), DialogueTree (copy), v5 (ref) ]]
	if t:IsLocked() or not DialogueTree[p2] then
		return false
	end
	local v1 = if p3:IsA("Model") then p3:WaitForChild("Head") else p3
	if v1 then
		t:Lock()
		local v2 = v5.create(p2, v1, p3)
		v2:onDestroyed(function() --[[ Line: 44 | Upvalues: t (ref) ]]
			t:Unlock()
		end)
		v2:populate()
		local v3 = v2:wait()
		v2:destroy()
		return v3
	else
		return false
	end
end
function t.Wait(p1) --[[ Wait | Line: 56 | Upvalues: v4 (ref), v3 (copy) ]]
	if v4 then
		return
	end
	v3:Wait()
end
function t.ObservePath(p1, p2, p3, p4) --[[ ObservePath | Line: 62 | Upvalues: t (copy), v5 (ref) ]]
	local v1 = nil
	task.spawn(function() --[[ Line: 65 | Upvalues: t (ref), v1 (ref), v5 (ref), p2 (copy), p3 (copy), p4 (copy) ]]
		t:Wait()
		v1 = v5.PathSignal:Connect(function(p1, p22, p32) --[[ Line: 68 | Upvalues: p2 (ref), p3 (ref), p4 (ref) ]]
			if p1 ~= p2 or p3 ~= p22 then
				return
			end
			p4(p32)
		end)
	end)
	return function() --[[ Line: 75 | Upvalues: v1 (ref) ]]
		if not v1 then
			return
		end
		v1:Disconnect()
	end
end
function t.Lock(p1) --[[ Lock | Line: 82 | Upvalues: v6 (ref), ProximityPromptService (copy) ]]
	v6 = true
	ProximityPromptService.Enabled = false
end
function t.Unlock(p1) --[[ Unlock | Line: 87 | Upvalues: v6 (ref), ProximityPromptService (copy) ]]
	v6 = false
	ProximityPromptService.Enabled = true
end
function t.IsLocked(p1) --[[ IsLocked | Line: 92 | Upvalues: v6 (ref) ]]
	return v6 == true
end
function t.Start(p1) --[[ Start | Line: 96 | Upvalues: v5 (ref), v4 (ref), v3 (copy), t (copy), v1 (copy), v2 (copy) ]]
	v5 = require(script.Internal.Dialogue)
	v4 = true
	v3:Fire()
	t:ObservePath("Blacksmith", 1, function(p1) --[[ Line: 102 | Upvalues: v1 (ref), v2 (ref) ]]
		if p1 == 1 then
			v1:FireServer()
			return
		end
		if p1 ~= 2 then
			return
		end
		v2:FireServer()
	end)
end
return t