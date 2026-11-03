-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:52
-- Luau version 6, Types version 3
-- Time taken: 0.001436 seconds

local module = {
	ServiceName = "AnimatedSpriteProvider";
}
local var2_upvr = require(script.Parent.loader).load(script)("AnimatedSpritesheet")
function module.Init(arg1) -- Line 12
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	assert(not arg1._spritesheets, "Already initialized")
	arg1._spritesheets = {}
	arg1:_add("BusyChatSheetLight", var2_upvr.new({
		texture = "rbxassetid://5086289659";
		frames = 9;
		spritesPerRow = 3;
		spriteSize = Vector2.new(64, 64);
		framesPerSecond = 14;
	}))
	arg1:_add("BusyChatSheetDark", var2_upvr.new({
		texture = "rbxassetid://5086230186";
		frames = 9;
		spritesPerRow = 3;
		spriteSize = Vector2.new(64, 64);
		framesPerSecond = 14;
	}))
end
function module.GetPreloadAssetIds(arg1) -- Line 33
	assert(arg1._spritesheets, "Not initialized")
	local module_2 = {}
	for _, v in pairs(arg1._spritesheets) do
		table.insert(module_2, v:GetPreloadAssetId())
	end
	return module_2
end
function module.GetAnimatedSprite(arg1, arg2) -- Line 44
	local var13 = arg1._spritesheets[arg2]
	if not var13 then
		var13 = error("No sprite")
	end
	return var13
end
function module._add(arg1, arg2, arg3) -- Line 48
	assert(not arg1._spritesheets[arg2], "Spritesheet already exists")
	arg1._spritesheets[arg2] = arg3
end
return module