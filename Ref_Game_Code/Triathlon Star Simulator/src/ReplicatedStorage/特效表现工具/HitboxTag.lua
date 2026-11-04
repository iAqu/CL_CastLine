-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:57
-- Luau version 6, Types version 3
-- Time taken: 0.001943 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ResUtil_upvr = require(ReplicatedStorage["特效表现工具"].ResUtil)
function module_upvr.SetTag(arg1, arg2) -- Line 11
	if arg1 then
		arg1:SetAttribute("HitOrder", arg2)
	end
end
local VisibleMgr_upvr = require(ReplicatedStorage.Tool.VisibleMgr)
function module_upvr.SetHitBox(arg1) -- Line 19
	--[[ Upvalues[1]:
		[1]: VisibleMgr_upvr (readonly)
	]]
	if arg1 then
		VisibleMgr_upvr.UnQueryAll(arg1)
		VisibleMgr_upvr.AnchoredAll(arg1)
		VisibleMgr_upvr.UnTouchAll(arg1)
		VisibleMgr_upvr.UnCollideAll(arg1)
		VisibleMgr_upvr.SetHitboxCollideGroup(arg1)
		arg1.Massless = true
		arg1.CastShadow = false
		arg1.Transparency = 1
		arg1.Name = "HitBox"
		arg1:PivotTo(CFrame.new(0, -1000, 0))
	end
end
function module_upvr.EnabledHitBox(arg1) -- Line 36
	if arg1 then
		arg1:SetAttribute("Enabled", true)
	end
end
function module_upvr.DisableHitBox(arg1) -- Line 44
	if arg1 then
		arg1:SetAttribute("Enabled", false)
	end
end
function module_upvr.CreateHitBox(arg1, arg2, arg3) -- Line 63
	--[[ Upvalues[2]:
		[1]: ResUtil_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	arg1.hitBox = {}
	local hitBox = arg1.hitBox
	local Releaser = arg1.Releaser
	if Releaser and Releaser == game.Players.LocalPlayer then
		for i, v in pairs(arg2) do
			for _ = 1, v do
				local Part_2 = Instance.new("Part", ResUtil_upvr.Get_SkFolder(Releaser, arg3))
				module_upvr.SetTag(Part_2, i)
				module_upvr.SetHitBox(Part_2)
				module_upvr.DisableHitBox(Part_2)
				table.insert(hitBox, Part_2)
			end
		end
	end
end
function module_upvr.CreateEnemyHitBox(arg1, arg2, arg3) -- Line 96
	--[[ Upvalues[2]:
		[1]: ResUtil_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	arg1.hitBox = {}
	local hitBox_2 = arg1.hitBox
	local Caster = arg1.Caster
	local any_Get_Enemy_SkFolder_result1 = ResUtil_upvr.Get_Enemy_SkFolder(Caster.Name, arg3)
	if Caster then
		for i_3, v_2 in pairs(arg2) do
			for _ = 1, v_2 do
				local Part = Instance.new("Part", any_Get_Enemy_SkFolder_result1)
				module_upvr.SetHitBox(Part)
				module_upvr.SetTag(Part, i_3)
				module_upvr.DisableHitBox(Part)
				table.insert(hitBox_2, Part)
			end
		end
	end
end
return module_upvr