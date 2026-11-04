-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:03
-- Luau version 6, Types version 3
-- Time taken: 0.001820 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local any_GetCfgByName_result1 = require(ReplicatedStorage.Tool.CfgFind).GetCfgByName("buffdataConf")
local Parent = script.Parent
local BUFF______ = Parent["BUFF格子"]
BUFF______.Visible = false
Parent["服务器BUFF格子"].Visible = false
for i, _ in pairs(any_GetCfgByName_result1) do
	local SOME = game.Players.LocalPlayer:WaitForChild("BUFF", math.huge):WaitForChild(i, math.huge)
	local tonumber_result1 = tonumber(SOME.Name)
	local var13 = any_GetCfgByName_result1[tonumber_result1]
	if var13 then
		local clone_upvr = BUFF______:Clone()
		clone_upvr.Name = tonumber_result1
		clone_upvr.LayoutOrder = tonumber_result1
		clone_upvr.Visible = true
		clone_upvr.Parent = Parent
		clone_upvr.Frame.Icon.Image = "rbxassetid://"..var13.Icon
		local TimeTransfer_upvr = require(ReplicatedStorage.Tool.TimeTransfer)
		AddListen.NumValueAdd(SOME, function(arg1) -- Line 40
			--[[ Upvalues[2]:
				[1]: clone_upvr (readonly)
				[2]: TimeTransfer_upvr (readonly)
			]]
			if 0 < arg1 then
				clone_upvr.Visible = true
				local timeText = clone_upvr.Frame.timeText
				if 0 <= arg1 then
					timeText.Text = TimeTransfer_upvr.FormatTime(arg1)
				else
					timeText.Text = "∞"
				end
			end
			clone_upvr.Visible = false
		end)
		local ShowDetail_upvr = require(ReplicatedStorage.Tool.ShowDetail)
		local var20_upvw = 0
		AddListen.AddMouseCLick(clone_upvr.Button, function() -- Line 55
			--[[ Upvalues[3]:
				[1]: clone_upvr (readonly)
				[2]: ShowDetail_upvr (readonly)
				[3]: var20_upvw (read and write)
			]]
			ShowDetail_upvr.ShowDetail({tonumber(clone_upvr.Name)}, clone_upvr, "Buff详情", false)
			var20_upvw = 3
		end, clone_upvr.Frame)
	end
end
spawn(function() -- Line 63
	--[[ Upvalues[2]:
		[1]: var20_upvw (read and write)
		[2]: ShowDetail_upvr (readonly)
	]]
	while true do
		if 0 <= var20_upvw then
			var20_upvw -= 1
			if var20_upvw <= 0 then
				ShowDetail_upvr.HideAllDetail()
			end
		end
		wait(1)
	end
end)