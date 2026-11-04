-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:45
-- Luau version 6, Types version 3
-- Time taken: 0.006962 seconds

local module_upvr = {}
local function _(arg1) -- Line 5, Named "setLastTransparency"
	if not arg1:GetAttribute("LastTransparency") then
		arg1:SetAttribute("LastTransparency", arg1.Transparency)
	end
end
function module_upvr.MasslessAll(arg1) -- Line 12
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.Massless = true
	end
	for _, v in pairs(arg1:GetChildren()) do
		module_upvr.UnQueryAll(v)
	end
end
function module_upvr.UnQueryAll(arg1) -- Line 21
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CanQuery = false
	end
	for _, v_2 in pairs(arg1:GetChildren()) do
		module_upvr.UnQueryAll(v_2)
	end
end
function module_upvr.QueryAll(arg1) -- Line 30
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CanQuery = true
	end
	for _, v_3 in pairs(arg1:GetChildren()) do
		module_upvr.QueryAll(v_3)
	end
end
function module_upvr.UnAnchoredAll(arg1) -- Line 39
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.Anchored = false
	end
	for _, v_4 in pairs(arg1:GetChildren()) do
		module_upvr.UnAnchoredAll(v_4)
	end
end
function module_upvr.AnchoredAll(arg1) -- Line 49
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.Anchored = true
	end
	for _, v_5 in pairs(arg1:GetChildren()) do
		module_upvr.AnchoredAll(v_5)
	end
end
function module_upvr.UnTouchAll(arg1) -- Line 59
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CanTouch = false
	end
	for _, v_6 in pairs(arg1:GetChildren()) do
		module_upvr.UnTouchAll(v_6)
	end
end
function module_upvr.UnCollideAll(arg1) -- Line 69
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CanCollide = false
		arg1.CanQuery = false
	end
	for _, v_7 in pairs(arg1:GetChildren()) do
		module_upvr.UnCollideAll(v_7)
	end
end
function module_upvr.CollideAll(arg1) -- Line 80
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CanCollide = true
	end
	for _, v_8 in pairs(arg1:GetChildren()) do
		module_upvr.CollideAll(v_8)
	end
end
function module_upvr.UnTransparencyAll(arg1) -- Line 90
	if arg1:IsA("BasePart") then
		arg1:SetAttribute("Transparency", arg1.Transparency)
		arg1.Transparency = 1
	end
	for _, v_9 in pairs(arg1:GetDescendants()) do
		if v_9:IsA("BasePart") then
			v_9:SetAttribute("Transparency", v_9.Transparency)
			v_9.Transparency = 1
		end
	end
end
function module_upvr.TransparencyAll(arg1) -- Line 107
	if arg1:IsA("BasePart") then
		arg1.Transparency = 0
	end
	for _, v_10 in pairs(arg1:GetDescendants()) do
		if v_10:IsA("BasePart") then
			v_10.Transparency = 0
		end
	end
end
local TweenService_upvr = game:GetService("TweenService")
function module_upvr.fadeAllTween(arg1, arg2) -- Line 123
	--[[ Upvalues[2]:
		[1]: TweenService_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == nil then
		local var57 = 1
	end
	if arg1.ClassName == "Trail" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "Texture" then
		if not arg1:GetAttribute("LastTransparency") then
			arg1:SetAttribute("LastTransparency", arg1.Transparency)
		end
		arg1.Transparency = var57
	end
	if arg1.ClassName == "RopeConstraint" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "SurfaceGui" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "PointLight" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "ParticleEmitter" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "BillboardGui" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "UnionOperation" or arg1.ClassName == "Part" or arg1.ClassName == "MeshPart" or arg1.ClassName == "Decal" then
		if not arg1:GetAttribute("LastTransparency") then
			arg1:SetAttribute("LastTransparency", arg1.Transparency)
		end
		TweenService_upvr:Create(arg1, TweenInfo.new(0.8), {
			Transparency = var57;
		}):Play()
	end
	for _, v_11 in pairs(arg1:GetChildren()) do
		module_upvr.fadeAllTween(v_11, var57)
	end
end
function module_upvr.fadeAll(arg1, arg2) -- Line 162
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == nil then
		local var66 = 1
	end
	if arg1.ClassName == "Beam" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "ProximityPrompt" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "Trail" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "Texture" then
		if not arg1:GetAttribute("LastTransparency") then
			arg1:SetAttribute("LastTransparency", arg1.Transparency)
		end
		arg1.Transparency = var66
	end
	if arg1.ClassName == "RopeConstraint" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "SurfaceGui" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "PointLight" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "ParticleEmitter" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "BillboardGui" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "UnionOperation" or arg1.ClassName == "Part" or arg1.ClassName == "MeshPart" or arg1.ClassName == "Decal" then
		if not arg1:GetAttribute("LastTransparency") then
			arg1:SetAttribute("LastTransparency", arg1.Transparency)
		end
		arg1.Transparency = var66
	end
	for _, v_12 in pairs(arg1:GetChildren()) do
		module_upvr.fadeAll(v_12, var66)
	end
end
function module_upvr.showAll(arg1) -- Line 208
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1.ClassName == "Beam" then
		arg1.Enabled = true
	end
	if arg1.ClassName == "ProximityPrompt" then
		arg1.Enabled = true
	end
	if arg1.ClassName == "Trail" then
		arg1.Enabled = true
	end
	if arg1.ClassName == "RopeConstraint" then
		arg1.Enabled = true
	end
	if arg1.ClassName == "SurfaceGui" then
		arg1.Enabled = true
	end
	if arg1.ClassName == "PointLight" then
		arg1.Enabled = true
	end
	if arg1.ClassName == "ParticleEmitter" then
		arg1.Enabled = true
	end
	if arg1.ClassName == "BillboardGui" then
		arg1.Enabled = true
	end
	if arg1.ClassName == "Texture" then
		if not arg1:GetAttribute("LastTransparency") then
			arg1:SetAttribute("LastTransparency", arg1.Transparency)
		end
		local LastTransparency_2 = arg1:GetAttribute("LastTransparency")
		if LastTransparency_2 then
			arg1.Transparency = LastTransparency_2
		else
			arg1.Transparency = 0
		end
	end
	if arg1.ClassName == "UnionOperation" or arg1.ClassName == "Part" or arg1.ClassName == "MeshPart" or arg1.ClassName == "Decal" or arg1.Name ~= "touchPart" and arg1.Name ~= "HumanoidRootPart" and arg1.Name ~= "灯光" and arg1.Name ~= "碰撞体" then
		if not arg1:GetAttribute("LastTransparency") then
			arg1:SetAttribute("LastTransparency", arg1.Transparency)
		end
		local LastTransparency = arg1:GetAttribute("LastTransparency")
		if LastTransparency then
			arg1.Transparency = LastTransparency
		else
			arg1.Transparency = 0
		end
	end
	for _, v_13 in pairs(arg1:GetChildren()) do
		module_upvr.showAll(v_13)
	end
end
function module_upvr.SetPlayerCollideID(arg1) -- Line 267
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		if arg1:IsA("BasePart") then
			arg1.CollisionGroup = "Player"
		end
		for _, v_16 in pairs(arg1:GetChildren()) do
			module_upvr.SetPlayerCollideID(v_16)
		end
	end
end
function module_upvr.SetEnemyCollideID(arg1) -- Line 280
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		if arg1:IsA("BasePart") then
			arg1.CollisionGroup = "Enemy"
		end
		for _, v_17 in pairs(arg1:GetChildren()) do
			module_upvr.SetEnemyCollideID(v_17)
		end
	end
end
function module_upvr.SetPetCollideID(arg1) -- Line 294
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CollisionGroup = "Pet"
	end
	for _, v_14 in pairs(arg1:GetChildren()) do
		module_upvr.SetPetCollideID(v_14)
	end
end
function module_upvr.SpeedDown(arg1) -- Line 304
	for _, v_15 in pairs(arg1:GetDescendants()) do
		if v_15:IsA("BasePart") then
			v_15.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v_15.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end
end
return module_upvr