-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:51
-- Luau version 6, Types version 3
-- Time taken: 0.004001 seconds

local module_upvr = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local Debris_upvr = game:GetService("Debris")
local function _() -- Line 9, Named "GetPoolFolder"
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local ObjectPool = ReplicatedStorage_upvr:FindFirstChild("ObjectPool")
	if not ObjectPool then
		ObjectPool = module_upvr.Init()
	end
	return ObjectPool
end
local function _(arg1) -- Line 22, Named "Refresh_FreshTime_Attribute"
	if not arg1 then
	else
		arg1:SetAttribute("FreshTime", os.time())
	end
end
local function _(arg1) -- Line 33, Named "Set_Object_Attribute"
	if not arg1 then
	else
		arg1:SetAttribute("ModelName", arg1.Name)
		arg1:SetAttribute("FreshTime", os.time())
	end
end
local function _(arg1) -- Line 46, Named "Is_Exist_Same"
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local ObjectPool_3 = ReplicatedStorage_upvr:FindFirstChild("ObjectPool")
	if not ObjectPool_3 then
		ObjectPool_3 = module_upvr.Init()
	end
	for _, v in pairs(ObjectPool_3:GetChildren()) do
		local ModelName = v:GetAttribute("ModelName")
		if ModelName and ModelName == arg1 then
			return true
		end
	end
	return false
end
function module_upvr.Init() -- Line 65
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	local ObjectPool_4 = ReplicatedStorage_upvr:FindFirstChild("ObjectPool")
	if not ObjectPool_4 then
		ObjectPool_4 = Instance.new("Folder", ReplicatedStorage_upvr)
		ObjectPool_4.Name = "ObjectPool"
	end
	return ObjectPool_4
end
function module_upvr.Add_Object_To_Pool(arg1) -- Line 76
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		local clone = arg1:Clone()
		local ObjectPool_2 = ReplicatedStorage_upvr:FindFirstChild("ObjectPool")
		if not ObjectPool_2 then
			ObjectPool_2 = module_upvr.Init()
		end
		if not clone then
		else
			clone:SetAttribute("ModelName", clone.Name)
			clone:SetAttribute("FreshTime", os.time())
		end
		clone.Parent = ObjectPool_2
	end
end
local VisibleMgr_upvr = require(ReplicatedStorage_upvr.Tool.VisibleMgr)
function module_upvr.Back_Object_To_Pool(arg1) -- Line 94
	--[[ Upvalues[4]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
		[4]: VisibleMgr_upvr (readonly)
	]]
	if not arg1 then
	else
		if arg1.Parent == nil then return end
		local ObjectPool_7 = ReplicatedStorage_upvr:FindFirstChild("ObjectPool")
		if not ObjectPool_7 then
			ObjectPool_7 = module_upvr.Init()
		end
		local ModelName_2 = arg1:GetAttribute("ModelName")
		if not ModelName_2 then
			Debris_upvr:AddItem(arg1, 0)
			return
		end
		arg1.Name = ModelName_2
		if not arg1 then
		else
			arg1:SetAttribute("FreshTime", os.time())
		end
		VisibleMgr_upvr.AnchoredAll(arg1)
		VisibleMgr_upvr.SpeedDown(arg1)
		arg1.Parent = ObjectPool_7
	end
end
function module_upvr.Get_Object_From_Pool(arg1) -- Line 128
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local ObjectPool_6 = ReplicatedStorage_upvr:FindFirstChild("ObjectPool")
	if not ObjectPool_6 then
		ObjectPool_6 = module_upvr.Init()
	end
	local var29 = ObjectPool_6
	for _, v_2 in pairs(var29:GetChildren()) do
		if v_2:GetAttribute("ModelName") == arg1.Name then
			v_2.Parent = workspace
			return v_2
		end
	end
	module_upvr.Add_Object_To_Pool(arg1)
	for _, v_3 in pairs(var29:GetChildren()) do
		if v_3:GetAttribute("ModelName") == arg1.Name then
			v_3.Parent = workspace
			return v_3
		end
	end
end
function module_upvr.Clear_Idle_Object() -- Line 164
	--[[ Upvalues[3]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	local ObjectPool_5 = ReplicatedStorage_upvr:FindFirstChild("ObjectPool")
	if not ObjectPool_5 then
		ObjectPool_5 = module_upvr.Init()
	end
	for _, v_4 in pairs(ObjectPool_5:GetChildren()) do
		if 60 < os.time() - v_4:GetAttribute("FreshTime") then
			Debris_upvr:AddItem(v_4, 0)
		end
	end
end
return module_upvr