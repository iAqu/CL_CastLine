-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = require(ReplicatedStorage.Shared.Packages.Trove).new()
return function(p1) --[[ Line: 14 | Upvalues: v1 (copy), LocalPlayer (copy) ]]
	v1:Clean()
	if p1 then
		local v12 = v1:Clone(script.TutorialBeam)
		local Character = LocalPlayer.Character
		if Character then
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			if HumanoidRootPart then
				local RootAttachment = HumanoidRootPart:FindFirstChild("RootAttachment")
				if RootAttachment then
					local v2 = v1:Add(Instance.new("Attachment"))
					v2.Parent = p1
					v12.Attachment0 = v2
					v12.Attachment1 = RootAttachment
					v12.Parent = workspace.Debris
				end
			end
		end
	end
end