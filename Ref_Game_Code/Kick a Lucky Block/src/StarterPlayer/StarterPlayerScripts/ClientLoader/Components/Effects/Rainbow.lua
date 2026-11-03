-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local t = {
	Tag = ({
		Tag = "ColorRainbow"
	}).Tag
}
t.__index = t
local v1 = TweenInfo.new(10, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
function t.new(p1) --[[ new | Line: 26 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Object = p1,
		Tween = nil,
		Initialized = false
	}, t)
	v2:_init()
	return v2
end
function t._init(p1) --[[ _init | Line: 38 | Upvalues: Trove (copy), TweenService (copy), v1 (copy) ]]
	if not p1.Initialized then
		p1.Initialized = true
		p1.Trove = Trove.new()
		local ClassName = p1.Object.ClassName
		if ClassName == "UIGradient" then
			local Object = p1.Object
			local v12 = p1.Trove:Add(Instance.new("NumberValue"))
			v12.Parent = Object
			p1.Trove:Connect(v12.Changed, function(p1) --[[ Line: 54 | Upvalues: Object (copy) ]]
				Object.Color = ColorSequence.new(Color3.fromHSV(p1, 0.75, 1))
			end)
			local v2 = TweenService:Create(v12, v1, {
				Value = 1
			})
			v2:Play()
			p1.Trove:Add(function() --[[ Line: 61 | Upvalues: v2 (copy) ]]
				v2:Cancel()
				v2:Destroy()
			end)
		elseif ClassName == "BasePart" or (ClassName == "MeshPart" or ClassName == "Part") then
			local Object = p1.Object
			local SurfaceAppearance = p1.Object:FindFirstChildOfClass("SurfaceAppearance")
			local v3 = p1.Trove:Add(Instance.new("NumberValue"))
			v3.Parent = Object
			p1.Trove:Add(v3.Changed:Connect(function(p1) --[[ Line: 71 | Upvalues: Object (copy), SurfaceAppearance (copy) ]]
				Object.Color = Color3.fromHSV(p1, 0.75, 0.7)
				if SurfaceAppearance then
					SurfaceAppearance.Color = Color3.fromHSV(p1, 0.75, 0.7)
				end
			end))
			local v4 = TweenService:Create(v3, v1, {
				Value = 1
			})
			v4:Play()
			p1.Trove:Add(function() --[[ Line: 81 | Upvalues: v4 (copy) ]]
				v4:Cancel()
				v4:Destroy()
			end)
		elseif ClassName == "SurfaceAppearance" then
			local Object = p1.Object
			local v5 = p1.Trove:Add(Instance.new("NumberValue"))
			v5.Parent = Object
			p1.Trove:Add(v5.Changed:Connect(function(p1) --[[ Line: 90 | Upvalues: Object (copy) ]]
				Object.EmissiveTint = Color3.fromHSV(p1, 1, 1)
			end))
			local v6 = TweenService:Create(v5, v1, {
				Value = 1
			})
			v6:Play()
			p1.Trove:Add(function() --[[ Line: 97 | Upvalues: v6 (copy) ]]
				v6:Cancel()
				v6:Destroy()
			end)
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 104 ]]
	p1.Trove:Destroy()
end
return t