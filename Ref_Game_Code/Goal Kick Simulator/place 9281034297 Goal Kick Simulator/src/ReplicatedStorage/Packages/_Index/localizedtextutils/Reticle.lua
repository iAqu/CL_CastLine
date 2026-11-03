-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:48
-- Luau version 6, Types version 3
-- Time taken: 0.011709 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("BasicPane")
local tbl_upvr = {0, 120, 240}
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_3)
setmetatable_result1_upvr_2.ClassName = "Reticle"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local var1_result1_upvr_3 = any_load_result1("PillBackingBuilder")
local any_load_result1_result1_upvr = any_load_result1("AccelTween")
local any_load_result1_result1_upvr_5 = any_load_result1("Spring")
local any_load_result1_result1_upvr_4 = any_load_result1("StepUtils")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 38
	--[[ Upvalues[7]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: any_load_result1_result1_upvr_5 (readonly)
		[6]: any_load_result1_result1_upvr_4 (readonly)
		[7]: tbl_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_3.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr:_render():Subscribe(function(arg1_2) -- Line 43
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.Gui = arg1_2
	end))
	setmetatable_result1_upvr._hairContainer = setmetatable_result1_upvr.Gui.HairContainer
	setmetatable_result1_upvr._center = setmetatable_result1_upvr.Gui.Center
	setmetatable_result1_upvr._color = Instance.new("Color3Value")
	setmetatable_result1_upvr._color.Value = Color3.new(1, 1, 1)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._color)
	setmetatable_result1_upvr._circle = var1_result1_upvr_3.new():CreateCircle(setmetatable_result1_upvr._center)
	setmetatable_result1_upvr._lastRenderedTransparency = 0
	setmetatable_result1_upvr._transparency = 0
	setmetatable_result1_upvr._baseWidth = 0.15
	setmetatable_result1_upvr._baseLength = 0.3
	setmetatable_result1_upvr._percentVisible = any_load_result1_result1_upvr.new(35)
	setmetatable_result1_upvr._percentVisible.t = 0
	setmetatable_result1_upvr._percentVisible.p = 0
	setmetatable_result1_upvr._distSpring = any_load_result1_result1_upvr_5.new()
	setmetatable_result1_upvr._distSpring.t = 0
	setmetatable_result1_upvr._distSpring.p = 0
	setmetatable_result1_upvr._distSpring.s = 35
	setmetatable_result1_upvr._distSpring.d = 0.75
	setmetatable_result1_upvr._lengthSpring = any_load_result1_result1_upvr_5.new()
	setmetatable_result1_upvr._lengthSpring.t = 0
	setmetatable_result1_upvr._lengthSpring.p = 0
	setmetatable_result1_upvr._lengthSpring.s = 35
	setmetatable_result1_upvr._lengthSpring.d = 1
	setmetatable_result1_upvr._hairData = {}
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = any_load_result1_result1_upvr_4.bindToRenderStep(setmetatable_result1_upvr._update)
	setmetatable_result1_upvr._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.VisibleChanged:Connect(function(arg1_3, arg2_2) -- Line 80
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		local var14 = setmetatable_result1_upvr
		if arg1_3 then
			var14 = 1
		else
			var14 = 0
		end
		var14._percentVisible.t = var14
		if arg2_2 then
			setmetatable_result1_upvr._percentVisible.p = setmetatable_result1_upvr._percentVisible.t
		end
		setmetatable_result1_upvr:_startAnimation()
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._color.Changed:Connect(function() -- Line 89
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateColor()
	end))
	local var16 = arg2
	if not var16 then
		var16 = tbl_upvr
	end
	setmetatable_result1_upvr:SetHairsFromRotationDegrees(var16)
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.SetColor(arg1, arg2) -- Line 98
	arg1._color.Value = arg2
end
function setmetatable_result1_upvr_2.SetCircleSize(arg1, arg2) -- Line 102
	local var17
	if type(arg2) ~= "number" then
		var17 = false
	else
		var17 = true
	end
	assert(var17, "Bad circleSize")
	var17 = UDim2.new(arg2, 0, arg2, 0)
	arg1._center.Size = var17
end
function setmetatable_result1_upvr_2.SetBaseWidth(arg1, arg2) -- Line 112
	local var18
	if type(arg2) ~= "number" then
		var18 = false
	else
		var18 = true
	end
	assert(var18, "Bad baseWidth")
	arg1._baseWidth = arg2
	arg1:_startAnimation()
end
function setmetatable_result1_upvr_2.SetBaseLength(arg1, arg2) -- Line 123
	local var19
	if type(arg2) ~= "number" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad baseLength")
	arg1._baseLength = arg2
	arg1:_startAnimation()
end
function setmetatable_result1_upvr_2.SetCenterDotVisible(arg1, arg2) -- Line 134
	arg1._circle.Visible = arg2
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 142
	local var20
	if type(arg2) ~= "number" then
		var20 = false
	else
		var20 = true
	end
	assert(var20, "Bad transparency")
	arg1._transparency = arg2
	arg1:_startAnimation()
end
function setmetatable_result1_upvr_2.ImpulseDistance(arg1, arg2) -- Line 153
	arg1._distSpring.v = arg1._distSpring.v + arg1._distSpring.s * (arg2 or 1)
	arg1:_startAnimation()
end
function setmetatable_result1_upvr_2.ImpulseLength(arg1, arg2) -- Line 165
	arg1._lengthSpring.v = arg1._lengthSpring.v + arg1._lengthSpring.s * (arg2 or 1)
	arg1:_startAnimation()
end
function setmetatable_result1_upvr_2.GetRemainingAnimationTime(arg1) -- Line 178
	return arg1._percentVisible.rtime
end
local var1_result1_upvr_4 = any_load_result1("ReticleHair")
function setmetatable_result1_upvr_2.SetHairsFromRotationDegrees(arg1, arg2) -- Line 187
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_4 (readonly)
	]]
	local var24
	if type(arg2) ~= "table" then
		var24 = false
	else
		var24 = true
	end
	assert(var24, "Bad rotations")
	var24 = 1
	for i = 1, #arg2, var24 do
		if not arg1._hairData[i] then
			arg1:_addHair(i, var1_result1_upvr_4.new(arg1._serviceBag, arg2[i]))
		end
		arg1._hairData[i].rotation = arg2[i]
	end
	while true do
		var24 = arg1._hairData
		var24 = #arg2
		if var24 >= #var24 then break end
		arg1:_popHair()
	end
	arg1:_startAnimation()
end
function setmetatable_result1_upvr_2._updateTransparency(arg1, arg2) -- Line 205
	local var29
	if type(arg2) ~= "number" then
		var29 = false
	else
		var29 = true
	end
	assert(var29, "Bad transparency")
	arg1._lastRenderedTransparency = arg2
	arg1._circle.ImageTransparency = arg2
	var29 = arg1._hairData
	for _, v in pairs(var29) do
		v.hair:SetTransparency(arg2)
	end
end
function setmetatable_result1_upvr_2._addHair(arg1, arg2, arg3) -- Line 215
	assert(not arg1._hairData[arg2], "Already have hair")
	arg3:SetTransparency(arg1._lastRenderedTransparency)
	arg3:SetColor(arg1._color.Value)
	arg3.Gui.Parent = arg1._hairContainer
	arg1._maid[arg3] = nil
	local tbl = {}
	tbl.hair = arg3
	tbl.rotation = arg3:GetRotation()
	arg1._hairData[arg2] = tbl
end
function setmetatable_result1_upvr_2._popHair(arg1) -- Line 229
	local popped = table.remove(arg1._hairData)
	if popped then
		arg1._maid[popped.hair] = nil
	end
end
local var1_result1_upvr = any_load_result1("SpringUtils")
local any_load_result1_result1_upvr_2 = any_load_result1("Math")
function setmetatable_result1_upvr_2._update(arg1) -- Line 236
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local p = arg1._percentVisible.p
	local any_animating_result1_5, any_animating_result2_6 = var1_result1_upvr.animating(arg1._distSpring)
	local any_animating_result1_3, any_animating_result2 = var1_result1_upvr.animating(arg1._lengthSpring)
	arg1:_updateTransparency(any_load_result1_result1_upvr_2.map(p, 0, 1, 1, arg1._transparency))
	local clamped_3 = math.clamp(math.abs(arg1._percentVisible.v) / 3, 0, 1)
	local var79 = (1 - p) * 180
	local var80 = 1 + p * 0.1 * math.sin(tick() * 2 * math.pi / 0.5) + any_animating_result2_6
	local pairs_result1_2, pairs_result2_3, pairs_result3_2 = pairs(arg1._hairData)
	for _, v_2 in pairs_result1_2, pairs_result2_3, pairs_result3_2 do
		v_2.hair:SetDistance(var80 * (0.5 + 0.25 * (1 - p)))
		v_2.hair:SetLength((arg1._baseLength + any_animating_result2) * (clamped_3 * 0.3333333333333333 + 1))
		v_2.hair:SetWidth(arg1._baseWidth - arg1._baseWidth / 3 * clamped_3)
		v_2.hair:SetRotation(v_2.rotation + var79)
	end
	pairs_result1_2 = true
	local var84 = pairs_result1_2
	if 0 >= arg1._percentVisible.rtime then
		var84 = true
		if arg1._percentVisible.t == 0 then
			var84 = any_animating_result1_5
			if not var84 then
				var84 = any_animating_result1_3
			end
		end
	end
	return var84
end
function setmetatable_result1_upvr_2._updateColor(arg1) -- Line 262
	local Value = arg1._color.Value
	arg1._circle.ImageColor3 = Value
	for _, v_3 in pairs(arg1._hairData) do
		v_3.hair:SetColor(Value)
	end
end
local var1_result1_upvr_2 = any_load_result1("Blend")
function setmetatable_result1_upvr_2._render(arg1) -- Line 272
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_2.New("Frame")({
		Name = "ReticleTemplate";
		Position = UDim2.fromScale(0.5, 0.5);
		AnchorPoint = Vector2.new(0.5, 0.5);
		Size = UDim2.fromScale(0.1, 0.1);
		BackgroundTransparency = 1;
		BorderColor3 = Color3.fromRGB(27, 42, 53);
		[var1_result1_upvr_2.Children] = {var1_result1_upvr_2.New("UIAspectRatioConstraint")({
			AspectRatio = 1;
			DominantAxis = Enum.DominantAxis.Height;
		}), var1_result1_upvr_2.New("UISizeConstraint")({
			MinSize = Vector2.new(40, 40);
		}), var1_result1_upvr_2.New("Frame")({
			Name = "Center";
			Position = UDim2.fromScale(0.5, 0.5);
			AnchorPoint = Vector2.new(0.5, 0.5);
			Size = UDim2.fromScale(0.1, 0.1);
			BorderColor3 = Color3.fromRGB(27, 42, 53);
		}), var1_result1_upvr_2.New("Frame")({
			Name = "HairContainer";
			Size = UDim2.fromScale(1, 1);
			BackgroundTransparency = 1;
			BorderColor3 = Color3.fromRGB(27, 42, 53);
			BorderSizePixel = 1;
		})};
	})
end
return setmetatable_result1_upvr_2