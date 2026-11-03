-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
return function(p1) --[[ Line: 3 | Upvalues: TweenService (copy) ]]
	if p1 then
		local Highlight = Instance.new("Highlight")
		Highlight.FillColor = Color3.fromRGB(255, 255, 255)
		Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		Highlight.FillTransparency = 0
		Highlight.OutlineTransparency = 0
		Highlight.Parent = p1
		local v1 = TweenService:Create(Highlight, TweenInfo.new(0.4), {
			FillTransparency = 1,
			OutlineTransparency = 1
		})
		v1.Completed:Once(function() --[[ Line: 23 | Upvalues: Highlight (copy) ]]
			Highlight:Destroy()
		end)
		v1:Play()
	end
end