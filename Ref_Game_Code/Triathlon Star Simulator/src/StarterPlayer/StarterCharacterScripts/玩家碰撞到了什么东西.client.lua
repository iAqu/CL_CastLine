-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:31:06
-- Luau version 6, Types version 3
-- Time taken: 0.001979 seconds

local LocalPlayer_upvr = game.Players.LocalPlayer
local ReplicatedStorage = game.ReplicatedStorage
local HumanoidRootPart_upvr = LocalPlayer_upvr.Character:WaitForChild("HumanoidRootPart", math.huge)
local showLocalUI_upvr = ReplicatedStorage.LocalMsg.showLocalUI
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local any_GetIns_result1_upvr = require(ReplicatedStorage.Tool.InsMgr).GetIns("IsInReadyArea", "BoolValue", LocalPlayer_upvr)
local function IsStillTouch_upvr(arg1, arg2) -- Line 19, Named "IsStillTouch"
	for _, v in pairs(workspace:GetPartsInPart(arg1)) do
		if v == arg2 then
			return true
		end
	end
	if arg1 then
		for _, v_2 in pairs(arg1:GetTouchingParts()) do
			if v_2 == arg2 then
				return true
			end
		end
	end
	return false
end
local SystemBuyRoblox_upvr = require(ReplicatedStorage.System.SystemBuyRoblox)
HumanoidRootPart_upvr.Touched:Connect(function(arg1) -- Line 42
	--[[ Upvalues[5]:
		[1]: any_GetIns_result1_upvr (readonly)
		[2]: showLocalUI_upvr (readonly)
		[3]: RemoteEvent_upvr (readonly)
		[4]: SystemBuyRoblox_upvr (readonly)
		[5]: LocalPlayer_upvr (readonly)
	]]
	if not arg1 then
	else
		if arg1:GetAttribute("ReadyArea") then
			any_GetIns_result1_upvr.Value = true
			return
		end
		if arg1:GetAttribute("openUI") then
			showLocalUI_upvr:Fire(arg1:GetAttribute("openUI"), arg1:GetAttribute("openUIData"), true)
			return
		end
		if arg1:GetAttribute("TrainArea") then
			RemoteEvent_upvr:FireServer("进入训练区域", arg1:GetAttribute("TrainArea"))
			return
		end
		local RobloxBuy = arg1:GetAttribute("RobloxBuy")
		if RobloxBuy then
			SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_upvr, RobloxBuy)
		end
	end
end)
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
HumanoidRootPart_upvr.TouchEnded:Connect(function(arg1) -- Line 75
	--[[ Upvalues[6]:
		[1]: IsStillTouch_upvr (readonly)
		[2]: HumanoidRootPart_upvr (readonly)
		[3]: any_GetIns_result1_upvr (readonly)
		[4]: RemoteFunction_upvr (readonly)
		[5]: showLocalUI_upvr (readonly)
		[6]: RemoteEvent_upvr (readonly)
	]]
	if not arg1 then
	else
		if IsStillTouch_upvr(arg1, HumanoidRootPart_upvr) then return end
		if arg1:GetAttribute("ReadyArea") then
			any_GetIns_result1_upvr.Value = false
			return
		end
		if arg1:GetAttribute("DungeonTeam") then
			RemoteFunction_upvr:InvokeServer("退出组队房间", arg1:GetAttribute("DungeonTeam"))
			return
		end
		if arg1:GetAttribute("openUI") then
			showLocalUI_upvr:Fire(arg1:GetAttribute("openUI"), nil, false)
			return
		end
		if arg1:GetAttribute("TrainArea") then
			RemoteEvent_upvr:FireServer("离开训练区域")
			return
		end
	end
end)