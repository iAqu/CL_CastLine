-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local v1 = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false);
({}).Offset = Vector2.new(-1.5, 0)
local t = {
	Offset = Vector2.new(1.5, 0)
}
Observers.observeTag("ShineEffect", function(p1) --[[ Line: 10 | Upvalues: TweenService (copy), v1 (copy), t (copy) ]]
	local v12 = true
	local v2 = nil
	task.spawn(function() --[[ Line: 14 | Upvalues: v2 (ref), TweenService (ref), p1 (copy), v1 (ref), t (ref), v12 (ref) ]]
		v2 = TweenService:Create(p1, v1, t)
		while v12 do
			p1.Offset = Vector2.new(-1.5, 0)
			v2:Play()
			v2.Completed:Wait()
			task.wait(1)
		end
	end)
	return function() --[[ Line: 25 | Upvalues: v2 (ref), v12 (ref) ]]
		if v2 then
			v2:Cancel()
			v2:Destroy()
		end
		v12 = false
	end
end)
return {}