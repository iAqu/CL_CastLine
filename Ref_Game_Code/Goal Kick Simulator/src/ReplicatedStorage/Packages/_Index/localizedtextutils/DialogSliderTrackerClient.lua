-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:32
-- Luau version 6, Types version 3
-- Time taken: 0.002617 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "DialogSliderTrackerClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("DialogBindersClient")
local var1_result1_upvr_4 = any_load_result1("promiseBoundClass")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 16
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_2.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg2, "No serviceBag")
	setmetatable_result1_upvr_2._dialogBindersClient = setmetatable_result1_upvr_2._serviceBag:GetService(var1_result1_upvr)
	setmetatable_result1_upvr_2._promiseDialogSession = var1_result1_upvr_4(setmetatable_result1_upvr_2._dialogBindersClient.DialogSession, setmetatable_result1_upvr_2._obj.Parent)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._promiseDialogSession)
	setmetatable_result1_upvr_2._promiseDialogSession:Then(function(arg1_2) -- Line 25
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		local var8 = arg1_2
		if not var8 then
			var8 = error("No dialogSession")
		end
		setmetatable_result1_upvr_2._dialogSession = var8
		setmetatable_result1_upvr_2:_setup()
	end)
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr._setup(arg1) -- Line 33
	arg1._maid:GiveTask(arg1._dialogSession.CurrentSlider.Changed:Connect(function() -- Line 34
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_updateCurrentSlider()
	end))
	arg1:_updateCurrentSlider()
end
local var1_result1_upvr_3 = any_load_result1("Maid")
function setmetatable_result1_upvr._updateCurrentSlider(arg1) -- Line 41
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	local any__getValidSlider_result1 = arg1:_getValidSlider()
	if not any__getValidSlider_result1 then
		arg1._maid._track = nil
	else
		local any_new_result1 = var1_result1_upvr_3.new()
		any_new_result1:GiveTask(any__getValidSlider_result1.SelectionChanged:Connect(function(arg1_3) -- Line 49
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			local var14
			if type(arg1_3) ~= "table" then
				var14 = false
			else
				var14 = true
			end
			assert(var14, "Bad sliderResult")
			var14 = arg1
			var14._obj:FireServer(arg1_3)
		end))
		arg1._maid._track = any_new_result1
	end
end
function setmetatable_result1_upvr._getValidSlider(arg1) -- Line 57
	local Value = arg1._dialogSession.CurrentSlider.Value
	local var16
	if not Value then
		return nil
	end
	local key = Value:GetSliderOptions().key
	if type(key) ~= "string" then
		var16 = false
	else
		var16 = true
	end
	assert(var16, "Bad key")
	var16 = arg1._obj
	if key == var16.Name then
		return Value
	end
	return nil
end
return setmetatable_result1_upvr