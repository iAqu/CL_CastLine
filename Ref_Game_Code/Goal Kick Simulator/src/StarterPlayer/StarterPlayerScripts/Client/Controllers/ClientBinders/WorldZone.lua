-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:14
-- Luau version 6, Types version 3
-- Time taken: 0.007751 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_2_upvr = {}
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local var6_upvw
Util_upvr.Thread.Every(1, function() -- Line 9
	--[[ Upvalues[4]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
		[3]: Util_upvr (readonly)
		[4]: var6_upvw (read and write)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Character = LocalPlayer_upvr.Character
	if Character then
		Character = LocalPlayer_upvr.Character.PrimaryPart
		if Character then
			Character = LocalPlayer_upvr.Character.PrimaryPart.Position
		end
	end
	if not Character then
	else
		for i in pairs(tbl_2_upvr) do
			if Util_upvr.CFrame.InsidePart(i, Character) then
				if var6_upvw == i then return end
				local var31 = i
			end
		end
		if var6_upvw and not var31 then
			local tbl_3 = {}
			i = var6_upvw.Size
			tbl_3.Size = i
			i = var6_upvw.CFrame
			tbl_3.CFrame = i
			i = true
			tbl_3.Anchored = i
			i = false
			tbl_3.CanCollide = i
			i = 0.5
			tbl_3.Transparency = i
			i = workspace
			tbl_3.Parent = i
			local any_Create_result1 = Util_upvr.Create("Part", tbl_3)
			local RaycastParams_new_result1 = RaycastParams.new()
			RaycastParams_new_result1.FilterType = Enum.RaycastFilterType.Include
			local tbl = {}
			i = any_Create_result1
			tbl[1] = i
			RaycastParams_new_result1.FilterDescendantsInstances = tbl
			RaycastParams_new_result1.IgnoreWater = true
			i = Character - var6_upvw.Position
			i = workspace:Raycast(Character, (var6_upvw.Position - Character).Unit * i.Magnitude, RaycastParams_new_result1)
			any_Create_result1:Destroy()
			if i and (i.Position - Character).Magnitude < 600 then return end
		end
		any_Create_result1 = var31
		local var36 = any_Create_result1
		if var36 then
			var36 = var31:GetAttribute("ZoneLighting")
		end
		RaycastParams_new_result1 = var31
		local var37 = RaycastParams_new_result1
		if var37 then
			i = "Soundtrack"
			var37 = var31:GetAttribute(i)
		end
		local var38_upvr = var31
		if var38_upvr then
			var38_upvr = var31:GetAttribute("GravityForce")
		end
		local Client_upvr = Util_upvr.PlayerMaids.Client
		if var38_upvr then
			Client_upvr.GravityForceAdder = Client_upvr.CharacterAdded:Connect(function(arg1) -- Line 60
				--[[ Upvalues[2]:
					[1]: var38_upvr (readonly)
					[2]: Client_upvr (readonly)
				]]
				local VectorForce_2 = Instance.new("VectorForce")
				VectorForce_2.Force = Vector3.new(0, var38_upvr, 0)
				VectorForce_2.RelativeTo = Enum.ActuatorRelativeTo.World
				VectorForce_2.ApplyAtCenterOfMass = true
				VectorForce_2.Attachment0 = arg1.PrimaryPart:WaitForChild("RootAttachment", 10)
				VectorForce_2.Parent = arg1:WaitForChild("Humanoid").RootPart
				Client_upvr.GravityForce = VectorForce_2
			end)
		else
			Client_upvr.GravityForce = nil
			Client_upvr.GravityForceAdder = nil
		end
		if var37 then
			Util_upvr.SoundtrackController:PlaySoundtrack(var37, 5)
		else
			Util_upvr.SoundtrackController:PlaySoundtrack(Util_upvr.ClientZone.CurrentZone, 5)
		end
		if not var36 then
			var6_upvw = nil
			Util_upvr.LightingController:ResumeDefault(5)
			Util_upvr.SoundtrackController:PlaySoundtrack(Util_upvr.ClientZone.CurrentZone, 5)
			return
		end
		var6_upvw = var31
		Util_upvr.LightingController:TweenLoadFromLightingName(var36, 5)
	end
end)
function module.Binder(arg1) -- Line 93
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local var47
	if arg1:GetAttribute("RequiresSkyIsland") and any_GetLink_result1_upvr.SkyIsland then
		var47 = true
	end
	if var47 or any_GetLink_result1_upvr.Zones[arg1.Name] then
		function any_new_result1_upvr.Active() -- Line 107
			--[[ Upvalues[2]:
				[1]: tbl_2_upvr (copied, readonly)
				[2]: arg1 (readonly)
			]]
			tbl_2_upvr[arg1] = nil
		end
		tbl_2_upvr[arg1] = true
	else
		any_new_result1_upvr.Active = nil
	end
	var47 = any_GetLink_result1_upvr.Zones
	any_new_result1_upvr.ZonesUpdate = var47.Changed:On(arg1.Name, function(arg1_2) -- Line 97, Named "UpdatePurchased"
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: tbl_2_upvr (copied, readonly)
		]]
		local var45
		if arg1:GetAttribute("RequiresSkyIsland") and any_GetLink_result1_upvr.SkyIsland then
			var45 = true
		end
		if var45 or arg1_2 then
			function any_new_result1_upvr.Active() -- Line 107
				--[[ Upvalues[2]:
					[1]: tbl_2_upvr (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				tbl_2_upvr[arg1] = nil
			end
			tbl_2_upvr[arg1] = true
		else
			any_new_result1_upvr.Active = nil
		end
	end)
	return any_new_result1_upvr
end
return module