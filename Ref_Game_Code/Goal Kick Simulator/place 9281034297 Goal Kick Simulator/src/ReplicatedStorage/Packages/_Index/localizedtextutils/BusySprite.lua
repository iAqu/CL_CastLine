-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:36
-- Luau version 6, Types version 3
-- Time taken: 0.002711 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BasicPane")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "BusySprite"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local var1_result1_upvr = any_load_result1("BusyCharacterTemplatesClient")
local var1_result1_upvr_3 = any_load_result1("AnimatedSpriteProvider")
local var1_result1_upvr_5 = any_load_result1("GuiThemeService")
local var1_result1_upvr_6 = any_load_result1("Spring")
function setmetatable_result1_upvr_2.new(arg1) -- Line 20
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: setmetatable_result1_upvr_2 (readonly)
		[4]: var1_result1_upvr_3 (readonly)
		[5]: var1_result1_upvr_5 (readonly)
		[6]: var1_result1_upvr_6 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_2.new(arg1:GetService(var1_result1_upvr):Clone("BusySpriteTemplate")), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._animatedSpriteProvider = arg1:GetService(var1_result1_upvr_3)
	setmetatable_result1_upvr._guiThemeService = arg1:GetService(var1_result1_upvr_5)
	setmetatable_result1_upvr._imageLabel = setmetatable_result1_upvr.Gui.ImageLabel
	setmetatable_result1_upvr._percentVisible = var1_result1_upvr_6.new(0)
	setmetatable_result1_upvr._percentVisible.Speed = 15
	setmetatable_result1_upvr._percentVisible.Damper = 1
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.VisibleChanged:Connect(function(...) -- Line 34
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_handleVisibleChanged(...)
	end))
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.Finish(arg1, arg2) -- Line 41
	arg1:Hide()
	task.delay(1, function() -- Line 44
		--[[ Upvalues[1]:
			[1]: arg2 (readonly)
		]]
		arg2()
	end)
end
local var1_result1_upvr_4 = any_load_result1("AnimatedSpritesheetPlayer")
function setmetatable_result1_upvr_2._handleVisibleChanged(arg1, arg2, arg3, arg4) -- Line 49
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_4 (readonly)
	]]
	local var12
	if arg2 then
		var12 = 1
	else
		var12 = 0
	end
	arg1._percentVisible.t = var12
	if arg3 then
		var12 = arg1._percentVisible.t
		arg1._percentVisible.p = var12
	end
	arg1:_startAnimation()
	if not arg2 then
	else
		var12 = var1_result1_upvr_4
		var12 = arg1._imageLabel
		local any_new_result1_upvr = var12.new(var12)
		var12 = arg4:GiveTask
		var12(any_new_result1_upvr)
		var12 = any_new_result1_upvr:SetSheet
		var12(arg1:_getSheet())
		var12 = arg4:GiveTask
		var12(arg1._guiThemeService:GetPreferredThemeNameValue().Changed:Connect(function() -- Line 66
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr (readonly)
				[2]: arg1 (readonly)
			]]
			any_new_result1_upvr:SetSheet(arg1:_getSheet())
		end))
	end
end
function setmetatable_result1_upvr_2._getSheet(arg1) -- Line 71
	return arg1._animatedSpriteProvider:GetAnimatedSprite("BusyChatSheet"..arg1._guiThemeService:GetPreferredThemeName())
end
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_upvr_2._startAnimation(arg1) -- Line 75
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if arg1._maid._update and arg1._maid._update.Connected then
	else
		if arg1:_update() then
			arg1._maid._update = nil
			return
		end
		arg1._maid._update = RunService_upvr.RenderStepped:Connect(function() -- Line 85
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1:_update() then
				arg1._maid._update = nil
			end
		end)
	end
end
function setmetatable_result1_upvr_2._update(arg1) -- Line 92
	local var17 = false
	local var18
	if arg1._percentVisible.Velocity <= 0.000001 then
		if math.abs(arg1._percentVisible.Position - arg1._percentVisible.Target) > 0.000001 then
			var17 = false
		else
			var17 = true
		end
	end
	if var17 then
		var18 = arg1._percentVisible.t
	end
	arg1._imageLabel.Size = UDim2.fromScale(var18, var18)
	arg1._imageLabel.ImageTransparency = 1 - var18
	return var17
end
return setmetatable_result1_upvr_2