-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:06
-- Luau version 6, Types version 3
-- Time taken: 0.001299 seconds

local var1_upvr = require(script.Parent.loader).load(script)("Spritesheet")
local setmetatable_result1_upvr = setmetatable({}, var1_upvr)
setmetatable_result1_upvr.ClassName = "AnimatedSpritesheet"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1) -- Line 29
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_upvr.new(arg1.texture), setmetatable_result1_upvr)
	setmetatable_result1._options = assert(arg1, "Bad options")
	assert(setmetatable_result1._options.texture, "Bad options.texture")
	assert(setmetatable_result1._options.frames, "Bad options.frames")
	assert(setmetatable_result1._options.spritesPerRow, "Bad options.spritesPerRow")
	assert(setmetatable_result1._options.spriteSize, "Bad options.spriteSize")
	assert(setmetatable_result1._options.framesPerSecond, "Bad options.framesPerSecond")
	for i = 0, arg1.frames do
		setmetatable_result1:AddSprite(i + 1, arg1.spriteSize * Vector2.new(i % arg1.spritesPerRow, math.floor(i / arg1.spritesPerRow)), arg1.spriteSize)
	end
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetSpriteSize(arg1) -- Line 54
	return arg1._options.spriteSize
end
function setmetatable_result1_upvr.GetFramesPerSecond(arg1) -- Line 62
	return arg1._options.framesPerSecond
end
function setmetatable_result1_upvr.GetPlayTime(arg1) -- Line 70
	return arg1._options.frames / arg1._options.framesPerSecond
end
function setmetatable_result1_upvr.GetFrames(arg1) -- Line 78
	return arg1._options.frames
end
return setmetatable_result1_upvr