-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = ReplicatedStorage.Objects.Animations
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = require(ReplicatedStorage.Shared.Packages.Trove).new()
local t = {
	LoadedAnimations = {}
}
function t.PlayAnim(p1) --[[ PlayAnim | Line: 20 | Upvalues: t (copy), LocalPlayer (copy), Animations (copy) ]]
	if p1 then
		if typeof(p1) == "Instance" then
			p1 = p1.Name
		elseif typeof(p1) ~= "string" then
			return
		end
		local v1 = t.LoadedAnimations[p1]
		if not v1 then
			local v2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Animator", true)
			if v2 then
				local v3 = Animations:FindFirstChild(p1)
				if v3 then
					t.LoadedAnimations[p1] = v2:LoadAnimation(v3)
					v1 = t.LoadedAnimations[p1]
				else
					return
				end
			else
				return
			end
		end
		v1:Play()
		return v1
	end
end
function t.StopAnim(p1) --[[ StopAnim | Line: 51 | Upvalues: t (copy) ]]
	if p1 then
		if typeof(p1) == "Instance" then
			p1 = p1.Name
		elseif typeof(p1) ~= "string" then
			return
		end
		if t.LoadedAnimations[p1] and t.LoadedAnimations[p1].IsPlaying then
			t.LoadedAnimations[p1]:Stop()
		end
	end
end
function LoadCharacter(p1) --[[ LoadCharacter | Line: 67 | Upvalues: v1 (copy), Animations (copy), t (copy) ]]
	v1:Clean()
	local v12 = p1:FindFirstChild("Humanoid") or p1:WaitForChild("Humanoid")
	local v2 = v12:FindFirstChild("Animator") or v12:WaitForChild("Animator")
	for i, v in ipairs(Animations:GetChildren()) do
		t.LoadedAnimations[v.Name] = v2:LoadAnimation(v)
	end
	v1:Add(function() --[[ Line: 77 | Upvalues: t (ref) ]]
		for k, v in pairs(t.LoadedAnimations) do
			v:Destroy()
		end
	end)
end
function t._init() --[[ _init | Line: 84 | Upvalues: LocalPlayer (copy) ]]
	if LocalPlayer.Character then
		LoadCharacter(LocalPlayer.Character)
	end
	LocalPlayer.CharacterAdded:Connect(LoadCharacter)
end
return t