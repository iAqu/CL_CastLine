-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:27
-- Luau version 6, Types version 3
-- Time taken: 0.001804 seconds

local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local FightEvent_upvr = ReplicatedStorage.Msg.FightEvent
local RunService_upvr = game:GetService("RunService")
function module.EnableSynAnchored(arg1) -- Line 14
	--[[ Upvalues[3]:
		[1]: InsMgr_upvr (readonly)
		[2]: FightEvent_upvr (readonly)
		[3]: RunService_upvr (readonly)
	]]
	if arg1 then
		local Character_upvr = arg1.Character
		if Character_upvr then
			local PrimaryPart_2_upvr = Character_upvr.PrimaryPart
			if PrimaryPart_2_upvr then
				PrimaryPart_2_upvr.Anchored = true
				local any_GetIns_result1_upvr = InsMgr_upvr.GetIns("IsSynCFrame", "BoolValue", PrimaryPart_2_upvr)
				if any_GetIns_result1_upvr.Value then
					warn("已存在位置同步")
					return
				end
				any_GetIns_result1_upvr.Value = true
				FightEvent_upvr:FireServer("开启同步玩家位置")
				local var15_upvw
				var15_upvw = RunService_upvr.RenderStepped:Connect(function() -- Line 37
					--[[ Upvalues[5]:
						[1]: Character_upvr (readonly)
						[2]: PrimaryPart_2_upvr (readonly)
						[3]: any_GetIns_result1_upvr (readonly)
						[4]: var15_upvw (read and write)
						[5]: FightEvent_upvr (copied, readonly)
					]]
					if not Character_upvr or not PrimaryPart_2_upvr or not any_GetIns_result1_upvr or any_GetIns_result1_upvr.Value == false then
						var15_upvw:Disconnect()
						var15_upvw = nil
					elseif PrimaryPart_2_upvr then
						FightEvent_upvr:FireServer("同步玩家位置", PrimaryPart_2_upvr:GetPivot())
					end
				end)
			end
		end
	end
end
function module.DisableSynAnchored(arg1) -- Line 59
	--[[ Upvalues[2]:
		[1]: InsMgr_upvr (readonly)
		[2]: FightEvent_upvr (readonly)
	]]
	if arg1 then
		local Character = arg1.Character
		if Character then
			local PrimaryPart = Character.PrimaryPart
			if PrimaryPart then
				PrimaryPart.Anchored = false
				InsMgr_upvr.GetIns("IsSynCFrame", "BoolValue", PrimaryPart).Value = false
				FightEvent_upvr:FireServer("关闭同步玩家位置")
			end
		end
	end
end
return module