-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:28
-- Luau version 6, Types version 3
-- Time taken: 0.001369 seconds

local module_upvr = {
	ClassName = "Spritesheet";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1) -- Line 19
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	local var3 = arg1
	if not var3 then
		var3 = error("no texture")
	end
	setmetatable_result1._texture = var3
	setmetatable_result1._sprites = {}
	return setmetatable_result1
end
function module_upvr.GetPreloadAssetId(arg1) -- Line 32
	return arg1._texture
end
local var4_upvr = require(script.Parent.loader).load(script)("Sprite")
function module_upvr.AddSprite(arg1, arg2, arg3, arg4) -- Line 43
	--[[ Upvalues[1]:
		[1]: var4_upvr (readonly)
	]]
	assert(not arg1._sprites[arg2], "Already exists")
	local tbl = {
		Texture = arg1._texture;
	}
	tbl.Position = arg3
	tbl.Size = arg4
	tbl.Name = tostring(arg2)
	arg1._sprites[arg2] = var4_upvr.new(tbl)
end
function module_upvr.GetSprite(arg1, arg2) -- Line 61
	if not arg2 then
		warn("[Spritesheet.GetSprite] - Image name cannot be nil")
		return nil
	end
	local var6 = arg1._sprites[arg2]
	if var6 then
		return var6
	end
	if typeof(arg2) == "EnumItem" then
	end
	return arg1._sprites[arg2.Name]
end
function module_upvr.HasSprite(arg1, arg2) -- Line 84
	local var7
	if arg1:GetSprite(arg2) == nil then
		var7 = false
	else
		var7 = true
	end
	return var7
end
return module_upvr