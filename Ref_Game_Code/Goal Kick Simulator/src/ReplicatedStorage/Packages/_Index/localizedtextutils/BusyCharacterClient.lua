-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:38
-- Luau version 6, Types version 3
-- Time taken: 0.001571 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "BusyCharacterClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("CharacterUtils")
local Players_upvr = game:GetService("Players")
local var1_result1_upvr_5 = any_load_result1("BusyCharacterConstants")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 20
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: Players_upvr (readonly)
		[5]: var1_result1_upvr_5 (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1._serviceBag = assert(arg2, "No serviceBag")
	if var1_result1_upvr.getPlayerFromCharacter(arg1) ~= Players_upvr.LocalPlayer or var1_result1_upvr_5.SHOW_TO_LOCAL_PLAYER then
		setmetatable_result1:_setup()
	end
	return setmetatable_result1
end
local var1_result1_upvr_4 = any_load_result1("promiseChild")
local var1_result1_upvr_6 = any_load_result1("BusySprite")
local var1_result1_upvr_3 = any_load_result1("PlayerGuiUtils")
function setmetatable_result1_upvr._setup(arg1) -- Line 33
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_6 (readonly)
		[3]: var1_result1_upvr_3 (readonly)
	]]
	arg1._maid:GivePromise(var1_result1_upvr_4(arg1._obj, "Head")):Then(function(arg1_2) -- Line 34
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_6 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: var1_result1_upvr_3 (copied, readonly)
		]]
		local any_new_result1_upvr = var1_result1_upvr_6.new(arg1._serviceBag)
		any_new_result1_upvr.Gui.Adornee = arg1_2
		any_new_result1_upvr.Gui.Parent = var1_result1_upvr_3.getPlayerGui()
		any_new_result1_upvr:Show()
		arg1._maid:GiveTask(function() -- Line 40
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr:Finish(function() -- Line 41
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (copied, readonly)
				]]
				any_new_result1_upvr:Destroy()
			end)
		end)
	end)
end
return setmetatable_result1_upvr