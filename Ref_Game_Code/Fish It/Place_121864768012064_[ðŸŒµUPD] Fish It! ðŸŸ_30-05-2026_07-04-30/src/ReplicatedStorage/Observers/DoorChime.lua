-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local v1 = false
local LocalPlayer = game:GetService("Players").LocalPlayer
Observers.observeTag("DoorChime", function(p1) --[[ Line: 12 | Upvalues: LocalPlayer (copy), v1 (ref), Soundbook (copy) ]]
	local v12 = p1.Touched:Connect(function(p12) --[[ Line: 14 | Upvalues: LocalPlayer (ref), v1 (ref), p1 (copy), Soundbook (ref) ]]
		if not p12:IsDescendantOf(LocalPlayer.Character) or (not LocalPlayer.Character:FindFirstChild("Humanoid") or v1) then
			return
		end
		v1 = true
		task.delay(1, function() --[[ Line: 17 | Upvalues: v1 (ref) ]]
			v1 = false
		end)
		if not (LocalPlayer.Character.Humanoid.MoveDirection:Dot((p1.Attachment.WorldCFrame.Position - p1.Position).Unit) > 0.5) then
			return
		end
		Soundbook.Sounds["Door Chime"]:Play()
	end)
	return function() --[[ Line: 31 | Upvalues: v12 (ref) ]]
		if not v12 then
			return
		end
		v12:Disconnect()
	end
end)
return {}