-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:00
-- Luau version 6, Types version 3
-- Time taken: 0.001371 seconds

local module = {}
local Debris_upvr = game:GetService("Debris")
function module.DualWield_Enable(arg1) -- Line 10
	--[[ Upvalues[1]:
		[1]: Debris_upvr (readonly)
	]]
	if not arg1 then
	else
		local Character_2 = arg1.Character
		if not Character_2 then return end
		local class_Tool = Character_2:FindFirstChildOfClass("Tool")
		if not class_Tool then return end
		local clone = class_Tool:Clone()
		local Handle = clone:FindFirstChild("Handle")
		if not Handle then return end
		for _, v in pairs(class_Tool:GetDescendants()) do
			if v:IsA("LocalScript") then
				v.Enabled = false
				Debris_upvr:AddItem(v, 0)
			end
		end
		Handle.Name = "FakeWeapon"
		local Weld = Instance.new("Weld", Handle)
		Weld.Enabled = false
		Handle.Anchored = false
		Weld.C0 = CFrame.new(0.015, -0.152, -0.006)
		Weld.C1 = class_Tool.Grip * CFrame.Angles((math.pi/2), 0, 0)
		Weld.Part0 = Character_2:FindFirstChild("LeftHand")
		Weld.Part1 = Handle
		Weld.Enabled = true
		Handle.Parent = Character_2
		Debris_upvr:AddItem(clone, 0)
	end
end
function module.DualWield_Disable(arg1) -- Line 64
	--[[ Upvalues[1]:
		[1]: Debris_upvr (readonly)
	]]
	local Character = arg1.Character
	if not Character then
	else
		local FakeWeapon = Character:FindFirstChild("FakeWeapon")
		if FakeWeapon then
			Debris_upvr:AddItem(FakeWeapon, 0)
		end
	end
end
return module