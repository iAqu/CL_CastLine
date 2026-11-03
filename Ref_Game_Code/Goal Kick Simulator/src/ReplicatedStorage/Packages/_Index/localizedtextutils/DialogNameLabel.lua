-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:57
-- Luau version 6, Types version 3
-- Time taken: 0.005146 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("BaseObject")
local any_load_result1_result1_upvr = any_load_result1("DialogConstants")
local var1_result1_upvr = any_load_result1("PillBackingBuilder")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_3)
setmetatable_result1_upvr_2.ClassName = "DialogNameLabel"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local any_load_result1_result1_upvr_2 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr_8 = any_load_result1("ValueObject")
local any_load_result1_result1_upvr_6 = any_load_result1("Blend")
local any_load_result1_result1_upvr_5 = any_load_result1("TextServiceUtils")
local any_load_result1_result1_upvr_10 = any_load_result1("Rx")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 23
	--[[ Upvalues[9]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_8 (readonly)
		[5]: var1_result1_upvr (readonly)
		[6]: any_load_result1_result1_upvr (readonly)
		[7]: any_load_result1_result1_upvr_6 (readonly)
		[8]: any_load_result1_result1_upvr_5 (readonly)
		[9]: any_load_result1_result1_upvr_10 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_3.new(arg2), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr._guiThemeService = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr_2)
	setmetatable_result1_upvr._textLabel = setmetatable_result1_upvr._obj.DialogNameTextLabel
	setmetatable_result1_upvr._textValue = any_load_result1_result1_upvr_8.new(nil)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._textValue)
	local any_new_result1 = var1_result1_upvr.new()
	setmetatable_result1_upvr._backing = any_new_result1:CreateSingle(setmetatable_result1_upvr._obj)
	setmetatable_result1_upvr._shadow = any_new_result1:CreateShadow(setmetatable_result1_upvr._obj)
	setmetatable_result1_upvr:SetText(nil)
	setmetatable_result1_upvr:SetAccentColor(any_load_result1_result1_upvr.DEFAULT_ACCENT_COLOR)
	local any_ObserveFont_result1 = setmetatable_result1_upvr._guiThemeService:ObserveFont("title")
	local any_Computed_result1 = any_load_result1_result1_upvr_6.Computed(setmetatable_result1_upvr._textValue, function(arg1_2) -- Line 42
		local var15
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var15 = arg1_2
			return var15
		end
		if type(arg1_2) ~= "string" or not INLINED() then
			var15 = ""
		end
		return var15
	end)
	setmetatable_result1_upvr._maid:GiveTask(any_load_result1_result1_upvr_6.mount(setmetatable_result1_upvr._textLabel, {
		Font = any_ObserveFont_result1;
		Text = any_Computed_result1;
	}))
	setmetatable_result1_upvr._maid:GiveTask(any_load_result1_result1_upvr_6.mount(setmetatable_result1_upvr._obj, {
		Size = any_load_result1_result1_upvr_5.observeSizeForLabelProps({
			Font = any_ObserveFont_result1;
			Text = any_Computed_result1;
			TextSize = setmetatable_result1_upvr._textLabel.TextSize;
		}):Pipe({any_load_result1_result1_upvr_10.map(function(arg1_3) -- Line 57
			--[[ Upvalues[1]:
				[1]: setmetatable_result1_upvr (readonly)
			]]
			return UDim2.new(UDim.new(0, setmetatable_result1_upvr._obj.Size.Y.Offset + arg1_3.x), setmetatable_result1_upvr._obj.Size.Y)
		end)});
		Visible = any_load_result1_result1_upvr_6.Computed(setmetatable_result1_upvr._textValue, function(arg1_4) -- Line 64
			if arg1_4 then
				return true
			end
			return false
		end);
	}))
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.GetAccentColor(arg1) -- Line 72
	return arg1._backing.ImageColor3
end
function setmetatable_result1_upvr_2.SetPercentVisible(arg1, arg2) -- Line 76
	arg1:_setTransparency(1 - arg2)
end
local any_load_result1_result1_upvr_4 = any_load_result1("DialogEntityTypes")
function setmetatable_result1_upvr_2.SetFromEntityData(arg1, arg2) -- Line 80
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
	]]
	if not arg2 then
		arg1:SetText(nil)
		arg1:SetAccentColor(any_load_result1_result1_upvr.DEFAULT_ACCENT_COLOR)
	else
		if arg2.type == any_load_result1_result1_upvr_4.TALKER_ENTITY then
			local text = arg2.text
			if not text then
				text = error("No text")
			end
			arg1:SetText(text)
			text = arg2.textColor3
			local var25 = text
			if not var25 then
				var25 = error("No textColor3")
			end
			arg1:SetAccentColor(var25)
			return
		end
		warn("[DialogNameLabel.SetFromEntityData] - Bad entityData of type %q":format(tostring(arg2.type)))
	end
end
function setmetatable_result1_upvr_2.GetAbsoluteWidth(arg1) -- Line 92
	return arg1._obj.AbsoluteSize.x
end
function setmetatable_result1_upvr_2.SetText(arg1, arg2) -- Line 96
	arg1._textValue.Value = arg2
end
local any_load_result1_result1_upvr_9 = any_load_result1("DialogAccentColorUtils")
function setmetatable_result1_upvr_2.SetAccentColor(arg1, arg2) -- Line 100
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
	]]
	local var27
	if typeof(arg2) ~= "Color3" then
		var27 = false
	else
		var27 = true
	end
	assert(var27, "Bad color3")
	arg1._backing.ImageColor3 = arg2
	var27 = any_load_result1_result1_upvr_9.getTextColorForColoredBacking(arg2)
	arg1._textLabel.TextColor3 = var27
end
local any_load_result1_result1_upvr_7 = any_load_result1("Math")
function setmetatable_result1_upvr_2._setTransparency(arg1, arg2) -- Line 107
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_7 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	arg1._textLabel.TextTransparency = arg2
	arg1._backing.ImageTransparency = arg2
	local any_lerp_result1 = any_load_result1_result1_upvr_7.lerp(var1_result1_upvr.SHADOW_TRANSPARENCY, 1, arg2)
	arg1._shadow.ImageTransparency = any_lerp_result1
	for _, v in pairs(arg1._shadow:GetChildren()) do
		if v:IsA("ImageLabel") then
			v.ImageTransparency = any_lerp_result1
		end
	end
end
return setmetatable_result1_upvr_2