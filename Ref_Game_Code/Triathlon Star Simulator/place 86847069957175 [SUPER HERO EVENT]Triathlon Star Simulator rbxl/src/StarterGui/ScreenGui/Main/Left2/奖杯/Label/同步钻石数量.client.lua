-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:24
-- Luau version 6, Types version 3
-- Time taken: 0.001137 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local any_WaitBagNumberValue_result1 = require(ReplicatedStorage.Tool.GetData).WaitBagNumberValue(LocalPlayer, EnumMgr_upvr.ItemID.Money)
local IsNewPlayer_upvr = LocalPlayer:WaitForChild("IsNewPlayer", math.huge)
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local var9_upvw
local module_upvr = require(ReplicatedStorage:WaitForChild("Tool"):WaitForChild("UIanima"))
local Parent_upvr = script.Parent
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local function var5(arg1) -- Line 23
	--[[ Upvalues[8]:
		[1]: IsNewPlayer_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: RemoteEvent_upvr (readonly)
		[4]: var9_upvw (read and write)
		[5]: module_upvr (readonly)
		[6]: EnumMgr_upvr (readonly)
		[7]: Parent_upvr (readonly)
		[8]: MathMgr_upvr (readonly)
	]]
	if IsNewPlayer_upvr.Value == true and CfgFind_upvr.GetCfgByNameAndID("eggdataConf", 7000001).Price <= arg1 then
		RemoteEvent_upvr:FireServer("开启引导", "去抽宠物引导")
	end
	if script.Parent.Parent.Visible == false then
	else
		if var9_upvw ~= nil and var9_upvw < arg1 then
			module_upvr.GetItemAnimation(EnumMgr_upvr.ItemID.Money, arg1 - var9_upvw, script.Parent.Parent)
			delay(1, function() -- Line 38
				--[[ Upvalues[3]:
					[1]: Parent_upvr (copied, readonly)
					[2]: MathMgr_upvr (copied, readonly)
					[3]: arg1 (readonly)
				]]
				Parent_upvr.Text = MathMgr_upvr.getNumStr(math.floor(arg1))
			end)
		else
			Parent_upvr.Text = MathMgr_upvr.getNumStr(math.floor(arg1))
		end
		var9_upvw = arg1
	end
end
var5(any_WaitBagNumberValue_result1.Value)
any_WaitBagNumberValue_result1.Changed:Connect(var5)