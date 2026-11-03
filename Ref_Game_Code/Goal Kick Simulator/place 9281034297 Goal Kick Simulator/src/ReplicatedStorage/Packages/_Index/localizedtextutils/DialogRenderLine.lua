-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:00
-- Luau version 6, Types version 3
-- Time taken: 0.002250 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, any_load_result1_result1_upvr)
setmetatable_result1_2_upvr.ClassName = "DialogRenderLine"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1, arg2) -- Line 14
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr.new(), setmetatable_result1_2_upvr)
	local var5 = arg1
	if not var5 then
		var5 = error("No parent")
	end
	setmetatable_result1._parent = var5
	var5 = arg2
	local var6 = var5
	if not var6 then
		var6 = error("No line")
	end
	setmetatable_result1._line = var6
	setmetatable_result1._percentVisible = 0
	setmetatable_result1._yOffset = 0
	setmetatable_result1._guis = {}
	return setmetatable_result1
end
local any_load_result1_result1_upvr_2 = any_load_result1("Math")
function setmetatable_result1_2_upvr.SetPercentVisible(arg1, arg2) -- Line 27
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	arg1._percentVisible = arg2
	for i, v in pairs(arg1._guis) do
		if v.type == "textLabel" then
			i.TextTransparency = any_load_result1_result1_upvr_2.lerp(1, v.textTransparency, arg2)
		elseif v.type == "inputHint" then
			v.hintInput:SetTransparency(1 - arg2)
		else
			warn("[DialogRenderLine] - Unknown data type %q":format(tostring(v.type)))
		end
	end
end
function setmetatable_result1_2_upvr.SetYOffset(arg1, arg2) -- Line 40
	local var17 = arg2
	if not var17 then
		var17 = error("No yOffset")
	end
	arg1._yOffset = var17
	for i_2, v_2 in pairs(arg1._guis) do
		i_2.Position = arg1:_getPosition(v_2.position)
	end
end
function setmetatable_result1_2_upvr.GiveTextLabel(arg1, arg2, arg3) -- Line 48
	arg2.Parent = arg1._parent
	arg1._maid:GiveTask(arg2)
	if arg3 then
		arg1._maid:GiveTask(arg3)
	end
	arg1._guis[arg2] = {
		type = "textLabel";
		position = arg2.Position;
		textTransparency = arg2.TextTransparency;
	}
	arg2.Position = arg1:_getPosition(arg2.Position)
end
function setmetatable_result1_2_upvr.GiveHintInput(arg1, arg2) -- Line 64
	local Gui = arg2.Gui
	if not Gui then
		Gui = error("No gui")
	end
	Gui.Parent = arg1._parent
	arg2:Show()
	arg1._maid:GiveTask(arg2)
	local tbl = {
		type = "inputHint";
		position = Gui.Position;
	}
	tbl.hintInput = arg2
	arg1._guis[Gui] = tbl
	Gui.Position = arg1:_getPosition(Gui.Position)
end
function setmetatable_result1_2_upvr._getPosition(arg1, arg2) -- Line 79
	return arg2 + UDim2.new(0, 0, 0, arg1._yOffset)
end
return setmetatable_result1_2_upvr