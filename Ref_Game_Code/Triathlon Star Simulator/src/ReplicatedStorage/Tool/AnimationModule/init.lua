-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:56
-- Luau version 6, Types version 3
-- Time taken: 0.009709 seconds

local module_upvr = {}
local Debris_upvr = game:GetService("Debris")
local CheckPlace_upvr = require(script.CheckPlace)
local InsMgr_upvr = require(game:GetService("ReplicatedStorage").Tool.InsMgr)
local tbl_upvr = {
	["胸肌展示保持"] = {18746139511, 140610924305367};
	["原始人教练鼓励"] = {110924807778179, 109361707477889};
	["蝙蝠侠教练鼓励"] = {85451703092304, 96916323475627};
	["鲨鱼教练鼓励"] = {78897379669270, 138722189496368};
	["海王教练鼓励"] = {110157036020219, 107322979606068};
	["待机"] = {18733008653, 131398984967009};
	["龙虾教练鼓励"] = {18967201457, 130839281676759};
	["星球武士教练鼓励"] = {18967216057, 132373487720041};
	["麦克教练鼓励"] = {18967222372, 103602183164694};
	["钉子教练鼓励"] = {18967228017, 78661285697763};
	["女教练鼓励"] = {18764283518, 120725845460788};
	["男教练鼓励"] = {18764275299, 111733911414584};
	["胖胖女教练鼓励"] = {18967212432, 138731793368032};
	["加速战斗奔跑"] = {110430412702742, 98470703996184};
	["加速骑行"] = {121448147231065, 132611658795836};
	["加速游泳"] = {73166328908107, 85315098807206};
	["游泳"] = {132664597877950, 84862189616779};
	["加速骑行自行车"] = {129038216849320, 128339965167700};
	["骑行自行车"] = {82306039151445, 78638205768244};
	["骑行"] = {126230278451602, 86242312298957};
	["自行车移动"] = {80197080354655, 113729561092402};
	["飞行待机"] = {18858400269, 127784835981359};
	["行走待机"] = {18858394247, 111033731757948};
	["宠物飞行"] = {18843056911, 101984351813705};
	["宠物行走"] = {18843075089, 121771869056014};
	["战斗奔跑"] = {18721735423, 76136253477833};
	["行走"] = {913402848, 85547856220792};
}
function module_upvr.KeepAnimPlaying(arg1, arg2, arg3, arg4, arg5) -- Line 133
	--[[ Upvalues[4]:
		[1]: tbl_upvr (readonly)
		[2]: CheckPlace_upvr (readonly)
		[3]: InsMgr_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	if not arg2 or arg2 == "" then
	else
		if not arg1 then
			warn("Animator不存在")
			return
		end
		if not arg1.Parent then return end
		if not arg3 then
			local const_number = 1
		end
		if not tbl_upvr[arg2] then
			warn("没有找到动画", arg2)
			return
		end
		local any_CheckPlaceID_result1_5 = CheckPlace_upvr.CheckPlaceID()
		if not any_CheckPlaceID_result1_5 then
			any_CheckPlaceID_result1_5 = 2
		end
		local var43 = tbl_upvr[arg2][any_CheckPlaceID_result1_5]
		local any_GetIns_result1_upvw_2 = InsMgr_upvr.GetIns(arg2, "Animation", arg1)
		any_GetIns_result1_upvw_2.Name = arg2
		any_GetIns_result1_upvw_2.AnimationId = "http://www.roblox.com/asset/?id="..var43
		for _, v_4 in pairs(arg1:GetPlayingAnimationTracks()) do
			if v_4.Animation.AnimationId == "http://www.roblox.com/asset/?id="..var43 or v_4.Name == arg2 then
				v_4:AdjustSpeed(const_number)
				return
			end
		end
		local any_LoadAnimation_result1_upvw = arg1:LoadAnimation(any_GetIns_result1_upvw_2)
		any_LoadAnimation_result1_upvw:AdjustSpeed(const_number)
		any_LoadAnimation_result1_upvw.Ended:Connect(function() -- Line 180
			--[[ Upvalues[3]:
				[1]: any_GetIns_result1_upvw_2 (read and write)
				[2]: Debris_upvr (copied, readonly)
				[3]: any_LoadAnimation_result1_upvw (read and write)
			]]
			if any_GetIns_result1_upvw_2 then
				Debris_upvr:AddItem(any_GetIns_result1_upvw_2, 0)
				any_GetIns_result1_upvw_2 = nil
			end
			if any_LoadAnimation_result1_upvw then
				Debris_upvr:AddItem(any_LoadAnimation_result1_upvw, 0)
				any_LoadAnimation_result1_upvw = nil
			end
		end)
		if arg4 then
			for i_5_upvr, v_5 in pairs(arg4) do
				local var54_upvw
				var54_upvw = any_LoadAnimation_result1_upvw:GetMarkerReachedSignal(v_5):Connect(function(arg1_2) -- Line 196
					--[[ Upvalues[4]:
						[1]: arg5 (readonly)
						[2]: i_5_upvr (readonly)
						[3]: any_LoadAnimation_result1_upvw (read and write)
						[4]: var54_upvw (read and write)
					]]
					if arg5[i_5_upvr] then
						arg5[i_5_upvr]()
					end
					any_LoadAnimation_result1_upvw.Ended:Connect(function() -- Line 201
						--[[ Upvalues[1]:
							[1]: var54_upvw (copied, read and write)
						]]
						if var54_upvw then
							var54_upvw:Disconnect()
							var54_upvw = nil
						end
					end)
				end)
				local var56
			end
		end
		var56:Play()
		var56:AdjustSpeed(const_number)
	end
end
function module_upvr.PreloadAnim(arg1, arg2) -- Line 216
	--[[ Upvalues[4]:
		[1]: tbl_upvr (readonly)
		[2]: CheckPlace_upvr (readonly)
		[3]: InsMgr_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	if not arg1 then
		warn("Animator不存在")
	else
		if not arg1.Parent then return end
		if not tbl_upvr[arg2] then
			warn("没有找到动画", arg2)
			return
		end
		if not CheckPlace_upvr.CheckPlaceID() then
		end
		local any_GetIns_result1_upvw_4 = InsMgr_upvr.GetIns(arg2, "Animation", arg1)
		any_GetIns_result1_upvw_4.Name = arg2
		any_GetIns_result1_upvw_4.AnimationId = "http://www.roblox.com/asset/?id="..tbl_upvr[arg2][2]
		local pcall_result1, pcall_result2 = pcall(function() -- Line 244
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: any_GetIns_result1_upvw_4 (read and write)
			]]
			return arg1:LoadAnimation(any_GetIns_result1_upvw_4)
		end)
		if pcall_result1 and pcall_result2 then
			pcall_result2:Play()
			pcall_result2:Stop()
			Debris_upvr:AddItem(pcall_result2, 0)
			Debris_upvr:AddItem(any_GetIns_result1_upvw_4, 0)
			any_GetIns_result1_upvw_4 = nil
		end
	end
end
function module_upvr.PlayAnim(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 260
	--[[ Upvalues[4]:
		[1]: tbl_upvr (readonly)
		[2]: CheckPlace_upvr (readonly)
		[3]: InsMgr_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	if not arg1 then
		warn("Animator不存在")
	else
		if not arg1.Parent then return end
		if not arg3 then
		end
		if not tbl_upvr[arg2] then
			warn("没有找到动画", arg2)
			return
		end
		local any_CheckPlaceID_result1 = CheckPlace_upvr.CheckPlaceID()
		if not any_CheckPlaceID_result1 then
			any_CheckPlaceID_result1 = 2
		end
		local var70 = tbl_upvr[arg2][any_CheckPlaceID_result1]
		local any_GetIns_result1_upvw_3 = InsMgr_upvr.GetIns(arg2, "Animation", arg1)
		any_GetIns_result1_upvw_3.Name = arg2
		any_GetIns_result1_upvw_3.AnimationId = "http://www.roblox.com/asset/?id="..var70
		for i_6, var78 in pairs(arg1:GetPlayingAnimationTracks()) do
			if var78.Animation.AnimationId == "http://www.roblox.com/asset/?id="..var70 or var78.Name == arg2 then
				var78:Stop()
			end
		end
		local pcall_result1_2, pcall_result2_2_upvw = pcall(function() -- Line 299
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: any_GetIns_result1_upvw_3 (read and write)
			]]
			return arg1:LoadAnimation(any_GetIns_result1_upvw_3)
		end)
		if pcall_result1_2 and pcall_result2_2_upvw then
			function var78() -- Line 304
				--[[ Upvalues[3]:
					[1]: any_GetIns_result1_upvw_3 (read and write)
					[2]: Debris_upvr (copied, readonly)
					[3]: pcall_result2_2_upvw (read and write)
				]]
				if any_GetIns_result1_upvw_3 then
					Debris_upvr:AddItem(any_GetIns_result1_upvw_3, 0)
					any_GetIns_result1_upvw_3 = nil
				end
				if pcall_result2_2_upvw then
					Debris_upvr:AddItem(pcall_result2_2_upvw, 0)
					pcall_result2_2_upvw = nil
				end
			end
			pcall_result2_2_upvw.Ended:Connect(var78)
			if arg4 then
				i_6 = arg4
				local pairs_result1_3, pairs_result2_6, pairs_result3_8 = pairs(i_6)
				for i_7_upvr, v_7 in pairs_result1_3, pairs_result2_6, pairs_result3_8 do
					local var83_upvw
					var83_upvw = pcall_result2_2_upvw:GetMarkerReachedSignal(v_7):Connect(function(arg1_3) -- Line 320
						--[[ Upvalues[4]:
							[1]: arg5 (readonly)
							[2]: i_7_upvr (readonly)
							[3]: pcall_result2_2_upvw (read and write)
							[4]: var83_upvw (read and write)
						]]
						if arg5[i_7_upvr] then
							arg5[i_7_upvr]()
						end
						pcall_result2_2_upvw.Ended:Connect(function() -- Line 325
							--[[ Upvalues[1]:
								[1]: var83_upvw (copied, read and write)
							]]
							if var83_upvw then
								var83_upvw:Disconnect()
								var83_upvw = nil
							end
						end)
					end)
				end
			end
			if arg6 then
				pcall_result2_2_upvw.Priority = arg6
			end
			pcall_result2_2_upvw:Play()
			pairs_result3_8 = 1
			pcall_result2_2_upvw:AdjustSpeed(pairs_result3_8)
			return pcall_result2_2_upvw.Length
		end
	end
end
function module_upvr.StopAnim(arg1, arg2) -- Line 349
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: CheckPlace_upvr (readonly)
	]]
	if not arg1 then
		warn("Animator不存在")
	else
		if not tbl_upvr[arg2] then
			warn("没有找到动画", arg2)
			return
		end
		local any_CheckPlaceID_result1_2 = CheckPlace_upvr.CheckPlaceID()
		if not any_CheckPlaceID_result1_2 then
			any_CheckPlaceID_result1_2 = 2
		end
		for _, v_8 in pairs(arg1:GetPlayingAnimationTracks()) do
			if v_8.Animation.AnimationId == "http://www.roblox.com/asset/?id="..tbl_upvr[arg2][any_CheckPlaceID_result1_2] or v_8.Name == arg2 then
				v_8:Stop()
			end
		end
	end
end
function module_upvr.StopAll(arg1) -- Line 380
	if not arg1 then
		warn("Animator不存在")
	else
		for _, v_9 in pairs(arg1:GetPlayingAnimationTracks()) do
			v_9:Stop()
		end
	end
end
function module_upvr.BindEndFunc(arg1, arg2, arg3) -- Line 393
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: CheckPlace_upvr (readonly)
	]]
	if not arg1 then
		warn("Animator不存在")
	else
		if not arg1.Parent then return end
		if not tbl_upvr[arg2] then
			warn("没有找到动画", arg2)
			return
		end
		local any_CheckPlaceID_result1_4 = CheckPlace_upvr.CheckPlaceID()
		if not any_CheckPlaceID_result1_4 then
			any_CheckPlaceID_result1_4 = 2
		end
		local var103 = tbl_upvr[arg2][any_CheckPlaceID_result1_4]
		local Animation = Instance.new("Animation")
		Animation.Name = arg2
		Animation.AnimationId = "http://www.roblox.com/asset/?id="..var103
		for _, v_10 in pairs(arg1:GetPlayingAnimationTracks()) do
			if v_10.Animation.AnimationId == "http://www.roblox.com/asset/?id="..var103 or v_10.Name == arg2 then
				if not v_10.Looped then
					v_10.Ended:Connect(function() -- Line 426
						--[[ Upvalues[1]:
							[1]: arg3 (readonly)
						]]
						if arg3 then
							arg3()
						end
					end)
				end
				return
			end
		end
	end
end
function module_upvr.IsAnimPlaying(arg1, arg2) -- Line 440
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: CheckPlace_upvr (readonly)
	]]
	if not arg1 then
		warn("Animator不存在")
		return
	end
	if not tbl_upvr[arg2] then
		warn("没有找到动画", arg2)
		return
	end
	local any_CheckPlaceID_result1_3 = CheckPlace_upvr.CheckPlaceID()
	if not any_CheckPlaceID_result1_3 then
		any_CheckPlaceID_result1_3 = 2
	end
	for _, v in pairs(arg1:GetPlayingAnimationTracks()) do
		if v.Animation.AnimationId == "http://www.roblox.com/asset/?id="..tbl_upvr[arg2][any_CheckPlaceID_result1_3] and v.IsPlaying then
			return true
		end
	end
	return false
end
function module_upvr.IsAnimsPlaying(arg1, arg2) -- Line 472
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	for _, v_2 in pairs(arg2) do
		if module_upvr.IsAnimPlaying(arg1, v_2) then
			return true
		end
	end
	return false
end
function module_upvr.StopAnimByID(arg1, arg2) -- Line 487
	if not arg1 then
		warn("Animator不存在")
	else
		for _, v_11 in pairs(arg1:GetPlayingAnimationTracks()) do
			if v_11.Animation.AnimationId == "http://www.roblox.com/asset/?id="..arg2 then
				v_11:Stop()
			end
		end
	end
end
function module_upvr.GetAnimID(arg1) -- Line 508
	--[[ Upvalues[2]:
		[1]: CheckPlace_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local var127
	if not var127 then
		var127 = 2
	end
	if tbl_upvr[arg1] then
		return tbl_upvr[arg1][var127]
	end
	warn("没有该动画", arg1)
	return nil
end
function module_upvr.GetPreloadTable() -- Line 525
	--[[ Upvalues[2]:
		[1]: CheckPlace_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local module = {}
	local var133
	if not var133 then
		var133 = 2
	end
	for _, v_3 in pairs(tbl_upvr) do
		table.insert(module, "rbxassetid://"..v_3[var133])
	end
	return module
end
local RunService_upvr = game:GetService("RunService")
function module_upvr.PlayLastingAnim(arg1, arg2, arg3) -- Line 544
	--[[ Upvalues[3]:
		[1]: InsMgr_upvr (readonly)
		[2]: RunService_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	if not arg1:FindFirstChild(arg2) then
		local any_GetIns_result1_upvw = InsMgr_upvr.GetIns(arg2, "NumberValue", arg1)
		local var140_upvw = 0
		any_GetIns_result1_upvw.Changed:Connect(function(arg1_5) -- Line 572
			--[[ Upvalues[3]:
				[1]: module_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
			]]
			if arg1_5 == 0 then
				module_upvr.StopAnim(arg1, arg2)
			end
			if 0 < arg1_5 then
				module_upvr.KeepAnimPlaying(arg1, arg2)
			end
		end)
		local any_Connect_result1_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_4) -- Line 553
			--[[ Upvalues[2]:
				[1]: var140_upvw (read and write)
				[2]: any_GetIns_result1_upvw (read and write)
			]]
			var140_upvw += arg1_4
			if 0.1 <= var140_upvw then
				var140_upvw = 0
				if any_GetIns_result1_upvw.Value < 0.1 then
					any_GetIns_result1_upvw.Value = 0
					return
				end
				if 0.1 <= any_GetIns_result1_upvw.Value then
					local var141 = any_GetIns_result1_upvw
					var141.Value -= 0.1
				end
			end
		end)
		any_GetIns_result1_upvw.Destroying:Connect(function() -- Line 583
			--[[ Upvalues[1]:
				[1]: any_Connect_result1_upvw (read and write)
			]]
			if any_Connect_result1_upvw then
				any_Connect_result1_upvw:Disconnect()
				any_Connect_result1_upvw = nil
			end
		end)
	end
	any_GetIns_result1_upvw.Value = arg3
end
return module_upvr