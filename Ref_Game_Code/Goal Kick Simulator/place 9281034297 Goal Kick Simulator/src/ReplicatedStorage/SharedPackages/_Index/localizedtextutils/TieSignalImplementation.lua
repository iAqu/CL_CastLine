-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:04
-- Luau version 6, Types version 3
-- Time taken: 0.001371 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("BaseObject")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_3)
setmetatable_result1_upvr_2.ClassName = "TieSignalImplementation"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
function setmetatable_result1_upvr_2.new(arg1, arg2, arg3) -- Line 15
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_3.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._memberDefinition = assert(arg1, "No memberDefinition")
	setmetatable_result1_upvr._folder = assert(arg2, "No folder")
	setmetatable_result1_upvr._bindableEvent = Instance.new("BindableEvent")
	setmetatable_result1_upvr._bindableEvent.Archivable = false
	setmetatable_result1_upvr._bindableEvent.Name = arg1:GetMemberName()
	setmetatable_result1_upvr._bindableEvent.Parent = setmetatable_result1_upvr._folder
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._bindableEvent)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._bindableEvent.Event:Connect(function() -- Line 29
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr._thisIsUsFiring = false
	end))
	setmetatable_result1_upvr:SetImplementation(arg3)
	return setmetatable_result1_upvr
end
local var1_result1_upvr = any_load_result1("Maid")
local var1_result1_upvr_2 = any_load_result1("TieUtils")
function setmetatable_result1_upvr_2.SetImplementation(arg1, arg2) -- Line 38
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1 = var1_result1_upvr.new()
	if type(arg2) == "table" then
		any_new_result1:GiveTask(arg2:Connect(function(...) -- Line 42
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: var1_result1_upvr_2 (copied, readonly)
			]]
			arg1._thisIsUsFiring = true
			arg1._bindableEvent:Fire(var1_result1_upvr_2.encode(...))
		end))
		any_new_result1:GiveTask(arg1._bindableEvent.Event:Connect(function(...) -- Line 48
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
				[3]: var1_result1_upvr_2 (copied, readonly)
			]]
			if not arg1._thisIsUsFiring then
				arg2:Fire(var1_result1_upvr_2.decode(...))
			end
		end))
	end
	arg1._maid._implementationMaid = any_new_result1
end
return setmetatable_result1_upvr_2