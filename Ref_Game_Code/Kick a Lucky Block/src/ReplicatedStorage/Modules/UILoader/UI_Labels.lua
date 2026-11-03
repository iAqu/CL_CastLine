-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
require(ReplicatedStorage.Shared.Data.Types)
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
require(ReplicatedStorage.Functional.FormatInfNumber)
local v1 = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, true)
local v2 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t = {}
local v4 = nil
local v5 = nil
function t.JumpEffect(p1) --[[ JumpEffect | Line: 43 | Upvalues: TweenService (copy), v1 (copy) ]]
	local v12 = TweenService:Create(p1, v1, {
		Position = UDim2.fromScale(0, -0.5)
	})
	p1.Position = UDim2.fromScale(0, 0)
	v12:Play()
end
function t.Punch(p1) --[[ Punch | Line: 49 | Upvalues: TweenService (copy), v2 (copy), v3 (copy) ]]
	local v1 = p1:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", p1)
	v1.Scale = 1
	local v22 = TweenService:Create(v1, v2, {
		Scale = 1.2
	})
	local v32 = TweenService:Create(v1, v3, {
		Scale = 1
	})
	v22.Completed:Once(function() --[[ Line: 56 | Upvalues: v32 (copy) ]]
		v32:Play()
	end)
	v22:Play()
end
function t.IncrementEffect(p1, p2, p3, p4) --[[ IncrementEffect | Line: 63 | Upvalues: v5 (ref), v4 (ref), RunService (copy), t (copy), InfiniteMath (copy) ]]
	local v1 = p1:Reverse()
	local v2 = p2:Reverse()
	v5 = v5 or p1
	local v3 = 0
	if v4 then
		v4:Disconnect()
	end
	v4 = RunService.PreRender:Connect(function(p1) --[[ Line: 77 | Upvalues: v3 (ref), t (ref), p3 (copy), p4 (copy), p2 (copy), v4 (ref), v1 (copy), v2 (copy), v5 (ref), InfiniteMath (ref) ]]
		v3 = v3 + p1
		local v22 = math.clamp(v3 / 1, 0, 1)
		if v22 == 1 then
			t.UpdateLabel(p3, p4:format((tostring(p2))))
			v4:Disconnect()
			v4 = nil
		else
			local v7 = math.round((math.lerp(v1, v2, v22)))
			v5 = v7
			t.UpdateLabel(p3, p4:format((tostring((InfiniteMath.new(v7))))))
		end
	end)
end
function t.UpdateLabel(p1, p2) --[[ UpdateLabel | Line: 96 ]]
	p1.Text = p2
end
return t