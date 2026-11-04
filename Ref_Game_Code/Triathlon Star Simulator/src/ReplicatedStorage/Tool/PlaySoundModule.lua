-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:48
-- Luau version 6, Types version 3
-- Time taken: 0.008331 seconds

local module = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local TweenService_upvr = game:GetService("TweenService")
local Debris_upvr = game:GetService("Debris")
local tbl_2_upvr = {}
local function _(arg1) -- Line 14, Named "AddNowPlayingSoundNum"
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	if not tbl_2_upvr[arg1] then
		tbl_2_upvr[arg1] = 0
	end
	local var6 = tbl_2_upvr
	var6[arg1] += 1
end
local function _(arg1) -- Line 21, Named "DeleteNowPlayingSoundNum"
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	if tbl_2_upvr[arg1] then
		local var7 = tbl_2_upvr
		var7[arg1] -= 1
	end
end
local function SoundStop_upvr(arg1, arg2, arg3) -- Line 29, Named "SoundStop"
	--[[ Upvalues[1]:
		[1]: TweenService_upvr (readonly)
	]]
	if arg1 then
		if not arg2 then
			arg1:Stop()
			local var8
		end
		if arg2 then
			if not var8 then
				var8 = 0.5
			end
			local any_Create_result1_upvw_3 = TweenService_upvr:Create(arg1, TweenInfo.new(var8), {
				Volume = 0;
			})
			local Volume_upvr_2 = arg1.Volume
			any_Create_result1_upvw_3.Completed:Connect(function() -- Line 45
				--[[ Upvalues[3]:
					[1]: arg1 (readonly)
					[2]: Volume_upvr_2 (readonly)
					[3]: any_Create_result1_upvw_3 (read and write)
				]]
				arg1:Stop()
				arg1.Volume = Volume_upvr_2
				any_Create_result1_upvw_3:Destroy()
				any_Create_result1_upvw_3 = nil
			end)
			any_Create_result1_upvw_3:Play()
		end
	end
end
local function _(arg1) -- Line 60, Named "GetNowSoundPlayingNum"
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
	]]
	local var13 = 0
	if tbl_2_upvr[arg1] then
		var13 = tbl_2_upvr[arg1]
	end
	return var13
end
local function _(arg1) -- Line 75, Named "GetSoundGroup"
	local SOME_5 = workspace["音效组"]:FindFirstChild(arg1)
	if SOME_5 and SOME_5:IsA("SoundGroup") then
		return SOME_5
	end
	return nil
end
local function _(arg1) -- Line 86, Named "GetSoundGroupFolder"
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	for _, v in pairs(ReplicatedStorage_upvr["音频"]:GetChildren()) do
		if v.Name == arg1 then
			return v
		end
	end
end
local function GetSoundByName_upvr(arg1) -- Line 100, Named "GetSoundByName"
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	for _, v_2 in pairs(ReplicatedStorage_upvr["音频"]:GetDescendants()) do
		if v_2.Name == arg1 and v_2:IsA("Sound") then
			return v_2
		end
		if v_2.Name == arg1 and v_2:IsA("Folder") then
			return v_2
		end
	end
	return nil
end
local function stopThisSound_upvr(arg1, arg2, arg3) -- Line 121, Named "stopThisSound"
	--[[ Upvalues[1]:
		[1]: SoundStop_upvr (readonly)
	]]
	if arg1 then
		if arg1:IsA("Sound") and arg1.IsPlaying then
			SoundStop_upvr(arg1, arg2, arg3)
		end
		if arg1:IsA("Folder") then
			for _, v_3 in pairs(arg1:GetChildren()) do
				if v_3:IsA("Sound") and v_3.IsPlaying then
					SoundStop_upvr(v_3, arg2, arg3)
				end
			end
		end
		if arg1:IsA("Part") then
			for _, v_4 in pairs(arg1:GetChildren()) do
				if v_4:IsA("Sound") and v_4.IsPlaying then
					SoundStop_upvr(v_4, arg2, arg3)
				end
			end
		end
	end
end
local function PlaySound2D_upvr(arg1, arg2) -- Line 170, Named "PlaySound2D"
	--[[ Upvalues[3]:
		[1]: TweenService_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	local clone_upvr = arg1:Clone()
	clone_upvr.Name = arg1.Name.."_NewCreate"
	clone_upvr.Parent = arg1.Parent
	if arg2 and 0 < arg2 then
		clone_upvr.Volume = 0
		local any_Create_result1_upvw_5 = TweenService_upvr:Create(clone_upvr, TweenInfo.new(arg2), {
			Volume = clone_upvr.Volume;
		})
		any_Create_result1_upvw_5.Completed:Connect(function() -- Line 182
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvw_5 (read and write)
			]]
			any_Create_result1_upvw_5:Pause()
			any_Create_result1_upvw_5:Destroy()
			any_Create_result1_upvw_5 = nil
		end)
		any_Create_result1_upvw_5:Play()
	end
	clone_upvr:Play()
	local Name_6 = arg1.Name
	if not tbl_2_upvr[Name_6] then
		tbl_2_upvr[Name_6] = 0
	end
	local var40 = tbl_2_upvr
	var40[Name_6] += 1
	if 0 < clone_upvr.TimeLength then
		task.delay(clone_upvr.TimeLength, function() -- Line 195
			--[[ Upvalues[4]:
				[1]: arg1 (readonly)
				[2]: tbl_2_upvr (copied, readonly)
				[3]: Debris_upvr (copied, readonly)
				[4]: clone_upvr (readonly)
			]]
			local Name_5 = arg1.Name
			if tbl_2_upvr[Name_5] then
				local var43 = tbl_2_upvr
				var43[Name_5] -= 1
			end
			Debris_upvr:AddItem(clone_upvr, 0)
		end)
	else
		Debris_upvr:AddItem(clone_upvr, 0)
	end
end
local function PlaySoundFixed3D_upvr(arg1, arg2, arg3) -- Line 205, Named "PlaySoundFixed3D"
	--[[ Upvalues[3]:
		[1]: TweenService_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	local clone_upvr_3 = arg1:Clone()
	local Part_upvr = Instance.new("Part", workspace)
	Part_upvr.Name = clone_upvr_3.Name
	Part_upvr.Position = arg2
	Part_upvr.Transparency = 1
	Part_upvr.CanCollide = false
	Part_upvr.CanQuery = false
	Part_upvr.CanQuery = false
	Part_upvr.Anchored = true
	clone_upvr_3.Parent = Part_upvr
	if arg3 and 0 < arg3 then
		clone_upvr_3.Volume = 0
		local any_Create_result1_upvw = TweenService_upvr:Create(clone_upvr_3, TweenInfo.new(arg3), {
			Volume = clone_upvr_3.Volume;
		})
		any_Create_result1_upvw.Completed:Connect(function() -- Line 223
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvw (read and write)
			]]
			any_Create_result1_upvw:Pause()
			any_Create_result1_upvw:Destroy()
			any_Create_result1_upvw = nil
		end)
		any_Create_result1_upvw:Play()
	end
	clone_upvr_3:Play()
	local Name_2 = arg1.Name
	if not tbl_2_upvr[Name_2] then
		tbl_2_upvr[Name_2] = 0
	end
	local var50 = tbl_2_upvr
	var50[Name_2] += 1
	task.delay(clone_upvr_3.TimeLength, function() -- Line 235
		--[[ Upvalues[5]:
			[1]: arg1 (readonly)
			[2]: tbl_2_upvr (copied, readonly)
			[3]: Debris_upvr (copied, readonly)
			[4]: clone_upvr_3 (readonly)
			[5]: Part_upvr (readonly)
		]]
		local Name_4 = arg1.Name
		if tbl_2_upvr[Name_4] then
			local var53 = tbl_2_upvr
			var53[Name_4] -= 1
		end
		Debris_upvr:AddItem(clone_upvr_3, 0)
		Debris_upvr:AddItem(Part_upvr, 0)
	end)
end
local function PlaySoundFollow3D_upvr(arg1, arg2, arg3) -- Line 244, Named "PlaySoundFollow3D"
	--[[ Upvalues[3]:
		[1]: TweenService_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	local clone_upvr_2 = arg1:Clone()
	clone_upvr_2.Parent = arg2
	if arg3 and 0 < arg3 then
		clone_upvr_2.Volume = 0
		local any_Create_result1_upvw_6 = TweenService_upvr:Create(clone_upvr_2, TweenInfo.new(arg3), {
			Volume = clone_upvr_2.Volume;
		})
		any_Create_result1_upvw_6.Completed:Connect(function() -- Line 254
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvw_6 (read and write)
			]]
			any_Create_result1_upvw_6:Pause()
			any_Create_result1_upvw_6:Destroy()
			any_Create_result1_upvw_6 = nil
		end)
		any_Create_result1_upvw_6:Play()
	end
	clone_upvr_2:Play()
	local Name = arg1.Name
	if not tbl_2_upvr[Name] then
		tbl_2_upvr[Name] = 0
	end
	local var59 = tbl_2_upvr
	var59[Name] += 1
	task.delay(clone_upvr_2.TimeLength, function() -- Line 266
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: tbl_2_upvr (copied, readonly)
			[3]: Debris_upvr (copied, readonly)
			[4]: clone_upvr_2 (readonly)
		]]
		local Name_3 = arg1.Name
		if tbl_2_upvr[Name_3] then
			local var62 = tbl_2_upvr
			var62[Name_3] -= 1
		end
		Debris_upvr:AddItem(clone_upvr_2, 0)
	end)
end
local _ = {
	SoundName = "";
	FadeInTime = 0;
	FadeOutTime = 0;
	AttachPart = nil;
	PlayPosition = nil;
	MaxPlayNum = nil;
}
function module.playSoundCanStop(arg1) -- Line 284
	--[[ Upvalues[1]:
		[1]: GetSoundByName_upvr (readonly)
	]]
	local GetSoundByName_result1_2 = GetSoundByName_upvr(arg1)
	if GetSoundByName_result1_2 then
		GetSoundByName_result1_2:Play()
	end
end
function module.playSound(arg1) -- Line 291
	--[[ Upvalues[6]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
		[3]: GetSoundByName_upvr (readonly)
		[4]: PlaySoundFollow3D_upvr (readonly)
		[5]: PlaySoundFixed3D_upvr (readonly)
		[6]: PlaySound2D_upvr (readonly)
	]]
	local SoundName_2 = arg1.SoundName
	local var73 = arg1.FadeInTime or 0
	local MaxPlayNum_2 = arg1.MaxPlayNum
	local AttachPart_2 = arg1.AttachPart
	local PlayPosition = arg1.PlayPosition
	local var77
	if tbl_2_upvr[SoundName_2] then
		var77 = tbl_2_upvr[SoundName_2]
	end
	if MaxPlayNum_2 and 0 < MaxPlayNum_2 and MaxPlayNum_2 <= var77 then
	elseif SoundName_2 then
		var77 = SoundName_2
		local GetSoundByName_upvr_result1 = GetSoundByName_upvr(var77)
		if GetSoundByName_upvr_result1 then
			if AttachPart_2 then
				var77 = PlaySoundFollow3D_upvr
				var77(GetSoundByName_upvr_result1, AttachPart_2, var73)
				return
			end
			if PlayPosition then
				var77 = PlaySoundFixed3D_upvr
				var77(GetSoundByName_upvr_result1, PlayPosition, var73)
				return
			end
			var77 = PlaySound2D_upvr
			var77(GetSoundByName_upvr_result1, var73)
		end
	end
end
function module.stopSound(arg1, arg2, arg3) -- Line 328
	--[[ Upvalues[2]:
		[1]: GetSoundByName_upvr (readonly)
		[2]: stopThisSound_upvr (readonly)
	]]
	if not arg2 then
	end
	if not arg3 then
	end
	stopThisSound_upvr(GetSoundByName_upvr(arg1), false, 0)
end
function module.PlayBGM(arg1, arg2) -- Line 342
	--[[ Upvalues[2]:
		[1]: GetSoundByName_upvr (readonly)
		[2]: TweenService_upvr (readonly)
	]]
	local GetSoundByName_result1 = GetSoundByName_upvr(arg1)
	if GetSoundByName_result1 then
		if not GetSoundByName_result1:GetAttribute("Volume") then
			GetSoundByName_result1:SetAttribute("Volume", GetSoundByName_result1.Volume)
		end
		if GetSoundByName_result1.IsPlaying then
			GetSoundByName_result1:Stop()
		end
		if arg2 and 0 < arg2 then
			GetSoundByName_result1.Volume = 0
			local any_Create_result1_upvw_4 = TweenService_upvr:Create(GetSoundByName_result1, TweenInfo.new(arg2), {
				Volume = GetSoundByName_result1:GetAttribute("Volume");
			})
			any_Create_result1_upvw_4.Completed:Connect(function() -- Line 361
				--[[ Upvalues[1]:
					[1]: any_Create_result1_upvw_4 (read and write)
				]]
				any_Create_result1_upvw_4:Pause()
				any_Create_result1_upvw_4:Destroy()
				any_Create_result1_upvw_4 = nil
			end)
			any_Create_result1_upvw_4:Play()
		end
		GetSoundByName_result1:Play()
	end
end
function module.StopBGM(arg1, arg2) -- Line 377
	--[[ Upvalues[2]:
		[1]: GetSoundByName_upvr (readonly)
		[2]: TweenService_upvr (readonly)
	]]
	local GetSoundByName_result1_3_upvr = GetSoundByName_upvr(arg1)
	if GetSoundByName_result1_3_upvr and GetSoundByName_result1_3_upvr.IsPlaying then
		local Volume_upvr = GetSoundByName_result1_3_upvr:GetAttribute("Volume")
		local any_Create_result1_upvw_2 = TweenService_upvr:Create(GetSoundByName_result1_3_upvr, TweenInfo.new(arg2), {
			Volume = 0;
		})
		any_Create_result1_upvw_2.Completed:Connect(function() -- Line 386
			--[[ Upvalues[3]:
				[1]: GetSoundByName_result1_3_upvr (readonly)
				[2]: Volume_upvr (readonly)
				[3]: any_Create_result1_upvw_2 (read and write)
			]]
			GetSoundByName_result1_3_upvr:Stop()
			GetSoundByName_result1_3_upvr.Volume = Volume_upvr
			any_Create_result1_upvw_2:Destroy()
			any_Create_result1_upvw_2 = nil
		end)
		any_Create_result1_upvw_2:Play()
		local var89_upvw
		var89_upvw = GetSoundByName_result1_3_upvr.Stopped:Connect(function() -- Line 395
			--[[ Upvalues[4]:
				[1]: var89_upvw (read and write)
				[2]: any_Create_result1_upvw_2 (read and write)
				[3]: GetSoundByName_result1_3_upvr (readonly)
				[4]: Volume_upvr (readonly)
			]]
			var89_upvw:Disconnect()
			var89_upvw = nil
			if any_Create_result1_upvw_2 then
				any_Create_result1_upvw_2:Destroy()
				any_Create_result1_upvw_2 = nil
				GetSoundByName_result1_3_upvr.Volume = Volume_upvr
			end
		end)
	end
end
function module.stopAllGroupSounds(arg1) -- Line 417
	--[[ Upvalues[3]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: GetSoundByName_upvr (readonly)
		[3]: stopThisSound_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1, pairs_result2, pairs_result3_2 = pairs(ReplicatedStorage_upvr["音频"]:GetChildren())
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [16] 12. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [16] 12. Error Block 4 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [10] 8. Error Block 14 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [16.8]
	if nil == arg1 then
		-- KONSTANTWARNING: GOTO [19] #14
	end
	-- KONSTANTERROR: [10] 8. Error Block 14 end (CF ANALYSIS FAILED)
end
function module.setSoundGroupVolume(arg1, arg2, arg3) -- Line 434
	--[[ Upvalues[1]:
		[1]: TweenService_upvr (readonly)
	]]
	if not arg2 then
		local var100 = 1
	end
	local SOME_4 = workspace["音效组"]:FindFirstChild(arg1)
	local var102
	if SOME_4 and SOME_4:IsA("SoundGroup") then
		var102 = SOME_4
	else
		var102 = nil
	end
	if var102 then
		local var103 = 1
		local Setting = game.Players.LocalPlayer:FindFirstChild("Setting")
		if Setting then
			local SOME_3 = Setting:FindFirstChild(arg1)
			if SOME_3 then
				var103 = SOME_3.Value
			end
		end
		if not arg3 then
			var102.Volume = var103 * var100
			return
		end
		TweenService_upvr:Create(var102, TweenInfo.new(arg3), {
			Volume = var103 * var100;
		}):Play()
	end
end
return module