-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:16
-- Luau version 6, Types version 3
-- Time taken: 0.013978 seconds

local module_upvr = {}
local EnumMgr_upvr = require(game.ReplicatedStorage.Tool.EnumMgr)
function module_upvr.SetNPCHumanType(arg1) -- Line 8
	--[[ Upvalues[1]:
		[1]: EnumMgr_upvr (readonly)
	]]
	arg1:SetAttribute("HumanType", EnumMgr_upvr.HumanType.NPC)
end
local function _(arg1) -- Line 14, Named "setLastTransparency"
	if not arg1:GetAttribute("LastTransparency") then
		arg1:SetAttribute("LastTransparency", arg1.Transparency)
	end
end
function module_upvr.CloseShade(arg1) -- Line 21
	if not arg1 then
	else
		for _, v_36 in pairs(arg1:GetDescendants()) do
			if v_36:IsA("BasePart") then
				v_36.CastShadow = false
			end
		end
	end
end
function module_upvr.DisableTrail(arg1) -- Line 35
	if not arg1 then
	else
		for _, v_37 in pairs(arg1:GetDescendants()) do
			if v_37:IsA("Trail") then
				v_37.Enabled = false
			end
		end
	end
end
function module_upvr.DisableProximityPrompt(arg1) -- Line 49
	if not arg1 then
	else
		for _, v_38 in pairs(arg1:GetDescendants()) do
			if v_38:IsA("ProximityPrompt") then
				v_38.Enabled = false
			end
		end
	end
end
function module_upvr.DisableParticle(arg1) -- Line 63
	if not arg1 then
	else
		for _, v_39 in pairs(arg1:GetDescendants()) do
			if v_39:IsA("ParticleEmitter") then
				v_39.Enabled = false
			end
		end
	end
end
function module_upvr.MasslessAll(arg1) -- Line 78
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.Massless = true
	end
	for _, v in pairs(arg1:GetChildren()) do
		module_upvr.MasslessAll(v)
	end
end
function module_upvr.UnQueryAll(arg1) -- Line 87
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
function module_upvr.UnAnchoredAll(arg1) -- Line 96
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.Anchored = false
	end
	for _, v_3 in pairs(arg1:GetChildren()) do
		module_upvr.UnAnchoredAll(v_3)
	end
end
function module_upvr.AnchoredAll(arg1) -- Line 106
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.Anchored = true
	end
	for _, v_4 in pairs(arg1:GetChildren()) do
		module_upvr.AnchoredAll(v_4)
	end
end
function module_upvr.SetStandinTransparency(arg1) -- Line 116
	for _, v_5 in pairs({"LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm", "UpperTorso", "Head"}) do
		local SOME = arg1:FindFirstChild(v_5)
		if SOME and SOME:IsA("BasePart") then
			SOME.Transparency = 1 - (1 - SOME.Transparency) * 1
		end
	end
	for _, v_6 in pairs({"LeftUpperLeg", "LowerTorso", "RightUpperLeg"}) do
		local SOME_2 = arg1:FindFirstChild(v_6)
		if SOME_2 and SOME_2:IsA("BasePart") then
			SOME_2.Transparency = 1 - (1 - SOME_2.Transparency) * 0.6
		end
	end
	for _, v_7 in pairs({"LeftFoot", "LeftLowerLeg", "RightFoot", "RightLowerLeg"}) do
		local SOME_3 = arg1:FindFirstChild(v_7)
		if SOME_3 and SOME_3:IsA("BasePart") then
			SOME_3.Transparency = 1 - (1 - SOME_3.Transparency) * 0.3
		end
	end
	for _, v_8 in pairs(arg1:GetChildren()) do
		if v_8:IsA("Accessory") then
			for _, v_9 in pairs(v_8:GetChildren()) do
				if not v_9:IsA("BasePart") then
				end
			end
		end
	end
end
function module_upvr.SetTransparency(arg1, arg2) -- Line 181
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg2 then
		local var78 = 100
	end
	if arg1:IsA("BasePart") then
		arg1.Transparency = 1 - (1 - arg1.Transparency) * (var78 / 100)
	end
	for _, v_10 in pairs(arg1:GetChildren()) do
		module_upvr.SetTransparency(v_10, var78)
	end
end
function module_upvr.UnTransparencyAll(arg1) -- Line 196
	if arg1:IsA("BasePart") then
		arg1.Transparency = 1
	end
	for _, v_11 in pairs(arg1:GetDescendants()) do
		if v_11:IsA("BasePart") then
			v_11.Transparency = 1
		end
	end
end
function module_upvr.TransparencyAll(arg1) -- Line 212
	if arg1:IsA("BasePart") then
		arg1.Transparency = 0
	end
	for _, v_12 in pairs(arg1:GetDescendants()) do
		if v_12:IsA("BasePart") then
			v_12.Transparency = 0
		end
	end
end
function module_upvr.SpeedDown(arg1) -- Line 228
	for _, v_13 in pairs(arg1:GetDescendants()) do
		if v_13:IsA("BasePart") then
			v_13.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v_13.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end
end
function module_upvr.SpeedDownY(arg1) -- Line 239
	for _, v_14 in pairs(arg1:GetDescendants()) do
		if v_14:IsA("BasePart") then
			v_14.AssemblyLinearVelocity = Vector3.new(0, v_14.AssemblyLinearVelocity.Y, 0)
			v_14.AssemblyAngularVelocity = Vector3.new(0, v_14.AssemblyAngularVelocity.Y, 0)
		end
	end
end
function module_upvr.SpeedDownY2(arg1) -- Line 251
	for _, v_15 in pairs(arg1:GetDescendants()) do
		if v_15:IsA("BasePart") then
			if v_15.AssemblyLinearVelocity.Y < 0 then
				v_15.AssemblyLinearVelocity = Vector3.new(0, -v_15.AssemblyLinearVelocity.Y, 0)
			else
				v_15.AssemblyLinearVelocity = Vector3.new(0, v_15.AssemblyLinearVelocity.Y, 0)
			end
			v_15.AssemblyAngularVelocity = Vector3.new(0, v_15.AssemblyAngularVelocity.Y, 0)
		end
	end
end
function module_upvr.UnTouchAll(arg1) -- Line 268
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CanTouch = false
	end
	for _, v_16 in pairs(arg1:GetChildren()) do
		module_upvr.UnTouchAll(v_16)
	end
end
function module_upvr.UnCollideAll(arg1) -- Line 278
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CanCollide = false
		arg1.CanQuery = false
	end
	for _, v_17 in pairs(arg1:GetChildren()) do
		module_upvr.UnCollideAll(v_17)
	end
end
function module_upvr.QueryAll(arg1) -- Line 289
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CanQuery = true
	end
	for _, v_18 in pairs(arg1:GetChildren()) do
		module_upvr.QueryAll(v_18)
	end
end
function module_upvr.QueryChildren(arg1) -- Line 299
	if arg1:IsA("BasePart") then
		arg1.CanQuery = true
	end
	for _, v_19 in pairs(arg1:GetChildren()) do
		if v_19:IsA("BasePart") then
			v_19.CanQuery = true
		end
	end
end
function module_upvr.CollideAll(arg1) -- Line 311
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CanCollide = true
	end
	for _, v_20 in pairs(arg1:GetChildren()) do
		module_upvr.CollideAll(v_20)
	end
end
local TweenService_upvr = game:GetService("TweenService")
function module_upvr.fadeAllTween(arg1, arg2) -- Line 321
	--[[ Upvalues[2]:
		[1]: TweenService_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == nil then
		local var137 = 1
	end
	if arg1.ClassName == "Trail" then
		arg1.Enabled = false
	end
	if arg1.ClassName == "Texture" then
		if not arg1:GetAttribute("LastTransparency") then
			arg1:SetAttribute("LastTransparency", arg1.Transparency)
		end
		arg1.Transparency = var137
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
			Transparency = var137;
		}):Play()
	end
	for _, v_21 in pairs(arg1:GetChildren()) do
		module_upvr.fadeAllTween(v_21, var137)
	end
end
function module_upvr.fadeAll(arg1, arg2) -- Line 360
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == nil then
		local var146 = 1
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
		arg1.Transparency = var146
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
		arg1.Transparency = var146
	end
	for _, v_22 in pairs(arg1:GetChildren()) do
		module_upvr.fadeAll(v_22, var146)
	end
end
function module_upvr.showAll(arg1) -- Line 406
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
	for _, v_23 in pairs(arg1:GetChildren()) do
		module_upvr.showAll(v_23)
	end
end
function module_upvr.SetColliderFalse(arg1) -- Line 463
	for _, v_24 in pairs(arg1:GetDescendants()) do
		if v_24:IsA("BasePart") then
			v_24:SetAttribute("CanCollide", v_24.CanCollide)
			v_24:SetAttribute("CanQuery", v_24.CanQuery)
			v_24:SetAttribute("CanTouch", v_24.CanTouch)
			v_24.CanCollide = false
			v_24.CanTouch = false
			v_24.CanQuery = false
		end
	end
end
function module_upvr.SetColliderTrue(arg1) -- Line 481
	for _, v_25 in pairs(arg1:GetDescendants()) do
		if v_25:IsA("BasePart") then
			v_25.CanCollide = v_25:GetAttribute("CanCollide")
			v_25.CanTouch = v_25:GetAttribute("CanTouch")
			v_25.CanQuery = v_25:GetAttribute("CanQuery")
		end
	end
end
local PhysicalProperties_new_result1_upvr = PhysicalProperties.new(0, 0.3, 0, 1, 1)
function module_upvr.SetPetMass(arg1) -- Line 503
	--[[ Upvalues[2]:
		[1]: PhysicalProperties_new_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CustomPhysicalProperties = PhysicalProperties_new_result1_upvr
		arg1.CanCollide = false
		arg1.CanTouch = false
		arg1.Massless = true
	end
	for _, v_26 in pairs(arg1:GetChildren()) do
		module_upvr.SetPetMass(v_26)
	end
end
function module_upvr.AddItemType(arg1, arg2) -- Line 515
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	arg1:SetAttribute("type", arg2)
	for _, v_27 in pairs(arg1:GetChildren()) do
		module_upvr.AddItemType(v_27, arg2)
	end
end
function module_upvr.SetOnlyID(arg1, arg2) -- Line 522
	arg1:SetAttribute("onlyID", arg2)
end
function module_upvr.GetOnlyID(arg1) -- Line 525
	return arg1:GetAttribute("onlyID")
end
function module_upvr.AddOwnerID(arg1, arg2) -- Line 529
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	arg1:SetAttribute("OwnerID", arg2)
	for _, v_28 in pairs(arg1:GetChildren()) do
		module_upvr.AddOwnerID(v_28, arg2)
	end
end
function module_upvr.SetPlayerCollideID(arg1) -- Line 540
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		if arg1:IsA("BasePart") then
			arg1.CollisionGroup = "Player"
		end
		for _, v_40 in pairs(arg1:GetChildren()) do
			module_upvr.SetPlayerCollideID(v_40)
		end
	end
end
function module_upvr.SetRobotCollideID(arg1) -- Line 553
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		if arg1:IsA("BasePart") then
			arg1.CollisionGroup = "Robot"
		end
		for _, v_41 in pairs(arg1:GetChildren()) do
			module_upvr.SetRobotCollideID(v_41)
		end
	end
end
function module_upvr.SetEnemyCollideID(arg1) -- Line 566
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CollisionGroup = "Enemy"
	end
	for _, v_29 in pairs(arg1:GetChildren()) do
		module_upvr.SetEnemyCollideID(v_29)
	end
end
function module_upvr.SetPetCollideID(arg1) -- Line 575
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CollisionGroup = "Pet"
	end
	for _, v_30 in pairs(arg1:GetChildren()) do
		module_upvr.SetPetCollideID(v_30)
	end
end
function module_upvr.SetDropCollideID(arg1) -- Line 584
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CollisionGroup = "Drop"
	end
	for _, v_31 in pairs(arg1:GetChildren()) do
		module_upvr.SetDropCollideID(v_31)
	end
end
function module_upvr.SetCollideIDDefault(arg1) -- Line 593
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		if arg1:IsA("BasePart") then
			arg1.CollisionGroup = "Default"
		end
		for _, v_42 in pairs(arg1:GetChildren()) do
			module_upvr.SetCollideIDDefault(v_42)
		end
	end
end
function module_upvr.SetCollideBrokenItem(arg1) -- Line 606
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CollisionGroup = "BrokenItem"
	end
	for _, v_32 in pairs(arg1:GetChildren()) do
		module_upvr.SetCollideBrokenItem(v_32)
	end
end
function module_upvr.SetHitboxCollideGroup(arg1) -- Line 615
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.CollisionGroup = "PlayerHitBox"
	end
	for _, v_33 in pairs(arg1:GetChildren()) do
		module_upvr.SetHitboxCollideGroup(v_33)
	end
end
function module_upvr.fastMode(arg1) -- Line 624
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1.Name == "水" then
	else
		if arg1:IsA("BasePart") then
			arg1.Material = Enum.Material.Plastic
			if arg1.MaterialVariant == "Y2K grass" then
				arg1.Color = Color3.new(0, 0.443137, 0)
				arg1.MaterialVariant = ""
			end
		end
		for _, v_43 in pairs(arg1:GetChildren()) do
			module_upvr.fastMode(v_43)
		end
	end
end
local tbl_upvr = {"LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg", "LowerTorso", "RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg", "UpperTorso", "Head"}
function module_upvr.ShadowHuman(arg1) -- Line 650
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	if arg1:IsA("BasePart") then
		arg1.Color = Color3.new(0, 0, 0)
	end
	if arg1:IsA("Pants") then
		arg1.Color3 = Color3.new(0, 0, 0)
	end
	if arg1:IsA("Shirt") then
		arg1.Color3 = Color3.new(0, 0, 0)
	end
	if arg1:IsA("MeshPart") and arg1.Transparency == 0 then
		arg1.TextureID = ""
	end
	for _, v_34 in pairs(arg1:GetChildren()) do
		module_upvr.ShadowHuman(v_34)
	end
	if arg1:FindFirstChildOfClass("Humanoid") then
		for _, v_35 in pairs(tbl_upvr) do
			local SOME_4 = arg1:FindFirstChild(v_35)
			if SOME_4 and SOME_4:IsA("BasePart") then
				SOME_4.Color = Color3.new(0.670588, 0.498039, 0.972549)
			end
		end
	end
end
return module_upvr