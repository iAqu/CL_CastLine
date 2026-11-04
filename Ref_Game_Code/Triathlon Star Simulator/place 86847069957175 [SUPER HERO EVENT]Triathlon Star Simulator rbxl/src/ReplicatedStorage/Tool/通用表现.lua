-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:29
-- Luau version 6, Types version 3
-- Time taken: 0.001962 seconds

local module_upvr = {}
local ServiceUtil_upvr = require(game:GetService("ReplicatedStorage")["特效表现工具"].ServiceUtil)
function module_upvr.Sphere(arg1) -- Line 8
	--[[ Upvalues[1]:
		[1]: ServiceUtil_upvr (readonly)
	]]
	local _______________ = script["蓄力完成环"]
	if not _______________ then
	else
		local Size_upvr_2 = _______________.Size
		local any_GetInstance_From_Pool_result1_upvw = ServiceUtil_upvr.FXUtil.GetInstance_From_Pool(_______________)
		ServiceUtil_upvr.VisibleMgr.UnQueryAll(any_GetInstance_From_Pool_result1_upvw)
		ServiceUtil_upvr.VisibleMgr.UnTouchAll(any_GetInstance_From_Pool_result1_upvw)
		ServiceUtil_upvr.VisibleMgr.UnCollideAll(any_GetInstance_From_Pool_result1_upvw)
		ServiceUtil_upvr.VisibleMgr.AnchoredAll(any_GetInstance_From_Pool_result1_upvw)
		ServiceUtil_upvr.VisibleMgr.TransparencyAll(any_GetInstance_From_Pool_result1_upvw)
		any_GetInstance_From_Pool_result1_upvw.Size = Size_upvr_2
		any_GetInstance_From_Pool_result1_upvw:PivotTo(arg1)
		any_GetInstance_From_Pool_result1_upvw.Parent = workspace
		ServiceUtil_upvr.FXUtil.Set_Scale_Basepart(any_GetInstance_From_Pool_result1_upvw, 1)
		ServiceUtil_upvr.FXUtil.Set_Scale_Basepart_Tween(any_GetInstance_From_Pool_result1_upvw, 0.2, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		delay(0.2, function() -- Line 31
			--[[ Upvalues[3]:
				[1]: any_GetInstance_From_Pool_result1_upvw (read and write)
				[2]: Size_upvr_2 (readonly)
				[3]: ServiceUtil_upvr (copied, readonly)
			]]
			any_GetInstance_From_Pool_result1_upvw.Size = Size_upvr_2
			ServiceUtil_upvr.FXUtil.BackPool_Instance(any_GetInstance_From_Pool_result1_upvw)
		end)
	end
end
function module_upvr.Spike(arg1) -- Line 38
	--[[ Upvalues[1]:
		[1]: ServiceUtil_upvr (readonly)
	]]
	local __________________ = script["蓄力完成闪光"]
	if not __________________ then
	else
		local Size_upvr = __________________.Size
		local any_GetInstance_From_Pool_result1_upvw_2 = ServiceUtil_upvr.FXUtil.GetInstance_From_Pool(__________________)
		ServiceUtil_upvr.VisibleMgr.UnQueryAll(any_GetInstance_From_Pool_result1_upvw_2)
		ServiceUtil_upvr.VisibleMgr.UnTouchAll(any_GetInstance_From_Pool_result1_upvw_2)
		ServiceUtil_upvr.VisibleMgr.UnCollideAll(any_GetInstance_From_Pool_result1_upvw_2)
		ServiceUtil_upvr.VisibleMgr.AnchoredAll(any_GetInstance_From_Pool_result1_upvw_2)
		ServiceUtil_upvr.VisibleMgr.TransparencyAll(any_GetInstance_From_Pool_result1_upvw_2)
		any_GetInstance_From_Pool_result1_upvw_2.Transparency = 0
		any_GetInstance_From_Pool_result1_upvw_2:PivotTo(arg1)
		any_GetInstance_From_Pool_result1_upvw_2.Parent = workspace
		any_GetInstance_From_Pool_result1_upvw_2.Size = Size_upvr
		ServiceUtil_upvr.FXUtil.Set_Scale_Basepart(any_GetInstance_From_Pool_result1_upvw_2, 1)
		ServiceUtil_upvr.FXUtil.Set_Scale_Basepart_Tween(any_GetInstance_From_Pool_result1_upvw_2, 0.1, 0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		ServiceUtil_upvr.FXUtil.Control_Model_CFrame(any_GetInstance_From_Pool_result1_upvw_2, function(arg1_2) -- Line 65
			--[[ Upvalues[4]:
				[1]: any_GetInstance_From_Pool_result1_upvw_2 (read and write)
				[2]: ServiceUtil_upvr (copied, readonly)
				[3]: Size_upvr (readonly)
				[4]: arg1 (readonly)
			]]
			if not any_GetInstance_From_Pool_result1_upvw_2 then return end
			if 1 <= arg1_2 / 0.1 then
				ServiceUtil_upvr.FXUtil.Uncontrol_Model_CFrame(any_GetInstance_From_Pool_result1_upvw_2)
				any_GetInstance_From_Pool_result1_upvw_2.Size = Size_upvr
				ServiceUtil_upvr.FXUtil.BackPool_Instance(any_GetInstance_From_Pool_result1_upvw_2)
				any_GetInstance_From_Pool_result1_upvw_2.Transparency = 0
			end
			return arg1:ToWorldSpace(CFrame.Angles(math.rad(arg1_2 * 720), math.rad(arg1_2 * 720), 0))
		end)
	end
end
function module_upvr.FullCastEffect(arg1, arg2) -- Line 82
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: ServiceUtil_upvr (readonly)
	]]
	module_upvr.Sphere(arg2)
	module_upvr.Spike(arg2)
	ServiceUtil_upvr.FXUtil.PlaySound(arg1, "音效-技能-通用蓄力", 1, nil, arg2.Position)
end
return module_upvr