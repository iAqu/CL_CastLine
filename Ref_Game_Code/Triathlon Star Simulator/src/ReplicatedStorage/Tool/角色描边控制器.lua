-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:08
-- Luau version 6, Types version 3
-- Time taken: 0.003203 seconds

local module = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local InsMgr_upvr = require(ReplicatedStorage_upvr.Tool.InsMgr)
local tbl_upvr = {-- : First try: runluau:11745: attempt to index nil with 't'

local tbl_upvr_2 = {"Left Leg", "Right Leg", "Torso", "Left Arm", "Right Arm"}
local Color3_new_result1_upvr = Color3.new(0, 0, 0)
function module.CreateOutLine_R6(arg1) -- Line 42
	--[[ Upvalues[4]:
		[1]: tbl_upvr_2 (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: Color3_new_result1_upvr (readonly)
		[4]: InsMgr_upvr (readonly)
	]]
	for _, v in pairs(tbl_upvr_2) do
		local SOME_5 = arg1:FindFirstChild(v)
		if SOME_5 then
			local clone = ReplicatedStorage_upvr.ModelRes["描边"]:Clone()
			clone.Parent = SOME_5
			clone.Anchored = false
			clone.CanTouch = false
			clone.CanQuery = false
			clone.CanCollide = false
			clone.Massless = true
			clone.Material = Enum.Material.Neon
			clone.Color = Color3_new_result1_upvr
			clone.Size = SOME_5.Size + Vector3.new(0.05999, 0.05999, 0.05999)
			clone:PivotTo(SOME_5:GetPivot())
			local any_GetIns_result1_5 = InsMgr_upvr.GetIns("OutLineWeld", "Weld", clone)
			any_GetIns_result1_5.Part0 = SOME_5
			any_GetIns_result1_5.Part1 = clone
		end
	end
end
function module.CreateOutLine_R15(arg1) -- Line 78
	--[[ Upvalues[3]:
		[1]: tbl_upvr (readonly)
		[2]: InsMgr_upvr (readonly)
		[3]: Color3_new_result1_upvr (readonly)
	]]
	for _, v_2 in pairs(tbl_upvr) do
		local SOME_6 = arg1:FindFirstChild(v_2)
		if SOME_6 then
			local any_GetIns_result1_4 = InsMgr_upvr.GetIns("OutLine", "Part", SOME_6)
			any_GetIns_result1_4.Anchored = false
			any_GetIns_result1_4.CanTouch = false
			any_GetIns_result1_4.CanQuery = false
			any_GetIns_result1_4.CanCollide = false
			any_GetIns_result1_4.Massless = true
			any_GetIns_result1_4.Material = Enum.Material.Neon
			any_GetIns_result1_4.Color = Color3_new_result1_upvr
			any_GetIns_result1_4.Size = SOME_6.Size
			any_GetIns_result1_4:PivotTo(SOME_6:GetPivot())
			local any_GetIns_result1_2 = InsMgr_upvr.GetIns("OutLineWeld", "WeldConstraint", any_GetIns_result1_4)
			any_GetIns_result1_2.Part0 = SOME_6
			any_GetIns_result1_2.Part1 = any_GetIns_result1_4
			local any_GetIns_result1_3 = InsMgr_upvr.GetIns("OutLineMesh", "SpecialMesh", any_GetIns_result1_4)
			any_GetIns_result1_3.Scale = Vector3.new(1.10000, 1.10000, -1.1000)
			any_GetIns_result1_3.MeshId = SOME_6.MeshId
			any_GetIns_result1_3.VertexColor = Vector3.new(0, 0, 0)
		end
	end
end
function module.CreateOutLine_R15_NewParent(arg1, arg2, arg3) -- Line 114
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: InsMgr_upvr (readonly)
	]]
	for _, v_3 in pairs(tbl_upvr) do
		local SOME_3 = arg1:FindFirstChild(v_3)
		if SOME_3 then
			local any_GetIns_result1_6 = InsMgr_upvr.GetIns(v_3, "Part", arg3)
			any_GetIns_result1_6.Anchored = false
			any_GetIns_result1_6.CanTouch = false
			any_GetIns_result1_6.CanQuery = false
			any_GetIns_result1_6.CanCollide = false
			any_GetIns_result1_6.Massless = true
			any_GetIns_result1_6.CastShadow = false
			any_GetIns_result1_6.Material = Enum.Material.Neon
			any_GetIns_result1_6.Transparency = 0.5
			any_GetIns_result1_6.Color = arg2
			any_GetIns_result1_6.Size = SOME_3.Size
			any_GetIns_result1_6:PivotTo(SOME_3:GetPivot())
			local any_GetIns_result1 = InsMgr_upvr.GetIns("OutLineWeld", "WeldConstraint", any_GetIns_result1_6)
			any_GetIns_result1.Part0 = SOME_3
			any_GetIns_result1.Part1 = any_GetIns_result1_6
			local any_GetIns_result1_7 = InsMgr_upvr.GetIns("OutLineMesh", "SpecialMesh", any_GetIns_result1_6)
			any_GetIns_result1_7.Scale = Vector3.new(1.10000, 1.10000, 1.10000)
			any_GetIns_result1_7.MeshId = SOME_3.MeshId
			any_GetIns_result1_7.MeshType = Enum.MeshType.FileMesh
			any_GetIns_result1_7.VertexColor = Vector3.new(1, 1, 1)
		end
	end
end
function module.ChangeOutLineColor_R6(arg1, arg2) -- Line 152
	--[[ Upvalues[2]:
		[1]: Color3_new_result1_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then
		end
		for _, v_4 in pairs(tbl_upvr_2) do
			local SOME_2 = arg1:FindFirstChild(v_4)
			if SOME_2 then
				local OutLine_2 = SOME_2:FindFirstChild("OutLine")
				if OutLine_2 then
					OutLine_2.Color = Color3_new_result1_upvr
				end
			end
		end
	end
end
function module.ChangeOutLineColor_R15(arg1, arg2) -- Line 177
	--[[ Upvalues[2]:
		[1]: Color3_new_result1_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then
		end
		for _, v_5 in pairs(tbl_upvr) do
			local SOME = arg1:FindFirstChild(v_5)
			if SOME then
				local OutLine = SOME:FindFirstChild("OutLine")
				if OutLine then
					OutLine.Color = Color3_new_result1_upvr
				end
			end
		end
	end
end
return module