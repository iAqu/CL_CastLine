-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:12
-- Luau version 6, Types version 3
-- Time taken: 0.000930 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local LocalPlayer_upvr = game.Players.LocalPlayer
local Parent = script.Parent
local PlrFrame_upvr = Parent.Frame.PlrFrame
local Close_upvr = Parent.Frame.Close
local Open_upvr = Parent.Frame.Open
local PlrName_upvr = PlrFrame_upvr.PlrName
local PlrIcon_upvr = PlrFrame_upvr.PlrIcon
AddListen.NumValueAdd(LocalPlayer_upvr:WaitForChild("GiftPlayer", math.huge), function(arg1) -- Line 17
	--[[ Upvalues[5]:
		[1]: Close_upvr (readonly)
		[2]: Open_upvr (readonly)
		[3]: PlrFrame_upvr (readonly)
		[4]: PlrName_upvr (readonly)
		[5]: PlrIcon_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 3 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [24.1]
	PlrIcon_upvr.Image = nil.Image
	do
		return
	end
	-- KONSTANTERROR: [23] 18. Error Block 3 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [29] 22. Error Block 4 start (CF ANALYSIS FAILED)
	Close_upvr.Visible = false
	Open_upvr.Visible = true
	PlrFrame_upvr.Visible = false
	-- KONSTANTERROR: [29] 22. Error Block 4 end (CF ANALYSIS FAILED)
end)
local showLocalUI_upvr = ReplicatedStorage.LocalMsg.showLocalUI
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
AddListen.AddMouseCLick(Parent, function() -- Line 34
	--[[ Upvalues[3]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: showLocalUI_upvr (readonly)
		[3]: RemoteEvent_upvr (readonly)
	]]
	local GiftPlayer = LocalPlayer_upvr:FindFirstChild("GiftPlayer")
	if GiftPlayer then
		if GiftPlayer.Value == nil then
			showLocalUI_upvr:Fire("赠送列表", nil, true)
			return
		end
		RemoteEvent_upvr:FireServer("取消赠送")
	end
end, Parent.Frame)