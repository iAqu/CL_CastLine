-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
return function(p1) --[[ Line: 9 | Upvalues: Trove (copy), RunService (copy), TweenService (copy) ]]
	local Root = p1:FindFirstChild("Root")
	if Root and not p1:GetAttribute("HOVERING") then
		p1:SetAttribute("HOVERING", true)
		local v1 = Root.CFrame
		local v2 = Root.CFrame * CFrame.new(0, 3, 0)
		local v3 = Trove.new()
		local v4 = 0
		v3:Add(RunService.PreRender:Connect(function(p12) --[[ Line: 29 | Upvalues: v4 (ref), Root (copy), v1 (copy), v3 (copy), p1 (copy), TweenService (ref), v2 (copy) ]]
			v4 = v4 + p12
			local v22 = math.clamp(v4 / 0.33, 0, 1)
			if v22 == 1 then
				Root.CFrame = v1
				v3:Destroy()
				p1:SetAttribute("HOVERING", nil)
			else
				local v32 = TweenService:GetValue(v22, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
				if v22 > 0.5 then
					Root.CFrame = v2:Lerp(v1, v32)
				else
					Root.CFrame = v1:Lerp(v2, v32)
				end
			end
		end))
	end
end