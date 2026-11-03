-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:58
-- Luau version 6, Types version 3
-- Time taken: 0.002523 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_upvr.ClassName = "ResizeOnInput"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr_4 = any_load_result1("Spring")
local var1_result1_upvr_2 = any_load_result1("ResizeOnInputTracker")
local var1_result1_upvr_3 = any_load_result1("StepUtils")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 16
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr_4 (readonly)
		[4]: var1_result1_upvr_2 (readonly)
		[5]: var1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr.new(arg1), setmetatable_result1_upvr)
	local var8 = arg1
	if not var8 then
		var8 = error("No image")
	end
	setmetatable_result1_upvr_2._image = var8
	setmetatable_result1_upvr_2._uiScale = Instance.new("UIScale")
	setmetatable_result1_upvr_2._uiScale.Scale = 1
	setmetatable_result1_upvr_2._uiScale.Parent = arg1
	setmetatable_result1_upvr_2._percentActive = var1_result1_upvr_4.new(0)
	setmetatable_result1_upvr_2._percentActive.Speed = 30
	setmetatable_result1_upvr_2._percentActive.Damper = 0.5
	setmetatable_result1_upvr_2._tracker = var1_result1_upvr_2.new(arg2)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._tracker)
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = var1_result1_upvr_3.bindToRenderStep(setmetatable_result1_upvr_2._update)
	setmetatable_result1_upvr_2._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr_2._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._tracker.IsActive.Changed:Connect(function() -- Line 34
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateVisible()
	end))
	setmetatable_result1_upvr_2:_updateVisible()
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr._updateVisible(arg1) -- Line 42
	if arg1._tracker.IsActive.Value then
		arg1._percentActive.t = 1
	else
		arg1._percentActive.t = 0
	end
	arg1:_startAnimation()
end
function setmetatable_result1_upvr._update(arg1) -- Line 52
	local var12 = true
	local var13
	if 0.000001 >= arg1._percentActive.Velocity then
		if 0.000001 >= math.abs(arg1._percentActive.Position - arg1._percentActive.Target) then
			var12 = false
		else
			var12 = true
		end
	end
	if not var12 then
		var13 = arg1._percentActive.Target
	end
	arg1._uiScale.Scale = 1 - 0.2 * var13
	return var12
end
return setmetatable_result1_upvr