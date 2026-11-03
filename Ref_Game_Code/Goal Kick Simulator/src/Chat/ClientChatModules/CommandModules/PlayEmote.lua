-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:27
-- Luau version 6, Types version 3
-- Time taken: 0.005213 seconds

local module_upvr = require(script.Parent:WaitForChild("Util"))
local var2_upvw
local Chat_upvr = game:GetService("Chat")
pcall(function() -- Line 13
	--[[ Upvalues[2]:
		[1]: var2_upvw (read and write)
		[2]: Chat_upvr (readonly)
	]]
	var2_upvw = require(Chat_upvr.ClientChatModules.ChatLocalization)
end)
if var2_upvw == nil then
	var2_upvw = {
		Get = function(arg1, arg2, arg3) -- Line 14, Named "Get"
			return arg3
		end;
	}
end
local tbl_upvr = {
	wave = true;
	point = true;
	dance = true;
	dance2 = true;
	dance3 = true;
	laugh = true;
	cheer = true;
}
local tbl_upvr_3 = {
	NotSupported = "InGame.Chat.Response.EmotesNotSupported";
	R15Only = "InGame.Chat.Response.EmotesWrongAvatarType";
	SwitchToR15 = "InGame.Chat.ErrorMessageSwitchToR15";
	NoMatchingEmote = "InGame.Chat.Response.EmoteNotAvailable";
	TemporarilyUnavailable = "InGame.Chat.Response.EmotesTemporarilyUnavailable";
	AnimationPlaying = "InGame.Chat.ErrorMessageAnimationPlaying";
}
local tbl_upvr_2 = {
	[tbl_upvr_3.NotSupported] = "You can't use Emotes here.";
	[tbl_upvr_3.R15Only] = "Only R15 avatars can use Emotes.";
	[tbl_upvr_3.SwitchToR15] = "Switch to your R15 avatar to play Emote.";
	[tbl_upvr_3.NoMatchingEmote] = "You can't use that Emote.";
	[tbl_upvr_3.TemporarilyUnavailable] = "You can't use Emotes right now.";
	[tbl_upvr_3.AnimationPlaying] = "You cannot play Emotes during this action.";
}
local Color3_fromRGB_result1_upvr = Color3.fromRGB(245, 50, 50)
local function _(arg1) -- Line 48, Named "getEmoteName"
	if string.sub(arg1, 1, 3) == "/e " then
		return string.sub(arg1, 4)
	end
	if string.sub(arg1, 1, 7) == "/emote " then
		return string.sub(arg1, 8)
	end
	return nil
end
local function _(arg1, arg2) -- Line 58, Named "sendErrorMessage"
	--[[ Upvalues[4]:
		[1]: var2_upvw (read and write)
		[2]: tbl_upvr_2 (readonly)
		[3]: Color3_fromRGB_result1_upvr (readonly)
		[4]: module_upvr (readonly)
	]]
	module_upvr:SendSystemMessageToSelf(var2_upvw:Get(arg2, tbl_upvr_2[arg2]), arg1, {
		ChatColor = Color3_fromRGB_result1_upvr;
	})
end
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
return {
	[module_upvr.KEY_COMMAND_PROCESSOR_TYPE] = module_upvr.COMPLETED_MESSAGE_PROCESSOR;
	[module_upvr.KEY_PROCESSOR_FUNCTION] = function(arg1, arg2, arg3) -- Line 67, Named "ProcessMessage"
		--[[ Upvalues[7]:
			[1]: tbl_upvr (readonly)
			[2]: LocalPlayer_upvr (readonly)
			[3]: tbl_upvr_3 (readonly)
			[4]: var2_upvw (read and write)
			[5]: tbl_upvr_2 (readonly)
			[6]: Color3_fromRGB_result1_upvr (readonly)
			[7]: module_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 63 start (CF ANALYSIS FAILED)
		local var20_upvw
		if string.sub(arg1, 1, 3) == "/e " then
			var20_upvw = string.sub(arg1, 4)
			-- KONSTANTWARNING: GOTO [37] #28
		end
		-- KONSTANTERROR: [0] 1. Error Block 63 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [18] 14. Error Block 64 start (CF ANALYSIS FAILED)
		if string.sub(arg1, 1, 7) == "/emote " then
			var20_upvw = string.sub(arg1, 8)
		else
			var20_upvw = nil
		end
		if not var20_upvw then
			return false
		end
		if tbl_upvr[var20_upvw] then
			return true
		end
		local any_GetCurrentChannel_result1_upvr = arg2:GetCurrentChannel()
		if not any_GetCurrentChannel_result1_upvr then
			return true
		end
		local Character = LocalPlayer_upvr.Character
		if not Character then
			local TemporarilyUnavailable_2 = tbl_upvr_3.TemporarilyUnavailable
			module_upvr:SendSystemMessageToSelf(var2_upvw:Get(TemporarilyUnavailable_2, tbl_upvr_2[TemporarilyUnavailable_2]), any_GetCurrentChannel_result1_upvr, {
				ChatColor = Color3_fromRGB_result1_upvr;
			})
			return true
		end
		local Animate = Character:FindFirstChild("Animate")
		if not Animate then
			local NotSupported = tbl_upvr_3.NotSupported
			module_upvr:SendSystemMessageToSelf(var2_upvw:Get(NotSupported, tbl_upvr_2[NotSupported]), any_GetCurrentChannel_result1_upvr, {
				ChatColor = Color3_fromRGB_result1_upvr;
			})
			return true
		end
		if not Animate:FindFirstChild("PlayEmote") then
			local NotSupported_3 = tbl_upvr_3.NotSupported
			module_upvr:SendSystemMessageToSelf(var2_upvw:Get(NotSupported_3, tbl_upvr_2[NotSupported_3]), any_GetCurrentChannel_result1_upvr, {
				ChatColor = Color3_fromRGB_result1_upvr;
			})
			return true
		end
		local class_Humanoid_upvr = Character:FindFirstChildOfClass("Humanoid")
		if not class_Humanoid_upvr then
			local TemporarilyUnavailable_3 = tbl_upvr_3.TemporarilyUnavailable
			module_upvr:SendSystemMessageToSelf(var2_upvw:Get(TemporarilyUnavailable_3, tbl_upvr_2[TemporarilyUnavailable_3]), any_GetCurrentChannel_result1_upvr, {
				ChatColor = Color3_fromRGB_result1_upvr;
			})
			return true
		end
		if class_Humanoid_upvr.RigType ~= Enum.HumanoidRigType.R15 then
			local R15Only = tbl_upvr_3.R15Only
			module_upvr:SendSystemMessageToSelf(var2_upvw:Get(R15Only, tbl_upvr_2[R15Only]), any_GetCurrentChannel_result1_upvr, {
				ChatColor = Color3_fromRGB_result1_upvr;
			})
			return true
		end
		local class_HumanoidDescription = class_Humanoid_upvr:FindFirstChildOfClass("HumanoidDescription")
		if not class_HumanoidDescription then
			local TemporarilyUnavailable = tbl_upvr_3.TemporarilyUnavailable
			module_upvr:SendSystemMessageToSelf(var2_upvw:Get(TemporarilyUnavailable, tbl_upvr_2[TemporarilyUnavailable]), any_GetCurrentChannel_result1_upvr, {
				ChatColor = Color3_fromRGB_result1_upvr;
			})
			return true
		end
		for i, _ in pairs(class_HumanoidDescription:GetEmotes()) do
			({})[string.lower(i)] = i
			local var41
		end
		local tonumber_result1 = tonumber(var20_upvw)
		if tonumber_result1 then
			i = class_HumanoidDescription:GetEquippedEmotes()
			local pairs_result1, pairs_result2, pairs_result3_2 = pairs(i)
			for _, v_2 in pairs_result1, pairs_result2, pairs_result3_2 do
				if v_2.Slot == tonumber_result1 then
					var20_upvw = v_2.Name
				end
			end
		end
		var20_upvw = var41[string.lower(var20_upvw)]
		if not var20_upvw then
			pairs_result2 = tbl_upvr_3
			local NoMatchingEmote = pairs_result2.NoMatchingEmote
			pairs_result2 = var2_upvw:Get(NoMatchingEmote, tbl_upvr_2[NoMatchingEmote])
			pairs_result3_2 = {}
			pairs_result3_2.ChatColor = Color3_fromRGB_result1_upvr
			module_upvr:SendSystemMessageToSelf(pairs_result2, any_GetCurrentChannel_result1_upvr, pairs_result3_2)
			return true
		end
		spawn(function() -- Line 143
			--[[ Upvalues[8]:
				[1]: class_Humanoid_upvr (readonly)
				[2]: var20_upvw (read and write)
				[3]: any_GetCurrentChannel_result1_upvr (readonly)
				[4]: tbl_upvr_3 (copied, readonly)
				[5]: var2_upvw (copied, read and write)
				[6]: tbl_upvr_2 (copied, readonly)
				[7]: Color3_fromRGB_result1_upvr (copied, readonly)
				[8]: module_upvr (copied, readonly)
			]]
			local pcall_result1, pcall_result2 = pcall(function() -- Line 144
				--[[ Upvalues[2]:
					[1]: class_Humanoid_upvr (copied, readonly)
					[2]: var20_upvw (copied, read and write)
				]]
				return class_Humanoid_upvr:PlayEmote(var20_upvw)
			end)
			if not pcall_result1 then
				local NotSupported_2 = tbl_upvr_3.NotSupported
				module_upvr:SendSystemMessageToSelf(var2_upvw:Get(NotSupported_2, tbl_upvr_2[NotSupported_2]), any_GetCurrentChannel_result1_upvr, {
					ChatColor = Color3_fromRGB_result1_upvr;
				})
			elseif not pcall_result2 then
				local TemporarilyUnavailable_4 = tbl_upvr_3.TemporarilyUnavailable
				module_upvr:SendSystemMessageToSelf(var2_upvw:Get(TemporarilyUnavailable_4, tbl_upvr_2[TemporarilyUnavailable_4]), any_GetCurrentChannel_result1_upvr, {
					ChatColor = Color3_fromRGB_result1_upvr;
				})
			end
		end)
		do
			return true
		end
		-- KONSTANTERROR: [18] 14. Error Block 64 end (CF ANALYSIS FAILED)
	end;
}