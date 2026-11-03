-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:23
-- Luau version 6, Types version 3
-- Time taken: 0.001841 seconds

local module_upvr = {
	getThemeFromKey = function(arg1, arg2) -- Line 9, Named "getThemeFromKey"
		local var6
		if type(arg2) ~= "string" then
			var6 = false
		else
			var6 = true
		end
		assert(var6, "Bad key")
		var6 = arg1:GetAll()
		for _, v in pairs(var6) do
			if v:GetThemeKey() == arg2 then
				return v
			end
		end
		return nil
	end;
	toAttributeName = function(arg1) -- Line 21, Named "toAttributeName"
		return arg1:gsub("%.", '_')
	end;
}
function module_upvr.toColorAttributeName(arg1) -- Line 25
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return "color_"..module_upvr.toAttributeName(arg1)
end
function module_upvr.toGradeAttributeName(arg1) -- Line 29
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return "grade_"..module_upvr.toAttributeName(arg1)
end
function module_upvr.toVividnessAttributeName(arg1) -- Line 33
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return "vividness_"..module_upvr.toAttributeName(arg1)
end
function module_upvr.toFontAttributeName(arg1) -- Line 37
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return "font_"..module_upvr.toAttributeName(arg1)
end
function module_upvr.encodeFontAttribute(arg1) -- Line 41
	if typeof(arg1) == "EnumItem" then
		return arg1.Name
	end
	return arg1
end
function module_upvr.decodeFontAttribute(arg1) -- Line 49
	if type(arg1) == "string" then
		return Enum.Font[arg1]
	end
	return arg1
end
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
function module_upvr.getPreferredThemeParent() -- Line 57
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	if not ReplicatedStorage_upvr:FindFirstChild("Theme") then
		local Folder = Instance.new("Folder")
		Folder.Name = "Theme"
		Folder.Parent = ReplicatedStorage_upvr
	end
	return Folder
end
return module_upvr