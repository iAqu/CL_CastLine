-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:31
-- Luau version 6, Types version 3
-- Time taken: 0.004994 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local module = {}
local Util_upvr = require(ReplicatedStorage_upvr.Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 7
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local var8_upvw = false
	local function LaunchPlayer_upvr(arg1_2) -- Line 13, Named "LaunchPlayer"
		--[[ Upvalues[3]:
			[1]: var8_upvw (read and write)
			[2]: Util_upvr (copied, readonly)
			[3]: LocalPlayer_upvr (copied, readonly)
		]]
		if var8_upvw then
		else
			local Cannon = Util_upvr.ClientZone:GetCurrentZone().Ignore.Cannon
			if not Cannon then return end
			local Character = LocalPlayer_upvr.Character
			if Character then
				Character = LocalPlayer_upvr.Character.PrimaryPart
			end
			if not Character then return end
			local Position_upvr = Cannon.Position
			var8_upvw = true
			Util_upvr.Windows:SwitchWindow()
			local Magnitude_upvr = (arg1_2 - Position_upvr).Magnitude
			LocalPlayer_upvr.Character.Humanoid.Sit = true
			LocalPlayer_upvr.Character:PivotTo(CFrame.new(Cannon.Position, arg1_2))
			Character.Anchored = true
			Util_upvr.Sounds:Play("CannonIgnite")
			task.wait(1)
			Util_upvr.Sounds:Play("CannonShot")
			Util_upvr.Thread.LoopFor(math.min(Magnitude_upvr / 500, 2), function(arg1_3) -- Line 33
				--[[ Upvalues[4]:
					[1]: Magnitude_upvr (readonly)
					[2]: Position_upvr (readonly)
					[3]: arg1_2 (readonly)
					[4]: LocalPlayer_upvr (copied, readonly)
				]]
				LocalPlayer_upvr.Character:PivotTo(CFrame.new(Position_upvr:Lerp(arg1_2, arg1_3) + Vector3.new(0, (math.sin(arg1_3 * math.pi)) * (Magnitude_upvr / 20), 0), Position_upvr:Lerp(arg1_2, arg1_3 + 0.05) + Vector3.new(0, (math.sin((arg1_3 + 5) * math.pi)) * (Magnitude_upvr / 20), 0)))
			end).Ended:Wait()
			Character.Anchored = false
			var8_upvw = false
			LocalPlayer_upvr.Character.Humanoid.Sit = false
		end
	end
	local function UpdateStream(arg1_4) -- Line 46
		--[[ Upvalues[6]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: ReplicatedStorage_upvr (copied, readonly)
			[4]: arg1 (readonly)
			[5]: any_GetLink_result1_upvr (readonly)
			[6]: LaunchPlayer_upvr (readonly)
		]]
		local any_new_result1_upvr_2 = Util_upvr.Maid.new()
		any_new_result1_upvr.CurrentStream = any_new_result1_upvr_2
		local any_Sync_result1 = Util_upvr.Streamer:Sync(ReplicatedStorage_upvr.LaunchTargets, arg1_4)
		any_new_result1_upvr_2:GiveTask(any_Sync_result1)
		any_new_result1_upvr_2:GiveTask(any_Sync_result1.Loaded:Connect(function(arg1_5) -- Line 52
			--[[ Upvalues[5]:
				[1]: Util_upvr (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: any_GetLink_result1_upvr (copied, readonly)
				[4]: LaunchPlayer_upvr (copied, readonly)
				[5]: any_new_result1_upvr_2 (readonly)
			]]
			local function UpdateZone(arg1_6) -- Line 53
				--[[ Upvalues[5]:
					[1]: Util_upvr (copied, readonly)
					[2]: arg1 (copied, readonly)
					[3]: any_GetLink_result1_upvr (copied, readonly)
					[4]: LaunchPlayer_upvr (copied, readonly)
					[5]: any_new_result1_upvr_2 (copied, readonly)
				]]
				-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
				local any_GetAsset_result1 = Util_upvr.Assets:GetAsset("ZonesData", arg1_6.Name)
				local var22
				local function INLINED() -- Internal function, doesn't exist in bytecode
					var22 = "Order"
					return any_GetAsset_result1:GetAttribute(var22)
				end
				if not any_GetAsset_result1 or not INLINED() then
					local var23 = 0
				end
				var22 = arg1.Content.Assets
				local clone = var22.TeleportFrame:Clone()
				if any_GetLink_result1_upvr.Zones[arg1_6.Name] then
					var22 = true
				else
					var22 = false
				end
				clone.Visible = var22
				var22 = clone.Title
				var22.Text = '['..var23.."] "..arg1_6.Name
				clone.LayoutOrder = var23
				var22 = arg1.Content
				clone.Parent = var22
				var22 = clone.MouseButton1Click
				var22 = var22:Connect
				var22(function() -- Line 62
					--[[ Upvalues[2]:
						[1]: LaunchPlayer_upvr (copied, readonly)
						[2]: arg1_6 (readonly)
					]]
					LaunchPlayer_upvr(arg1_6:GetPivot().Position)
				end)
				var22 = any_new_result1_upvr_2
				var22[arg1_6.Name] = clone
			end
			for _, v in pairs(arg1_5:GetChildren()) do
				UpdateZone(v)
			end
			any_new_result1_upvr_2.ContentAdded = arg1_5.ChildAdded:Connect(UpdateZone)
			any_new_result1_upvr_2.ContentRemoved = arg1_5.ChildRemoved:Connect(function(arg1_7) -- Line 71
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr_2 (copied, readonly)
				]]
				any_new_result1_upvr_2[arg1_7.Name] = nil
			end)
			any_new_result1_upvr_2.ZoneChanged = any_GetLink_result1_upvr.Zones.Changed:Connect(function(arg1_8, arg2) -- Line 74
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr_2 (copied, readonly)
				]]
				local var31 = any_new_result1_upvr_2[arg1_8]
				if var31 then
					var31.Visible = arg2 or false
				end
			end)
		end))
	end
	any_new_result1_upvr.ClientZoneChanged = Util_upvr.ClientZone.ZoneChanged:Connect(UpdateStream)
	UpdateStream(Util_upvr.ClientZone.CurrentZone)
	local any_Sync_result1_2 = Util_upvr.Streamer:Sync(ReplicatedStorage_upvr.LaunchTargets, "World1", "Sky Island")
	any_new_result1_upvr:GiveTask(any_Sync_result1_2)
	any_new_result1_upvr:GiveTask(any_Sync_result1_2.Loaded:Connect(function(arg1_9) -- Line 88
		--[[ Upvalues[6]:
			[1]: any_new_result1_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: any_GetLink_result1_upvr (readonly)
			[4]: Util_upvr (copied, readonly)
			[5]: LaunchPlayer_upvr (readonly)
			[6]: LocalPlayer_upvr (copied, readonly)
		]]
		local Position_upvw = arg1_9:GetPivot().Position
		any_new_result1_upvr.OnVIPClick = arg1.Content.SkyIsland.MouseButton1Click:Connect(function() -- Line 90
			--[[ Upvalues[5]:
				[1]: any_GetLink_result1_upvr (copied, readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: LaunchPlayer_upvr (copied, readonly)
				[4]: Position_upvw (read and write)
				[5]: LocalPlayer_upvr (copied, readonly)
			]]
			if any_GetLink_result1_upvr.SkyIsland then
				if Util_upvr.ClientZone:GetCurrentZone().Name ~= "World1" then
					Util_upvr.Windows:PromptNotification({
						Sound = "Error";
						Text = "Only available in World 1!";
					})
				else
					LaunchPlayer_upvr(Position_upvw)
				end
			end
			Util_upvr.MarketplaceService:PromptGamePassPurchase(LocalPlayer_upvr, 41830680)
			Util_upvr.Sounds:Play("Pop")
			Util_upvr.Windows.State:AddState(6, false, function() -- Line 104
				--[[ Upvalues[1]:
					[1]: Util_upvr (copied, readonly)
				]]
				Util_upvr.Loader:SetLoading()
				return function() -- Line 106
					--[[ Upvalues[1]:
						[1]: Util_upvr (copied, readonly)
					]]
					Util_upvr.Loader:DisableLoading()
				end
			end)
		end)
	end))
	return any_new_result1_upvr
end
return module