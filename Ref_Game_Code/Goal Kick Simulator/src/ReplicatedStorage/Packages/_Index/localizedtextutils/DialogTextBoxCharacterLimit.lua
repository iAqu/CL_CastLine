-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:30
-- Luau version 6, Types version 3
-- Time taken: 0.006781 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "DialogTextBoxCharacterLimit"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local var1_result1_upvr = any_load_result1("DialogTemplatesClient")
local any_load_result1_result1_upvr_3 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr = any_load_result1("AccelTween")
local any_load_result1_result1_upvr_6 = any_load_result1("Spring")
local any_load_result1_result1_upvr_5 = any_load_result1("ValueObject")
local any_load_result1_result1_upvr_8 = any_load_result1("StepUtils")
local any_load_result1_result1_upvr_7 = any_load_result1("Blend")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 24
	--[[ Upvalues[9]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: setmetatable_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_3 (readonly)
		[5]: any_load_result1_result1_upvr (readonly)
		[6]: any_load_result1_result1_upvr_6 (readonly)
		[7]: any_load_result1_result1_upvr_5 (readonly)
		[8]: any_load_result1_result1_upvr_8 (readonly)
		[9]: any_load_result1_result1_upvr_7 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_2.new(arg1:GetService(var1_result1_upvr):Clone("DialogTextBoxCharacterLimitTemplate")), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr._guiThemeService = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr_3)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._obj)
	setmetatable_result1_upvr.Gui = setmetatable_result1_upvr._obj
	setmetatable_result1_upvr._textBox = assert(arg2, "No textBox")
	setmetatable_result1_upvr._maxCharacters = 20
	setmetatable_result1_upvr.Invalid = Instance.new("BoolValue")
	setmetatable_result1_upvr.Invalid.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.Invalid)
	setmetatable_result1_upvr._charactersRemainingLabel = setmetatable_result1_upvr._obj.CharactersRemainingLabel
	setmetatable_result1_upvr._charactersRemainingUIScale = setmetatable_result1_upvr._charactersRemainingLabel.UIScale
	setmetatable_result1_upvr._percentOverCharacterLimit = any_load_result1_result1_upvr.new(50)
	setmetatable_result1_upvr._percentOverCharacterLimit.t = 0
	setmetatable_result1_upvr._percentOverCharacterLimit.p = 0
	setmetatable_result1_upvr._percentOverBoop = any_load_result1_result1_upvr_6.new(0)
	setmetatable_result1_upvr._percentOverBoop.d = 0.5
	setmetatable_result1_upvr._percentOverBoop.s = 25
	setmetatable_result1_upvr._percentOverBoop.t = 0
	setmetatable_result1_upvr._percentOverBoop.p = 0
	setmetatable_result1_upvr._shake = any_load_result1_result1_upvr_6.new(0)
	setmetatable_result1_upvr._shake.d = 0.25
	setmetatable_result1_upvr._shake.s = 25
	setmetatable_result1_upvr._shake.t = 0
	setmetatable_result1_upvr._shake.p = 0
	setmetatable_result1_upvr._errorColorValue = any_load_result1_result1_upvr_5.fromObservable(setmetatable_result1_upvr._guiThemeService:ObserveColor("critical", "text"))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._errorColorValue)
	setmetatable_result1_upvr._textColorValue = any_load_result1_result1_upvr_5.fromObservable(setmetatable_result1_upvr._guiThemeService:ObserveColor("text", "subdued_text"))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._textColorValue)
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = any_load_result1_result1_upvr_8.bindToRenderStep(setmetatable_result1_upvr._update)
	setmetatable_result1_upvr._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr._textBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line 69
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateCharacterCount()
	end)
	setmetatable_result1_upvr:_updateCharacterCount()
	setmetatable_result1_upvr._maid:GiveTask(any_load_result1_result1_upvr_7.mount(setmetatable_result1_upvr._charactersRemainingLabel, {
		Font = setmetatable_result1_upvr._guiThemeService:ObserveFont("font");
	}))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._errorColorValue.Changed:Connect(function() -- Line 78
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_startAnimation()
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._textColorValue.Changed:Connect(function() -- Line 81
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_startAnimation()
	end))
	setmetatable_result1_upvr:_startAnimation()
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.SetMaxCharacters(arg1, arg2) -- Line 89
	arg1._maxCharacters = arg2
	arg1:_updateCharacterCount()
end
function setmetatable_result1_upvr_2.GetMaxCharacters(arg1) -- Line 94
	return arg1._maxCharacters
end
local any_load_result1_result1_upvr_9 = any_load_result1("DialogTextBoxUtils")
local any_load_result1_result1_upvr_4 = any_load_result1("DialogTranslator")
function setmetatable_result1_upvr_2._updateCharacterCount(arg1) -- Line 98
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local utf8_len_result1 = utf8.len(any_load_result1_result1_upvr_9.sanitize(arg1._textBox.Text))
	if not utf8_len_result1 then
		arg1.Invalid = true
		arg1._percentOverCharacterLimit.t = 1
		arg1._percentOverBoop:Impulse(25 * (math.random() - 0.5))
	else
		arg1._charactersRemainingLabel.Text = arg1._serviceBag:GetService(any_load_result1_result1_upvr_4):FormatByKey("textbox.characterLimit", {
			chars = utf8_len_result1;
			maxChars = arg1._maxCharacters;
		})
		if arg1._maxCharacters < utf8_len_result1 then
			arg1.Invalid.Value = true
			arg1._percentOverCharacterLimit.t = 1
			arg1._percentOverBoop:Impulse(25 * (math.random() - 0.5))
		else
			arg1.Invalid.Value = false
			arg1._percentOverCharacterLimit.t = 0
		end
		arg1:_startAnimation()
	end
end
function setmetatable_result1_upvr_2.Shake(arg1) -- Line 128
	arg1._percentOverCharacterLimit.p = 1
	local var22 = 25
	arg1._percentOverBoop:Impulse(var22 * (math.random() - 0.5))
	if 0.5 < math.random() then
		var22 = 1
	else
		var22 = -1
	end
	arg1._shake:Impulse(var22 * 10)
	arg1:_startAnimation()
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 135
	arg1._charactersRemainingLabel.TextTransparency = arg2
end
function setmetatable_result1_upvr_2._update(arg1) -- Line 139
	local p = arg1._percentOverBoop.p
	arg1._charactersRemainingLabel.TextColor3 = arg1._textColorValue.Value:Lerp(arg1._errorColorValue.Value, arg1._percentOverCharacterLimit.p)
	arg1._charactersRemainingLabel.Rotation = p * 30
	arg1._charactersRemainingUIScale.Scale = 1 + 0.1 * p
	arg1._charactersRemainingLabel.Position = UDim2.fromScale(0.5, 0.5 + arg1._shake.p)
	local var30 = true
	if 0 >= arg1._percentOverCharacterLimit.rtime then
		var30 = true
		if 0.000001 >= math.abs(arg1._percentOverBoop.v) then
			var30 = true
			if 0.000001 >= math.abs(arg1._percentOverBoop.t - arg1._percentOverBoop.p) then
				var30 = true
				if 0.000001 >= math.abs(arg1._shake.v) then
					if 0.000001 >= math.abs(arg1._shake.t - arg1._shake.p) then
						var30 = false
					else
						var30 = true
					end
				end
			end
		end
	end
	return var30
end
return setmetatable_result1_upvr_2