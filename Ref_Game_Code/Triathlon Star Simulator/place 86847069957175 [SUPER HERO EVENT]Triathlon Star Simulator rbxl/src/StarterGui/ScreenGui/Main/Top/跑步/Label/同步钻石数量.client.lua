-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:33
-- Luau version 6, Types version 3
-- Time taken: 0.001041 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local any_WaitBagNumberValue_result1 = require(ReplicatedStorage.Tool.GetData).WaitBagNumberValue(game.Players.LocalPlayer, EnumMgr_upvr.ItemID.Attr_3)
local var5_upvw
local module_upvr = require(ReplicatedStorage:WaitForChild("Tool"):WaitForChild("UIanima"))
local Parent_upvr = script.Parent
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local function var4(arg1) -- Line 20
	--[[ Upvalues[5]:
		[1]: var5_upvw (read and write)
		[2]: module_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
		[4]: Parent_upvr (readonly)
		[5]: MathMgr_upvr (readonly)
	]]
	if script.Parent.Parent.Visible == false then
	else
		if var5_upvw ~= nil and var5_upvw < arg1 then
			module_upvr.GetItemAnimation(EnumMgr_upvr.ItemID.Attr_3, arg1 - var5_upvw, script.Parent.Parent.Icon)
			delay(1, function() -- Line 29
				--[[ Upvalues[3]:
					[1]: Parent_upvr (copied, readonly)
					[2]: MathMgr_upvr (copied, readonly)
					[3]: arg1 (readonly)
				]]
				Parent_upvr.Text = MathMgr_upvr.getNumStr_1(arg1)
			end)
		else
			Parent_upvr.Text = MathMgr_upvr.getNumStr_1(arg1)
		end
		var5_upvw = arg1
	end
end
var4(any_WaitBagNumberValue_result1.Value)
any_WaitBagNumberValue_result1.Changed:Connect(var4)