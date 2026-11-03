-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:54
-- Luau version 6, Types version 3
-- Time taken: 0.005022 seconds

local module_upvr = {}
local SoundService_upvr = game:GetService("SoundService")
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local tbl_upvr = {}
local var5_upvw
function module_upvr.PlaySoundtrack(arg1, arg2, arg3) -- Line 10
	--[[ Upvalues[5]:
		[1]: SoundService_upvr (readonly)
		[2]: var5_upvw (read and write)
		[3]: tbl_upvr (readonly)
		[4]: module_upvr (readonly)
		[5]: Util_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 70 start (CF ANALYSIS FAILED)
	local SOME = SoundService_upvr.Soundtracks:FindFirstChild(arg2)
	if not SOME then
		SOME = SoundService_upvr.Soundtracks.Default
	end
	if SOME == var5_upvw then return end
	var5_upvw = SOME
	for _, v in pairs(tbl_upvr) do
		if v.Active == 1 then
			module_upvr:StopSoundtrack(v.Name, arg3)
		end
	end
	local var24 = tbl_upvr[arg2]
	if var24 then
		var24.FadingVolume = nil
		return
	end
	local tbl_upvr_2 = {}
	local var26
	if SOME:IsA("Sound") then
		tbl_upvr_2[SOME] = 1
		local tbl_upvr_3 = {}
		var26 = pairs(tbl_upvr_2)
		local pairs_result1_3_upvw, pairs_result2_3, pairs_result3_6 = pairs(tbl_upvr_2)
		for var33 in pairs_result1_3_upvw, pairs_result2_3, pairs_result3_6 do
			local Volume = var33:GetAttribute("Volume")
			if not Volume then
				Volume = var33.Volume
				var33:SetAttribute("Volume", Volume)
			end
			tbl_upvr_3[var33] = Volume
		end
		pairs_result1_3_upvw = Util_upvr.Maid.new()
		local var32_upvw = pairs_result1_3_upvw
		var32_upvw.Name = arg2
		pairs_result1_3_upvw = 1
		var32_upvw.Active = pairs_result1_3_upvw
		var32_upvw.Sounds = tbl_upvr_2
		pairs_result1_3_upvw = 0
		if arg3 then
			var33 = Util_upvr
			function var33(arg1_2) -- Line 65
				--[[ Upvalues[1]:
					[1]: tbl_upvr_3 (readonly)
				]]
				for i_3, v_2 in pairs(tbl_upvr_3) do
					i_3.Volume = v_2 * arg1_2
				end
			end
			var32_upvw.FadingVolume = var33.Thread.LoopFor(arg3, var33)
		end
		for i_4, v_3 in pairs(tbl_upvr_2) do
			if v_3 == 2 then
				i_4:Play()
				pairs_result1_3_upvw += 1
				var32_upvw:GiveTask(i_4.Ended:Connect(function() -- Line 77
					--[[ Upvalues[2]:
						[1]: pairs_result1_3_upvw (read and write)
						[2]: var32_upvw (read and write)
					]]
					pairs_result1_3_upvw -= 1
					if pairs_result1_3_upvw == 0 and var32_upvw.AwaitingFinished then
						var32_upvw.AwaitingFinished:Fire()
					end
				end))
			end
		end
		if 0 < pairs_result1_3_upvw then
			local function var43() -- Line 86
				--[[ Upvalues[1]:
					[1]: tbl_upvr_2 (readonly)
				]]
				for i_5, v_4 in pairs(tbl_upvr_2) do
					if v_4 == 1 then
						i_5:Play()
					end
				end
			end
			var32_upvw.AwaitingFinished = Util_upvr.Signal.new():Connect(var43)
			-- KONSTANTWARNING: GOTO [178] #130
		end
		-- KONSTANTWARNING: GOTO [168] #123
	end
	-- KONSTANTERROR: [0] 1. Error Block 70 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [56] 43. Error Block 55 start (CF ANALYSIS FAILED)
	for _, _ in tbl_upvr_3, pairs_result1_3_upvw, Util_upvr.Signal.new():Connect(var43) do
		if i_4 then
			if v_3 == "Intro" then
			else
			end
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	end
	-- KONSTANTERROR: [56] 43. Error Block 55 end (CF ANALYSIS FAILED)
end
function module_upvr.StopSoundtrack(arg1, arg2, arg3) -- Line 101
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: Util_upvr (readonly)
	]]
	local var53_upvr = tbl_upvr[arg2]
	if var53_upvr then
		var53_upvr.Active = 0
		if arg3 then
			for i_7 in pairs(var53_upvr.Sounds) do
				({})[i_7] = i_7.Volume
				local var58_upvr
			end
			var53_upvr.FadingVolume = Util_upvr.Thread.LoopFor(arg3, function(arg1_3) -- Line 111
				--[[ Upvalues[1]:
					[1]: var58_upvr (readonly)
				]]
				for i_8, v_6 in pairs(var58_upvr) do
					i_8.Volume = v_6 * (1 - arg1_3)
				end
			end)
			var53_upvr.SoundtrackEnded = var53_upvr.FadingVolume.Ended:Connect(function(arg1_4) -- Line 117
				--[[ Upvalues[6]:
					[1]: tbl_upvr (copied, readonly)
					[2]: arg2 (readonly)
					[3]: var53_upvr (readonly)
					[4]: var58_upvr (readonly)
					[5]: Util_upvr (copied, readonly)
					[6]: arg3 (readonly)
				]]
				if arg1_4 then
					tbl_upvr[arg2] = nil
					var53_upvr:Destroy()
				elseif var53_upvr.Active then
					var53_upvr.Active = 1
					for i_10 in pairs(var53_upvr.Sounds) do
						local Volume_3 = i_10:GetAttribute("Volume")
						if not Volume_3 then
							Volume_3 = var58_upvr[i_10]
						end
						var58_upvr[i_10] = Volume_3
					end
					var53_upvr.FadingVolume = Util_upvr.Thread.LoopFor(arg3, function(arg1_5) -- Line 126
						--[[ Upvalues[1]:
							[1]: var58_upvr (copied, readonly)
						]]
						for i_11, v_7 in pairs(var58_upvr) do
							i_11.Volume = v_7 * arg1_5
						end
					end)
				end
			end)
			return
		end
		var58_upvr = pairs(var53_upvr.Sounds)
		local pairs_result1_8, pairs_result2_2, pairs_result3_2 = pairs(var53_upvr.Sounds)
		for i_9 in pairs_result1_8, pairs_result2_2, pairs_result3_2 do
			i_9:Stop()
		end
		pairs_result1_8 = tbl_upvr
		pairs_result1_8[arg2] = nil
		pairs_result1_8 = var53_upvr:Destroy
		pairs_result1_8()
	end
end
local any_new_result1_upvr = Util_upvr.Maid.new()
function module_upvr.SetVolume(arg1, arg2, arg3) -- Line 143
	--[[ Upvalues[3]:
		[1]: SoundService_upvr (readonly)
		[2]: any_new_result1_upvr (readonly)
		[3]: Util_upvr (readonly)
	]]
	if arg3 then
		local Volume_2_upvr = SoundService_upvr.Soundtracks.Volume
		local var84_upvr = arg2 - Volume_2_upvr
		any_new_result1_upvr.ChangingSoundtrackVolume = Util_upvr.Thread.LoopFor(arg3, function(arg1_6) -- Line 147
			--[[ Upvalues[3]:
				[1]: SoundService_upvr (copied, readonly)
				[2]: Volume_2_upvr (readonly)
				[3]: var84_upvr (readonly)
			]]
			SoundService_upvr.Soundtracks.Volume = Volume_2_upvr + var84_upvr * arg1_6
		end)
	else
		var84_upvr = SoundService_upvr
		Volume_2_upvr = var84_upvr.Soundtracks
		Volume_2_upvr.Volume = arg2
	end
end
Util_upvr.SoundtrackController = module_upvr
return module_upvr