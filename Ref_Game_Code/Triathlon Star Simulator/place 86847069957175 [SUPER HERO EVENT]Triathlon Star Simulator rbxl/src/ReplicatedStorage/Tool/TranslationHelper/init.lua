-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:13
-- Luau version 6, Types version 3
-- Time taken: 0.002020 seconds

local module = {}
local LanguageCfg_upvr = require(script.LanguageCfg)
function module.translateByKey(arg1, arg2) -- Line 6
	--[[ Upvalues[1]:
		[1]: LanguageCfg_upvr (readonly)
	]]
	if arg1 == nil then
		return ""
	end
	if arg1 == "" then
		return ""
	end
	return LanguageCfg_upvr.FormatByKey(arg1, arg2)
end
local LocalizationService_upvr = game:GetService("LocalizationService")
function module.SetText(arg1, arg2, arg3, arg4) -- Line 19
	--[[ Upvalues[2]:
		[1]: LocalizationService_upvr (readonly)
		[2]: LanguageCfg_upvr (readonly)
	]]
	if not arg1 then
	elseif arg1:IsA("TextLabel") or arg1:IsA("ProximityPrompt") or arg1:IsA("TextBox") then
		if arg1:HasTag("代码本地化") == false then
			arg1:AddTag("代码本地化")
		end
		for i, _ in pairs(arg1:GetAttributes()) do
			arg1:SetAttribute(i, nil)
		end
		arg1:SetAttribute("_key", arg2)
		if arg3 then
			arg1:SetAttribute("_maxIndex", #arg3)
			for i_2, v_2 in pairs(arg3) do
				arg1:SetAttribute("_arg"..i_2, v_2)
			end
		end
		if not arg2 then
			warn("本地化错误", arg1.Name)
		end
		local any_FormatByKey_result1, any_FormatByKey_result2 = LanguageCfg_upvr.FormatByKey(arg2, arg3)
		arg1.AutoLocalize = any_FormatByKey_result2
		if any_FormatByKey_result1 then
			if arg4 then
				v_2 = "ProximityPrompt"
				if arg1:IsA(v_2) then
					i_2 = any_FormatByKey_result1
					v_2 = arg4
					arg1.ActionText = i_2..v_2
				else
					v_2 = "TextBox"
					if arg1:IsA(v_2) then
						i_2 = any_FormatByKey_result1
						v_2 = arg4
						arg1.PlaceholderText = i_2..v_2
						return
					end
					i_2 = any_FormatByKey_result1
					v_2 = arg4
					arg1.Text = i_2..v_2
				end
			end
			if arg1:IsA("ProximityPrompt") then
				arg1.ActionText = any_FormatByKey_result1
				return
			end
			if arg1:IsA("TextBox") then
				arg1.PlaceholderText = any_FormatByKey_result1
				return
			end
			arg1.Text = any_FormatByKey_result1
		end
	end
end
function module.SetText_UnTrans(arg1, arg2) -- Line 82
	if arg1:IsA("TextLabel") then
		arg1.AutoLocalize = false
		arg1.Text = arg2
	end
end
function module.CheckTranslateByKey(arg1, arg2) -- Line 91
	--[[ Upvalues[1]:
		[1]: LanguageCfg_upvr (readonly)
	]]
	if arg1 == nil then
	elseif LanguageCfg_upvr.FormatByKey(arg1, arg2) == "未本地化-"..arg1 then
		return false
	end
end
return module