-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:26
-- Luau version 6, Types version 3
-- Time taken: 0.002218 seconds

local module = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local InsMgr_upvr = require(ReplicatedStorage_upvr.Tool.InsMgr)
local function _() -- Line 9, Named "GetPoolFolder"
	--[[ Upvalues[2]:
		[1]: InsMgr_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	return InsMgr_upvr.GetIns("PoolFolder", "Folder", ReplicatedStorage_upvr)
end
local function ObjectInPoolSet_upvr(arg1) -- Line 18, Named "ObjectInPoolSet"
	if arg1:IsA("BasePart") then
		arg1.CFrame = CFrame.new(0, -1000, 0)
		arg1.Anchored = true
	end
	if arg1:IsA("Model") then
		arg1:PivotTo(CFrame.new(0, -1000, 0))
		arg1.PrimaryPart.Anchored = true
	end
	for _, v in pairs(arg1:GetChildren()) do
		if v:IsA("Trail") then
			v.Enabled = false
		end
	end
end
local function ObjectOutPoolSet_upvr(arg1) -- Line 39, Named "ObjectOutPoolSet"
	for _, v_2 in pairs(arg1:GetChildren()) do
		if v_2:IsA("Trail") then
			v_2.Enabled = true
		end
	end
end
local function _(arg1) -- Line 48, Named "PutInPool"
	--[[ Upvalues[3]:
		[1]: ObjectInPoolSet_upvr (readonly)
		[2]: InsMgr_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
	]]
	ObjectInPoolSet_upvr(arg1)
	arg1.Parent = InsMgr_upvr.GetIns("PoolFolder", "Folder", ReplicatedStorage_upvr)
end
local function _(arg1) -- Line 58, Named "PutOutPool"
	--[[ Upvalues[2]:
		[1]: InsMgr_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	for _, v_3 in pairs(InsMgr_upvr.GetIns("PoolFolder", "Folder", ReplicatedStorage_upvr):GetChildren()) do
		if v_3.Name == arg1 then
			return v_3
		end
	end
	return false
end
local function _(arg1, arg2) -- Line 78, Named "AddToPool"
	--[[ Upvalues[3]:
		[1]: ObjectInPoolSet_upvr (readonly)
		[2]: InsMgr_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
	]]
	for _ = 1, arg2 - 1 do
		local clone = arg1:Clone()
		ObjectInPoolSet_upvr(clone)
		clone.Parent = InsMgr_upvr.GetIns("PoolFolder", "Folder", ReplicatedStorage_upvr)
	end
end
function module.GetFromPool(arg1) -- Line 89
	--[[ Upvalues[4]:
		[1]: InsMgr_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: ObjectInPoolSet_upvr (readonly)
		[4]: ObjectOutPoolSet_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1_2, pairs_result2, pairs_result3 = pairs(InsMgr_upvr.GetIns("PoolFolder", "Folder", ReplicatedStorage_upvr):GetChildren())
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 4 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [17] 14. Error Block 19 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [23.9]
	if nil == arg1.Name then
		-- KONSTANTWARNING: GOTO [26] #20
	end
	-- KONSTANTERROR: [17] 14. Error Block 19 end (CF ANALYSIS FAILED)
end
function module.BackToPool(arg1) -- Line 104
	--[[ Upvalues[3]:
		[1]: ObjectInPoolSet_upvr (readonly)
		[2]: InsMgr_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
	]]
	ObjectInPoolSet_upvr(arg1)
	arg1.Parent = InsMgr_upvr.GetIns("PoolFolder", "Folder", ReplicatedStorage_upvr)
end
return module