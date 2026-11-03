-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:28
-- Luau version 6, Types version 3
-- Time taken: 0.002125 seconds

local tbl_5_upvr = {}
local tbl_3 = {
	Name = "Animations";
	Type = "Boolean";
	Default = "true";
}
local function Validate(arg1) -- Line 7
	if arg1 == "true" then
		return "true"
	end
	return "false"
end
tbl_3.Validate = Validate
tbl_5_upvr.Animations = tbl_3
local tbl_2 = {
	Name = "Show Stars (Other Players)";
	Type = "Boolean";
	Default = "false";
}
local function Validate(arg1) -- Line 15
	if arg1 == "true" then
		return "true"
	end
	return "false"
end
tbl_2.Validate = Validate
tbl_5_upvr.ShowStars = tbl_2
local tbl = {
	Name = "Show Award Messages";
	Type = "Boolean";
	Default = "true";
}
local function Validate(arg1) -- Line 23
	if arg1 == "true" then
		return "true"
	end
	return "false"
end
tbl.Validate = Validate
tbl_5_upvr.ShowAwards = tbl
local tbl_4 = {
	Name = "Music";
	Type = "Slider";
	Values = {"Low", "Medium", "High"};
	Default = 0.35;
}
local function Validate(arg1) -- Line 32
	return tonumber(arg1) or 0.35
end
tbl_4.Validate = Validate
tbl_5_upvr.Soundtrack = tbl_4
tbl_5_upvr.SFX = {
	Name = "Sound Effects";
	Type = "Slider";
	Values = {"Low", "Medium", "High"};
	Default = 0.35;
	Validate = function(arg1) -- Line 41, Named "Validate"
		return tonumber(arg1) or 0.35
	end;
}
local module = {
	__index = tbl_5_upvr;
}
setmetatable(module, module)
function module.new() -- Line 52
	--[[ Upvalues[1]:
		[1]: tbl_5_upvr (readonly)
	]]
	local module_2 = {}
	for i, v in pairs(tbl_5_upvr) do
		module_2[i] = v.Default
	end
	return module_2
end
function module.GetSettings(arg1) -- Line 60
	--[[ Upvalues[1]:
		[1]: tbl_5_upvr (readonly)
	]]
	return tbl_5_upvr
end
function module.NextValue(arg1, arg2, arg3) -- Line 64
	--[[ Upvalues[1]:
		[1]: tbl_5_upvr (readonly)
	]]
	local var20 = tbl_5_upvr[arg2]
	if var20 then
		if var20.Type == "Boolean" then
			if arg3 == "true" then
				return "false"
			end
			return "true"
		end
		if var20.Type == "Text" then
			for i_2, v_2 in pairs(var20.Values) do
				if v_2 == arg3 and i_2 ~= #var20.Values then
					return var20.Values[i_2 + 1]
				end
			end
			return var20.Values[1]
		end
		warn("[Settings/NextValue] No way found to iterate through the next setting value for \""..arg2..'"')
	else
		warn("[Settings/NextValue] No setting with name \""..arg2..'"')
	end
end
return module