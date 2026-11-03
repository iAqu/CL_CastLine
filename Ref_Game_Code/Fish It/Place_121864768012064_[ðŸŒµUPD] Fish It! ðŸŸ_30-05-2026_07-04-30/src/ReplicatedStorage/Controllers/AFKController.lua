-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Net = require(ReplicatedStorage.Packages.Net)
local Signal = require(ReplicatedStorage.Packages.Signal)
local PlayerEvents = require(ReplicatedStorage.Shared.PlayerEvents)
local v1 = Net:RemoteEvent("ReconnectPlayer")
local v2 = 0
local v3 = Signal.new()
local t = {
	SetTime = function(p1, p2) --[[ SetTime | Line: 23 | Upvalues: v2 (ref), v3 (copy) ]]
		v2 = p2
		v3:Fire()
	end,
	RemoveTime = function(p1, p2) --[[ RemoveTime | Line: 28 | Upvalues: v2 (ref), v3 (copy) ]]
		if v2 ~= 0 then
			v2 = 0
			v3:Fire()
		end
	end
}
function t.Start(p1) --[[ Start | Line: 37 | Upvalues: UserInputService (copy), t (copy), PlayerEvents (copy), LocalPlayer (copy), v3 (copy), v2 (ref), v1 (copy) ]]
	UserInputService.InputBegan:Connect(function() --[[ Line: 38 | Upvalues: t (ref) ]]
		t:RemoveTime("Input")
	end)
	UserInputService.WindowFocused:Connect(function() --[[ Line: 41 | Upvalues: t (ref) ]]
		t:RemoveTime("Focused")
	end)
	PlayerEvents:PlayerRemoving(function(p1) --[[ Line: 44 | Upvalues: LocalPlayer (ref), t (ref) ]]
		if p1 ~= LocalPlayer then
			return
		end
		t:RemoveTime("Left")
	end)
	LocalPlayer.Idled:Connect(function(p1) --[[ Line: 50 | Upvalues: t (ref) ]]
		t:SetTime(p1)
	end)
	v3:Connect(function() --[[ Line: 54 | Upvalues: v2 (ref), v1 (ref) ]]
		if not (v2 >= 900) then
			return
		end
		v1:FireServer()
	end)
end
return t