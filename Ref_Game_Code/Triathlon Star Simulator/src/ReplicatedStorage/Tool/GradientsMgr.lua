-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:40
-- Luau version 6, Types version 3
-- Time taken: 0.006877 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local _________________________upvr = ReplicatedStorage["武器稀有度渐变色"]
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
function module_upvr.getXydName(arg1) -- Line 18
	--[[ Upvalues[1]:
		[1]: EnumMgr_upvr (readonly)
	]]
	return EnumMgr_upvr.RareName[tonumber(arg1)]
end
function module_upvr.setXydLabel(arg1, arg2) -- Line 22
	--[[ Upvalues[2]:
		[1]: TranslationHelper_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg1:IsA("TextLabel") then
		TranslationHelper_upvr.SetText(arg1, module_upvr.getXydName(arg2))
	end
	local any_GetXydColor_result1_4 = module_upvr.GetXydColor(arg2)
	if any_GetXydColor_result1_4 then
		for _, v in pairs(arg1:GetChildren()) do
			if v.ClassName == "UIGradient" or v.ClassName == "UIStroke" then
				v:Destroy()
			end
		end
		local Text = any_GetXydColor_result1_4:FindFirstChild("Text")
		if Text then
			Text:Clone().Parent = arg1
		end
		arg1.BackgroundColor3 = Color3.new(1, 1, 1)
		local Board = any_GetXydColor_result1_4:FindFirstChild("Board")
		if Board then
			local UIStroke_2 = Instance.new("UIStroke", arg1)
			UIStroke_2.Thickness = 2
			UIStroke_2.Color = Board.Value
		end
	end
end
function module_upvr.SetItemXyd(arg1, arg2) -- Line 53
	--[[ Upvalues[3]:
		[1]: _________________________upvr (readonly)
		[2]: TranslationHelper_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	local SOME_4 = _________________________upvr:FindFirstChild(arg2)
	if SOME_4 == nil then
	else
		local BG = arg1.BG:FindFirstChild("BG")
		if BG then
			BG:Destroy()
		end
		local clone_4 = SOME_4:FindFirstChild("BG"):Clone()
		clone_4.Parent = arg1.BG
		clone_4.Name = "BG"
		local Stroke = arg1:FindFirstChild("Stroke")
		if Stroke then
			Stroke:Destroy()
		end
		local clone_2 = SOME_4:FindFirstChild("Stroke"):Clone()
		clone_2.Parent = arg1
		clone_2.Name = "Stroke"
		local xydStr = arg1:FindFirstChild("xydStr")
		TranslationHelper_upvr.SetText(xydStr, module_upvr.getXydName(arg2))
		local Stroke_2 = xydStr:FindFirstChild("Stroke")
		if Stroke_2 then
			Stroke_2:Destroy()
		end
		local clone = SOME_4:FindFirstChild("Stroke"):Clone()
		clone.Parent = xydStr
		clone.Name = "Stroke"
	end
end
function module_upvr.WeaponNameGradient(arg1, arg2) -- Line 91
	--[[ Upvalues[1]:
		[1]: _________________________upvr (readonly)
	]]
	local SOME_2 = _________________________upvr:FindFirstChild(arg2)
	if SOME_2 == nil then
	else
		local Stroke_3 = arg1:FindFirstChild("Stroke")
		if Stroke_3 then
			Stroke_3:Destroy()
		end
		local clone_3 = SOME_2:FindFirstChild("Stroke"):Clone()
		clone_3.Parent = arg1
		clone_3.Name = "Stroke"
	end
end
function module_upvr.addGradients(arg1, arg2) -- Line 108
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1:IsA("TextLabel") then
	else
		arg1.TextColor3 = Color3.new(1, 1, 1)
		for i_4, v_4 in pairs(arg1:GetChildren()) do
			if v_4.ClassName == "UIGradient" or v_4.ClassName == "UIStroke" then
				v_4:Destroy()
			end
		end
		local any_GetXydColor_result1_5 = module_upvr.GetXydColor(arg2)
		if any_GetXydColor_result1_5 then
			i_4 = arg1
			local UIStroke = Instance.new("UIStroke", i_4)
			UIStroke.Thickness = 2
			i_4 = any_GetXydColor_result1_5.Board
			UIStroke.Color = i_4.Value
			v_4 = "UIGradient"
			if any_GetXydColor_result1_5:FindFirstChildOfClass(v_4) then
				i_4 = any_GetXydColor_result1_5:FindFirstChildOfClass(v_4):Clone()
				i_4.Parent = arg1
			end
		end
	end
end
function module_upvr.addGradients_Frame(arg1, arg2) -- Line 137
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1:IsA("Frame") then
	else
		for i_5, v_5 in pairs(arg1:GetChildren()) do
			if v_5.ClassName == "UIGradient" then
				v_5:Destroy()
			end
		end
		local any_GetXydColor_result1 = module_upvr.GetXydColor(arg2)
		if any_GetXydColor_result1 then
			i_5 = "UIGradient"
			local instance_2 = any_GetXydColor_result1:FindFirstChildOfClass(i_5)
			if instance_2 then
				instance_2:Clone().Parent = arg1
			end
		end
	end
end
local ______________________upvr = ReplicatedStorage["属性词条渐变色"]
function module_upvr.addGradients_Attr(arg1, arg2) -- Line 162
	--[[ Upvalues[1]:
		[1]: ______________________upvr (readonly)
	]]
	if arg1:IsA("TextLabel") then
		arg1.TextColor3 = Color3.new(1, 1, 1)
	end
	for _, v_2 in pairs(arg1:GetChildren()) do
		if v_2.ClassName == "UIGradient" then
			v_2:Destroy()
		end
	end
	local SOME = ______________________upvr:FindFirstChild(arg2)
	if SOME then
		SOME:Clone().Parent = arg1
	end
end
local ________________upvr = ReplicatedStorage["稀有度颜色"]
function module_upvr.GetXydColor(arg1) -- Line 182
	--[[ Upvalues[1]:
		[1]: ________________upvr (readonly)
	]]
	if not arg1 then
		return ________________upvr['0']
	end
	local SOME_7 = ________________upvr:FindFirstChild(tostring(arg1))
	if SOME_7 then
		return SOME_7
	end
end
local __________upvr = ReplicatedStorage["渐变色"]
local GradientCfg_upvr = require(ReplicatedStorage.GradientCfg)
local Log_upvr = require(ReplicatedStorage.Tool.Log)
function module_upvr.GetGradientColor(arg1) -- Line 196
	--[[ Upvalues[3]:
		[1]: __________upvr (readonly)
		[2]: GradientCfg_upvr (readonly)
		[3]: Log_upvr (readonly)
	]]
	if not arg1 then
		return __________upvr:FindFirstChild("白"):Clone()
	end
	local SOME_6 = __________upvr:FindFirstChild(arg1)
	if SOME_6 then
		return SOME_6:Clone()
	end
	if type(arg1) == "number" then
		local tostring_result1 = tostring(arg1)
	end
	local var70 = GradientCfg_upvr[tostring_result1]
	if var70 == nil then
		Log_upvr.warn("_type 配置不合法", tostring_result1)
		return __________upvr:FindFirstChild("白"):Clone()
	end
	local SOME_5 = __________upvr:FindFirstChild(var70)
	if SOME_5 then
		return SOME_5:Clone()
	end
	Log_upvr.warn("_type 配置不合法", tostring_result1)
	return nil
end
function module_upvr.AddGradientColor(arg1, arg2, arg3) -- Line 224
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var79
	for i_3, v_3 in pairs(arg2:GetChildren()) do
		if v_3:IsA("UIGradient") then
			v_3:Destroy()
		end
	end
	if arg2:IsA("TextLabel") then
		i_3 = 1
		arg2.TextColor3 = Color3.new(1, 1, i_3)
		if arg3 ~= false then
			var79 = var79.."-Text"
			-- KONSTANTWARNING: GOTO [77] #60
		end
	elseif arg2:IsA("Frame") then
		i_3 = 1
		arg2.BackgroundColor3 = Color3.new(1, 1, i_3)
	elseif arg2:IsA("ImageLabel") then
		i_3 = 1
		arg2.ImageColor3 = Color3.new(1, 1, i_3)
	elseif arg2:IsA("UIStroke") then
		i_3 = 1
		arg2.Color = Color3.new(1, 1, i_3)
	end
	local any_GetGradientColor_result1 = module_upvr.GetGradientColor(var79)
	if any_GetGradientColor_result1 then
		any_GetGradientColor_result1.Parent = arg2
		return any_GetGradientColor_result1
	end
	return nil
end
function module_upvr.RemoveGradientColor(arg1) -- Line 257
end
function module_upvr.GetUIGradient(arg1) -- Line 262
	return arg1:FindFirstChildOfClass("UIGradient")
end
local _________________________upvr_2 = game.ReplicatedStorage["稀有度对应渐变色"]
function module_upvr.GetColor(arg1) -- Line 268
	--[[ Upvalues[1]:
		[1]: _________________________upvr_2 (readonly)
	]]
	if not arg1 then
		return _________________________upvr_2['1']
	end
	local SOME_3 = _________________________upvr_2:FindFirstChild(arg1)
	if SOME_3 then
		return SOME_3
	end
end
local EnumMgr_upvr_2 = require(game.ReplicatedStorage.Tool.EnumMgr)
function module_upvr.ChangeClolr(arg1, arg2) -- Line 279
	--[[ Upvalues[2]:
		[1]: EnumMgr_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	local Secret = arg1:FindFirstChild("Secret")
	local var85
	if Secret then
		if arg2 ~= EnumMgr_upvr_2.Rare.Secret then
			var85 = false
		else
			var85 = true
		end
		Secret.Visible = var85
	end
	local class_UIGradient = arg1:FindFirstChildOfClass("UIGradient")
	local function INLINED() -- Internal function, doesn't exist in bytecode
		local any_GetColor_result1 = module_upvr.GetColor(arg2)
		return any_GetColor_result1
	end
	if not class_UIGradient or class_UIGradient and class_UIGradient.Name ~= arg2 or INLINED() then
		if class_UIGradient then
			class_UIGradient:Destroy()
		end
		local class_UIGradient_2 = any_GetColor_result1:FindFirstChildOfClass("UIGradient")
		if class_UIGradient_2 then
			class_UIGradient_2:Clone().Parent = arg1
			arg1.BackgroundColor3 = Color3.new(1, 1, 1)
		end
		local class_UIStroke = arg1:FindFirstChildOfClass("UIStroke")
		if class_UIStroke and any_GetColor_result1:FindFirstChild("描边颜色") then
			class_UIStroke.Color = any_GetColor_result1["描边颜色"].Value
		end
		return
	end
end
return module_upvr