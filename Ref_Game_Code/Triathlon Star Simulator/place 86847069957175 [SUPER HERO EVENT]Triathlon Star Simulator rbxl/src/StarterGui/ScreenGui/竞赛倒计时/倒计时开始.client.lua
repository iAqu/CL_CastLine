-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:27
-- Luau version 6, Types version 3
-- Time taken: 0.002508 seconds

local ServerUtil_upvr = require(game.ReplicatedStorage.ServerUtil)
local Parent_upvr = script.Parent
local __2_upvr = Parent_upvr['1']
local __4_upvr = Parent_upvr['2']
local __3_upvr = Parent_upvr['3']
local GO_upvr = Parent_upvr.GO
local function SetStart_upvr() -- Line 17, Named "SetStart"
	--[[ Upvalues[4]:
		[1]: __2_upvr (readonly)
		[2]: __4_upvr (readonly)
		[3]: __3_upvr (readonly)
		[4]: GO_upvr (readonly)
	]]
	__2_upvr.Visible = false
	__4_upvr.Visible = false
	__3_upvr.Visible = false
	GO_upvr.Visible = false
	__2_upvr.Size = UDim2.new(0, 1, 0, 1)
	__4_upvr.Size = UDim2.new(0, 1, 0, 1)
	__3_upvr.Size = UDim2.new(0, 1, 0, 1)
	GO_upvr.Size = UDim2.new(0, 1, 0, 1)
end
local udim2_upvr = UDim2.new(0, 500, 0, 500)
local function StartChange_upvr(arg1) -- Line 31, Named "StartChange"
	--[[ Upvalues[2]:
		[1]: ServerUtil_upvr (readonly)
		[2]: udim2_upvr (readonly)
	]]
	arg1.Visible = true
	local any_Create_result1_upvw = ServerUtil_upvr.TweenService:Create(arg1, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = udim2_upvr;
	})
	any_Create_result1_upvw.Completed:Connect(function() -- Line 35
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_Create_result1_upvw (read and write)
		]]
		task.delay(0.7, function() -- Line 36
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1.Visible = false
		end)
		any_Create_result1_upvw:Destroy()
		any_Create_result1_upvw = nil
	end)
	any_Create_result1_upvw:Play()
end
local function _() -- Line 46, Named "CountDown"
	--[[ Upvalues[8]:
		[1]: Parent_upvr (readonly)
		[2]: SetStart_upvr (readonly)
		[3]: ServerUtil_upvr (readonly)
		[4]: StartChange_upvr (readonly)
		[5]: __3_upvr (readonly)
		[6]: __4_upvr (readonly)
		[7]: __2_upvr (readonly)
		[8]: GO_upvr (readonly)
	]]
	Parent_upvr.Visible = true
	SetStart_upvr()
	local var13_upvw = 0
	local var14_upvw = false
	local var15_upvw = false
	local var16_upvw = false
	local var17_upvw = false
	local var18_upvw
	var18_upvw = ServerUtil_upvr.RunService.Heartbeat:Connect(function(arg1) -- Line 58
		--[[ Upvalues[12]:
			[1]: var13_upvw (read and write)
			[2]: var14_upvw (read and write)
			[3]: StartChange_upvr (copied, readonly)
			[4]: __3_upvr (copied, readonly)
			[5]: ServerUtil_upvr (copied, readonly)
			[6]: var15_upvw (read and write)
			[7]: __4_upvr (copied, readonly)
			[8]: var16_upvw (read and write)
			[9]: __2_upvr (copied, readonly)
			[10]: var17_upvw (read and write)
			[11]: GO_upvr (copied, readonly)
			[12]: var18_upvw (read and write)
		]]
		if 0 <= var13_upvw and not var14_upvw then
			var14_upvw = true
			StartChange_upvr(__3_upvr)
			ServerUtil_upvr.SoundModule:PlaySoundLocal({
				SoundName = "音效-比赛-倒计时";
			})
		end
		if 1 <= var13_upvw and not var15_upvw then
			var15_upvw = true
			StartChange_upvr(__4_upvr)
			ServerUtil_upvr.SoundModule:PlaySoundLocal({
				SoundName = "音效-比赛-倒计时";
			})
		end
		if 2 <= var13_upvw and not var16_upvw then
			var16_upvw = true
			StartChange_upvr(__2_upvr)
			ServerUtil_upvr.SoundModule:PlaySoundLocal({
				SoundName = "音效-比赛-倒计时";
			})
		end
		if 3 <= var13_upvw and not var17_upvw then
			var17_upvw = true
			StartChange_upvr(GO_upvr)
			ServerUtil_upvr.SoundModule:PlaySoundLocal({
				SoundName = "音效-比赛-倒计时go";
			})
			var18_upvw:Disconnect()
			var18_upvw = nil
		end
		var13_upvw += arg1
	end)
end
local TrainEquipment_upvr = ServerUtil_upvr.Players.LocalPlayer:WaitForChild("TrainEquipment", math.huge)
local IsInReadyArea_upvr = game.Players.LocalPlayer:WaitForChild("IsInReadyArea", math.huge)
ServerUtil_upvr.AddListen.NumValueAdd(game.Workspace:WaitForChild("比赛状态", math.huge), function(arg1) -- Line 99
	--[[ Upvalues[10]:
		[1]: ServerUtil_upvr (readonly)
		[2]: TrainEquipment_upvr (readonly)
		[3]: IsInReadyArea_upvr (readonly)
		[4]: Parent_upvr (readonly)
		[5]: SetStart_upvr (readonly)
		[6]: StartChange_upvr (readonly)
		[7]: __3_upvr (readonly)
		[8]: __4_upvr (readonly)
		[9]: __2_upvr (readonly)
		[10]: GO_upvr (readonly)
	]]
	if arg1 == ServerUtil_upvr.EnumMgr.GameState.Ready and TrainEquipment_upvr.Value <= 0 and IsInReadyArea_upvr.Value == true then
		Parent_upvr.Visible = true
		SetStart_upvr()
		local var27_upvw = 0
		local var28_upvw = false
		local var29_upvw = false
		local var30_upvw = false
		local var31_upvw = false
		local var32_upvw
		var32_upvw = ServerUtil_upvr.RunService.Heartbeat:Connect(function(arg1_2) -- Line 58
			--[[ Upvalues[12]:
				[1]: var27_upvw (read and write)
				[2]: var28_upvw (read and write)
				[3]: StartChange_upvr (copied, readonly)
				[4]: __3_upvr (copied, readonly)
				[5]: ServerUtil_upvr (copied, readonly)
				[6]: var29_upvw (read and write)
				[7]: __4_upvr (copied, readonly)
				[8]: var30_upvw (read and write)
				[9]: __2_upvr (copied, readonly)
				[10]: var31_upvw (read and write)
				[11]: GO_upvr (copied, readonly)
				[12]: var32_upvw (read and write)
			]]
			if 0 <= var27_upvw and not var28_upvw then
				var28_upvw = true
				StartChange_upvr(__3_upvr)
				ServerUtil_upvr.SoundModule:PlaySoundLocal({
					SoundName = "音效-比赛-倒计时";
				})
			end
			if 1 <= var27_upvw and not var29_upvw then
				var29_upvw = true
				StartChange_upvr(__4_upvr)
				ServerUtil_upvr.SoundModule:PlaySoundLocal({
					SoundName = "音效-比赛-倒计时";
				})
			end
			if 2 <= var27_upvw and not var30_upvw then
				var30_upvw = true
				StartChange_upvr(__2_upvr)
				ServerUtil_upvr.SoundModule:PlaySoundLocal({
					SoundName = "音效-比赛-倒计时";
				})
			end
			if 3 <= var27_upvw and not var31_upvw then
				var31_upvw = true
				StartChange_upvr(GO_upvr)
				ServerUtil_upvr.SoundModule:PlaySoundLocal({
					SoundName = "音效-比赛-倒计时go";
				})
				var32_upvw:Disconnect()
				var32_upvw = nil
			end
			var27_upvw += arg1_2
		end)
	end
end)