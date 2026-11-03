-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local EntitiesAnimations = game:GetService("ReplicatedStorage").Objects.EntitiesAnimations
return function(p1, p2) --[[ Line: 7 | Upvalues: EntitiesAnimations (copy) ]]
	local v1 = EntitiesAnimations:FindFirstChild(p1.Name)
	if v1 then
		local v2 = p1:FindFirstChild("Humanoid") or p1:FindFirstChild("AnimationController")
		if v2 then
			local v4 = (v2:FindFirstChild("Animator") or v2:WaitForChild("Animator")):LoadAnimation(v1)
			v4.Looped = true
			v4:Play()
			local v5 = if p2 then p2:Connect(function(p1) --[[ Line: 27 | Upvalues: v4 (copy) ]]
	if p1 then
		v4:Play()
	else
		v4:Stop()
	end
end) else nil
			return function() --[[ Line: 36 | Upvalues: v4 (copy), v5 (ref) ]]
				v4:Destroy()
				if v5 and v5.Connected then
					v5:Disconnect()
				end
			end
		end
	end
end