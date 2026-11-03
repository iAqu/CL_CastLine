-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:51
-- Luau version 6, Types version 3
-- Time taken: 0.008883 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_7 = any_load_result1("BasicPane")
local var1_result1_upvr_2 = any_load_result1("Math")
local var1_result1_upvr = any_load_result1("Blend")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_7)
setmetatable_result1_upvr_2.ClassName = "HairLines"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local var1_result1_upvr_4 = any_load_result1("AccelTween")
local var1_result1_upvr_8 = any_load_result1("ReticleHair")
function setmetatable_result1_upvr_2.new(arg1, arg2, arg3, arg4) -- Line 31
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_4 (readonly)
		[4]: var1_result1_upvr_2 (readonly)
		[5]: var1_result1_upvr_8 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_7.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr:_render():Subscribe(function(arg1_2) -- Line 34
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.Gui = arg1_2
	end))
	setmetatable_result1_upvr._percentVisible = var1_result1_upvr_4.new(20)
	setmetatable_result1_upvr._percentVisible.t = 0
	setmetatable_result1_upvr._percentVisible.p = 0
	setmetatable_result1_upvr._transparency = 0
	setmetatable_result1_upvr._width = 0.2
	setmetatable_result1_upvr._length = 0.5
	setmetatable_result1_upvr._scalingDistance = 0.5
	setmetatable_result1_upvr._hairs = {}
	for i = 1, arg4 do
		setmetatable_result1_upvr:_addHair(var1_result1_upvr_8.new(arg1, var1_result1_upvr_2.map(i, 1, arg4, arg2, arg3)))
	end
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.VisibleChanged:Connect(function(arg1_3, arg2_2) -- Line 54
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		local var13 = setmetatable_result1_upvr
		if arg1_3 then
			var13 = 1
		else
			var13 = 0
		end
		var13._percentVisible.t = var13
		if arg2_2 then
			setmetatable_result1_upvr._percentVisible.p = setmetatable_result1_upvr._percentVisible.t
		end
		setmetatable_result1_upvr:_startAnimation()
	end))
	setmetatable_result1_upvr:_startAnimation()
	return setmetatable_result1_upvr
end
local var1_result1_upvr_5 = any_load_result1("Observable")
local var1_result1_upvr_6 = any_load_result1("Maid")
local var1_result1_upvr_3 = any_load_result1("Brio")
function setmetatable_result1_upvr_2.renderOnEmitParent(arg1, arg2, arg3) -- Line 77
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_5 (readonly)
		[3]: var1_result1_upvr_6 (readonly)
		[4]: setmetatable_result1_upvr_2 (readonly)
		[5]: var1_result1_upvr_3 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var19 = arg1
	assert(var19, "No serviceBag")
	if type(arg2.StartDegrees) ~= "number" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad props.StartDegrees")
	if type(arg2.EndDegrees) ~= "number" then
		var19 = false
		-- KONSTANTWARNING: GOTO [33] #24
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [32] 23. Error Block 22 start (CF ANALYSIS FAILED)
	var19 = true
	assert(var19, "Bad props.EndDegrees")
	if type(arg2.LineCount) ~= "number" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad props.LineCount")
	var19 = var1_result1_upvr
	var19 = arg3
	local any_toEventObservable_result1_upvw = var19.toEventObservable(var19)
	var19 = any_toEventObservable_result1_upvw
	assert(var19, "No source")
	var19 = var1_result1_upvr_5
	function var19(arg1_4) -- Line 86
		--[[ Upvalues[7]:
			[1]: var1_result1_upvr_6 (copied, readonly)
			[2]: any_toEventObservable_result1_upvw (read and write)
			[3]: setmetatable_result1_upvr_2 (copied, readonly)
			[4]: arg1 (readonly)
			[5]: arg2 (readonly)
			[6]: var1_result1_upvr (copied, readonly)
			[7]: var1_result1_upvr_3 (copied, readonly)
		]]
		local any_new_result1_2_upvr = var1_result1_upvr_6.new()
		any_new_result1_2_upvr:GiveTask(any_toEventObservable_result1_upvw:Subscribe(function() -- Line 89
			--[[ Upvalues[8]:
				[1]: any_new_result1_2_upvr (readonly)
				[2]: var1_result1_upvr_6 (copied, readonly)
				[3]: setmetatable_result1_upvr_2 (copied, readonly)
				[4]: arg1 (copied, readonly)
				[5]: arg2 (copied, readonly)
				[6]: var1_result1_upvr (copied, readonly)
				[7]: var1_result1_upvr_3 (copied, readonly)
				[8]: arg1_4 (readonly)
			]]
			any_new_result1_2_upvr._current = nil
			local any_new_result1_upvr = var1_result1_upvr_6.new()
			local any_new_result1_upvr_2 = setmetatable_result1_upvr_2.new(arg1, arg2.StartDegrees, arg2.EndDegrees, arg2.LineCount)
			any_new_result1_upvr:GiveTask(any_new_result1_upvr_2)
			local any_toPropertyObservable_result1 = var1_result1_upvr.toPropertyObservable(arg2.LineColor)
			if any_toPropertyObservable_result1 then
				any_new_result1_upvr:GiveTask(any_toPropertyObservable_result1:Subscribe(function(arg1_5) -- Line 98
					--[[ Upvalues[1]:
						[1]: any_new_result1_upvr_2 (readonly)
					]]
					any_new_result1_upvr_2:SetColor(arg1_5)
				end))
			end
			local any_toNumberObservable_result1_2 = var1_result1_upvr.toNumberObservable(arg2.LineWidth or 0.4)
			if any_toNumberObservable_result1_2 then
				any_new_result1_upvr:GiveTask(any_toNumberObservable_result1_2:Subscribe(function(arg1_6) -- Line 105
					--[[ Upvalues[1]:
						[1]: any_new_result1_upvr_2 (readonly)
					]]
					any_new_result1_upvr_2:SetWidth(arg1_6)
				end))
			end
			local any_toNumberObservable_result1 = var1_result1_upvr.toNumberObservable(arg2.LineLength)
			if any_toNumberObservable_result1 then
				any_new_result1_upvr:GiveTask(any_toNumberObservable_result1:Subscribe(function(arg1_7) -- Line 112
					--[[ Upvalues[1]:
						[1]: any_new_result1_upvr_2 (readonly)
					]]
					any_new_result1_upvr_2:SetLength(arg1_7)
				end))
			end
			local any_toNumberObservable_result1_3 = var1_result1_upvr.toNumberObservable(arg2.Transparency)
			if any_toNumberObservable_result1_3 then
				any_new_result1_upvr:GiveTask(any_toNumberObservable_result1_3:Subscribe(function(arg1_8) -- Line 119
					--[[ Upvalues[1]:
						[1]: any_new_result1_upvr_2 (readonly)
					]]
					any_new_result1_upvr_2:SetTransparency(arg1_8)
				end))
			end
			any_new_result1_upvr:GiveTask(var1_result1_upvr.mount(any_new_result1_upvr_2.Gui, {
				AnchorPoint = arg2.AnchorPoint;
				Position = arg2.Position;
				Size = arg2.Size;
			}))
			local any_new_result1 = var1_result1_upvr_3.new(any_new_result1_upvr_2.Gui)
			any_new_result1_upvr:GiveTask(any_new_result1)
			if arg2.Debug then
				any_new_result1_upvr_2.Gui.BackgroundTransparency = 0.5
			end
			arg1_4:Fire(any_new_result1)
			any_new_result1_upvr_2:Play(function() -- Line 139
				--[[ Upvalues[2]:
					[1]: any_new_result1_2_upvr (copied, readonly)
					[2]: any_new_result1_upvr (readonly)
				]]
				if any_new_result1_2_upvr._current == any_new_result1_upvr then
					any_new_result1_2_upvr._current = nil
				end
			end)
			any_new_result1_2_upvr._current = any_new_result1_upvr
		end))
		return any_new_result1_2_upvr
	end
	do
		return var19.new(var19)
	end
	-- KONSTANTERROR: [32] 23. Error Block 22 end (CF ANALYSIS FAILED)
end
function setmetatable_result1_upvr_2.SetWidth(arg1, arg2) -- Line 156
	local var35
	if type(arg2) ~= "number" then
		var35 = false
	else
		var35 = true
	end
	assert(var35, "Bad width")
	arg1._width = arg2
end
function setmetatable_result1_upvr_2.SetLength(arg1, arg2) -- Line 165
	local var36
	if type(arg2) ~= "number" then
		var36 = false
	else
		var36 = true
	end
	assert(var36, "Bad length")
	arg1._length = arg2
end
function setmetatable_result1_upvr_2.SetScalingDistance(arg1, arg2) -- Line 174
	local var37
	if type(arg2) ~= "number" then
		var37 = false
	else
		var37 = true
	end
	assert(var37, "Bad scalingDistance")
	arg1._scalingDistance = arg2
end
function setmetatable_result1_upvr_2.SetColor(arg1, arg2) -- Line 183
	local var42
	if typeof(arg2) ~= "Color3" then
		var42 = false
	else
		var42 = true
	end
	assert(var42, "Bad color")
	var42 = arg1._hairs
	for _, v in pairs(var42) do
		v.hair:SetColor(arg2)
	end
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 195
	local var46
	if type(arg2) ~= "number" then
		var46 = false
	else
		var46 = true
	end
	assert(var46, "Bad transparency")
	arg1._transparency = arg2
	arg1:_startAnimation()
end
function setmetatable_result1_upvr_2.Play(arg1, arg2) -- Line 206
	arg1:Show()
	task.delay(arg1._percentVisible.rtime + 0.1, function() -- Line 208
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		if not arg1.Destroy then
		else
			arg2()
		end
	end)
end
function setmetatable_result1_upvr_2._addHair(arg1, arg2) -- Line 217
	arg2.Gui.Parent = arg1.Gui
	arg1._maid:GiveTask(arg2)
	local tbl = {}
	tbl.hair = arg2
	tbl.rotation = arg2:GetRotation()
	table.insert(arg1._hairs, tbl)
end
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_upvr_2._startAnimation(arg1) -- Line 226
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if arg1._maid._update and arg1._maid._update.Connected then
	else
		if arg1:_update() then
			arg1._maid._update = nil
			return
		end
		arg1._maid._update = RunService_upvr.RenderStepped:Connect(function() -- Line 236
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1:_update() then
				arg1._maid._update = nil
			end
		end)
	end
end
function setmetatable_result1_upvr_2._update(arg1) -- Line 243
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local p = arg1._percentVisible.p
	local sine = math.sin(p * math.pi)
	local any_map_result1 = var1_result1_upvr_2.map(sine, 0, 1, 1, arg1._transparency)
	local _, pairs_result2, pairs_result3 = pairs(arg1._hairs)
	local var61
	for _, v_2 in var61, pairs_result2, pairs_result3 do
		v_2.hair:SetDistance(1 + arg1._scalingDistance * p + arg1._length * p)
		v_2.hair:SetLength(arg1._length * sine)
		v_2.hair:SetTransparency(any_map_result1)
		v_2.hair:SetWidth(arg1._width * sine)
	end
	var61 = false
	if arg1._percentVisible.rtime == 0 then
		if arg1._percentVisible.t ~= 0 then
			var61 = false
		else
			var61 = true
		end
	end
	return var61
end
function setmetatable_result1_upvr_2._render(arg1) -- Line 260
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr.New("Frame")({
		Name = "HairLines";
		Position = UDim2.fromScale(0.5, 0.5);
		AnchorPoint = Vector2.new(0.5, 0.5);
		Size = UDim2.fromScale(1, 1);
		BackgroundColor3 = Color3.fromRGB(2, 138, 123);
		BackgroundTransparency = 1;
		BorderColor3 = Color3.fromRGB(27, 42, 53);
		BorderSizePixel = 1;
		[var1_result1_upvr.Children] = {var1_result1_upvr.New("UIAspectRatioConstraint")({
			AspectRatio = 1;
		})};
	})
end
return setmetatable_result1_upvr_2