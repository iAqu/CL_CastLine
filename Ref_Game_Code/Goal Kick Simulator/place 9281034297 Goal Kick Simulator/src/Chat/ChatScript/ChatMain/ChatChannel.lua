-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:20
-- Luau version 6, Types version 3
-- Time taken: 0.007033 seconds

local pcall_result1, pcall_result2_4 = pcall(function() -- Line 7
	return UserSettings():IsUserFeatureEnabled("UserFlagRemoveMessageFromMessageLog")
end)
local pcall_result1_3, pcall_result2_3 = pcall(function() -- Line 15
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)
local var28_upvw = pcall_result1_3 and pcall_result2_3
local module = {}
local Parent_2 = script.Parent
local module_upvr_2 = require(game:GetService("Chat"):WaitForChild("ClientChatModules"):WaitForChild("ChatSettings"))
local var32_upvw
if var28_upvw then
	var32_upvw = Parent_2:FindFirstChild("ChatTranslationEnabled")
	if var32_upvw == nil then
		local var34_upvw
		var34_upvw = Parent_2.ChildAdded:Connect(function(arg1) -- Line 35
			--[[ Upvalues[2]:
				[1]: var32_upvw (read and write)
				[2]: var34_upvw (read and write)
			]]
			if arg1.Name == "ChatTranslationEnabled" then
				var32_upvw = arg1
				var34_upvw:Disconnect()
			end
		end)
	end
end
local tbl_upvr = {}
tbl_upvr.__index = tbl_upvr
function tbl_upvr.Destroy(arg1) -- Line 50
	arg1.Destroyed = true
end
function tbl_upvr.SetActive(arg1, arg2) -- Line 54
	if arg2 == arg1.Active then
	else
		if arg2 == false then
			arg1.MessageLogDisplay:Clear()
		else
			arg1.MessageLogDisplay:SetCurrentChannelName(arg1.Name)
			for i_4 = 1, #arg1.MessageLog do
				arg1.MessageLogDisplay:AddMessage(arg1.MessageLog[i_4])
			end
		end
		arg1.Active = arg2
	end
end
local var37_upvw = pcall_result1 and pcall_result2_4
function tbl_upvr.UpdateMessageFiltered(arg1, arg2) -- Line 69
	--[[ Upvalues[3]:
		[1]: var28_upvw (read and write)
		[2]: var32_upvw (read and write)
		[3]: var37_upvw (read and write)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [16] 12. Error Block 21 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [16] 12. Error Block 21 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [4] 4. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [17.2950158]
	-- KONSTANTERROR: [4] 4. Error Block 2 end (CF ANALYSIS FAILED)
end
function tbl_upvr.AddMessageToChannel(arg1, arg2) -- Line 105
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	table.insert(arg1.MessageLog, arg2)
	if arg1.Active then
		arg1.MessageLogDisplay:AddMessage(arg2)
	end
	if module_upvr_2.MessageHistoryLengthPerChannel < #arg1.MessageLog then
		arg1:RemoveLastMessageFromChannel()
	end
end
function tbl_upvr.InternalAddMessageAtTimeStamp(arg1, arg2) -- Line 115
	for i = 1, #arg1.MessageLog do
		if arg2.Time < arg1.MessageLog[i].Time then
			table.insert(arg1.MessageLog, i, arg2)
			return
		end
	end
	table.insert(arg1.MessageLog, arg2)
end
function tbl_upvr.AddMessagesToChannelByTimeStamp(arg1, arg2, arg3) -- Line 125
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	for i_2 = arg3, #arg2 do
		arg1:InternalAddMessageAtTimeStamp(arg2[i_2])
	end
	while true do
		i_2 = module_upvr_2
		if i_2.MessageHistoryLengthPerChannel >= #arg1.MessageLog then break end
		i_2 = 1
		table.remove(arg1.MessageLog, i_2)
	end
	if arg1.Active then
		arg1.MessageLogDisplay:Clear()
		i_2 = 1
		for i_3 = i_2, #arg1.MessageLog do
			arg1.MessageLogDisplay:AddMessage(arg1.MessageLog[i_3])
		end
	end
end
function tbl_upvr.AddMessageToChannelByTimeStamp(arg1, arg2) -- Line 140
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	if 1 <= #arg1.MessageLog then
		if arg2.Time < arg1.MessageLog[1].Time then
		else
			if arg1.MessageLog[#arg1.MessageLog].Time <= arg2.Time then
				arg1:AddMessageToChannel(arg2)
				return
			end
			for i_5 = 1, #arg1.MessageLog do
				if arg2.Time < arg1.MessageLog[i_5].Time then
					table.insert(arg1.MessageLog, i_5, arg2)
					if module_upvr_2.MessageHistoryLengthPerChannel < #arg1.MessageLog then
						arg1:RemoveLastMessageFromChannel()
					end
					if arg1.Active then
						arg1.MessageLogDisplay:AddMessageAtIndex(arg2, i_5)
					end
					return
				end
			end
		end
	end
	arg1:AddMessageToChannel(arg2)
end
function tbl_upvr.RemoveLastMessageFromChannel(arg1) -- Line 170
	table.remove(arg1.MessageLog, 1)
	if arg1.Active then
		arg1.MessageLogDisplay:RemoveLastMessage()
	end
end
function tbl_upvr.ClearMessageLog(arg1) -- Line 178
	arg1.MessageLog = {}
	if arg1.Active then
		arg1.MessageLogDisplay:Clear()
	end
end
function tbl_upvr.RegisterChannelTab(arg1, arg2) -- Line 186
	arg1.ChannelTab = arg2
end
function module.new(arg1, arg2) -- Line 193
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local setmetatable_result1_2 = setmetatable({}, tbl_upvr)
	setmetatable_result1_2.Destroyed = false
	setmetatable_result1_2.Active = false
	setmetatable_result1_2.MessageLog = {}
	setmetatable_result1_2.MessageLogDisplay = arg2
	setmetatable_result1_2.ChannelTab = nil
	setmetatable_result1_2.Name = arg1
	return setmetatable_result1_2
end
return module