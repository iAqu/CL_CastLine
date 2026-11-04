-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:27
-- Luau version 6, Types version 3
-- Time taken: 0.001167 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local any_WaitBagNumberValue_result1 = require(ReplicatedStorage.Tool.GetData).WaitBagNumberValue(LocalPlayer, EnumMgr_upvr.ItemID.HatchToolToken)
local var6_upvw
local module_upvr = require(ReplicatedStorage:WaitForChild("Tool"):WaitForChild("UIanima"))
local Parent_upvr = script.Parent
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local IsNewPlayer_upvr = LocalPlayer:WaitForChild("IsNewPlayer", math.huge)
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local function var5(arg1) -- Line 22
	--[[ Upvalues[7]:
		[1]: var6_upvw (read and write)
		[2]: module_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
		[4]: Parent_upvr (readonly)
		[5]: MathMgr_upvr (readonly)
		[6]: IsNewPlayer_upvr (readonly)
		[7]: RemoteEvent_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 15 start (CF ANALYSIS FAILED)
	if script.Parent.Parent.Visible == false then
	else
		if var6_upvw ~= nil and var6_upvw < arg1 then
			module_upvr.GetItemAnimation(EnumMgr_upvr.ItemID.HatchToolToken, arg1 - var6_upvw, script.Parent.Parent)
			delay(1, function() -- Line 30
				--[[ Upvalues[3]:
					[1]: Parent_upvr (copied, readonly)
					[2]: MathMgr_upvr (copied, readonly)
					[3]: arg1 (readonly)
				]]
				Parent_upvr.Text = MathMgr_upvr.getNumStr(math.floor(arg1))
			end)
			if IsNewPlayer_upvr.Value == true and 1 <= arg1 then
				RemoteEvent_upvr:FireServer("开启引导", "抽装备引导")
				-- KONSTANTWARNING: GOTO [77] #53
			end
		else
			Parent_upvr.Text = MathMgr_upvr.getNumStr(math.floor(arg1))
		end
		-- KONSTANTERROR: [0] 1. Error Block 15 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [77] 53. Error Block 10 start (CF ANALYSIS FAILED)
		var6_upvw = arg1
		-- KONSTANTERROR: [77] 53. Error Block 10 end (CF ANALYSIS FAILED)
	end
end
var5(any_WaitBagNumberValue_result1.Value)
any_WaitBagNumberValue_result1.Changed:Connect(var5)