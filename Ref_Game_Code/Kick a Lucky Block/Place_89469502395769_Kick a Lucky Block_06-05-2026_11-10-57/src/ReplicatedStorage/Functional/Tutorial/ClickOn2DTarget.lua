-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local Cursor = script:WaitForChild("Cursor")
local v1 = TweenInfo.new(0.175, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true)
return function(p1) --[[ Line: 12 | Upvalues: Trove (copy), Cursor (copy), TweenService (copy), v1 (copy) ]]
	if p1 then
		local v12 = Trove.new()
		local v2 = v12:Clone(Cursor)
		v2.Parent = p1.Parent
		v2.Rotation = 0
		local v3 = p1.AbsolutePosition + Vector2.new(p1.AbsoluteSize.X, p1.AbsoluteSize.Y / 2)
		v2.Position = UDim2.fromOffset(v3.X, v3.Y)
		local v4 = TweenService:Create(v2, v1, {
			Rotation = -50
		})
		v4:Play()
		return function() --[[ Line: 28 | Upvalues: v4 (copy), v12 (copy) ]]
			v4:Cancel()
			v4:Destroy()
			v12:Clean()
		end
	end
end