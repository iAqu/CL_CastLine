-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:27
-- Luau version 6, Types version 3
-- Time taken: 0.001687 seconds

local var1_upvr = require(script.Parent.loader).load(script)("TemplateProvider")
local setmetatable_result1_2_upvr = setmetatable({}, var1_upvr)
setmetatable_result1_2_upvr.ClassName = "TaggedTemplateProvider"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1) -- Line 17
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local var3 = setmetatable_result1_2_upvr
	local setmetatable_result1 = setmetatable(var1_upvr.new(), var3)
	if type(arg1) ~= "string" then
		var3 = false
	else
		var3 = true
	end
	assert(var3, "Bad containerTagName")
	setmetatable_result1._tagsToInitializeSet = {
		[arg1] = true;
	}
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.Init(arg1) -- Line 28
	--[[ Upvalues[1]:
		[1]: setmetatable_result1_2_upvr (readonly)
	]]
	assert(not arg1._maid, "Should not have a maid")
	getmetatable(setmetatable_result1_2_upvr).Init(arg1)
	assert(arg1._maid, "Should have a maid")
	for i, _ in pairs(arg1._tagsToInitializeSet) do
		arg1:AddContainersFromTag(i)
	end
end
local RunService_upvr = game:GetService("RunService")
local CollectionService_upvr = game:GetService("CollectionService")
function setmetatable_result1_2_upvr.AddContainersFromTag(arg1, arg2) -- Line 40
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: CollectionService_upvr (readonly)
	]]
	local _maid = arg1._maid
	assert(_maid, "Not initialized")
	if type(arg2) ~= "string" then
		_maid = false
	else
		_maid = true
	end
	assert(_maid, "Bad containerTagName")
	if RunService_upvr:IsRunning() then
		arg1._maid:GiveTask(CollectionService_upvr:GetInstanceAddedSignal(arg2):Connect(function(arg1_2) -- Line 45
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:AddContainer(arg1_2)
		end))
		arg1._maid:GiveTask(CollectionService_upvr:GetInstanceRemovedSignal(arg2):Connect(function(arg1_3) -- Line 49
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:RemoveContainer(arg1_3)
		end))
	end
	for _, v_2 in pairs(CollectionService_upvr:GetTagged(arg2)) do
		arg1:AddContainer(v_2)
	end
end
return setmetatable_result1_2_upvr