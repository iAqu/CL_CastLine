-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local ClickGUI = script:WaitForChild("ClickGUI")
local v1 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true)
return function(p1) --[[ Line: 12 | Upvalues: Trove (copy), ClickGUI (copy), TweenService (copy), v1 (copy) ]]
	if p1 then
		local v12 = Trove.new()
		local v2 = v12:Clone(ClickGUI)
		v2.Parent = p1
		local v3 = TweenService:Create(v2, v1, {
			StudsOffset = Vector3.new(3, 0, 0)
		})
		v3:Play()
		return function() --[[ Line: 24 | Upvalues: v3 (copy), v12 (copy) ]]
			v3:Cancel()
			v3:Destroy()
			v12:Clean()
		end
	end
end