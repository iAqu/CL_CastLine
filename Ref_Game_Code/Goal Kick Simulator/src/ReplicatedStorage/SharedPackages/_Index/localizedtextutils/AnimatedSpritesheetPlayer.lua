-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:48
-- Luau version 6, Types version 3
-- Time taken: 0.001163 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_2_upvr.ClassName = "AnimatedSpritesheetPlayer"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1, arg2) -- Line 23
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr.new(arg2), setmetatable_result1_2_upvr)
	setmetatable_result1._imageLabel = assert(arg1, "Bad imageLabel")
	if arg2 then
		setmetatable_result1:SetSheet(arg2)
	end
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.SetSheet(arg1, arg2) -- Line 39
	assert(arg2, "Bad spritesheet")
	arg1._spritesheet = arg2
	arg1:_play()
end
local any_load_result1_result1_upvr = any_load_result1("Maid")
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_2_upvr._play(arg1) -- Line 46
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local any_new_result1 = any_load_result1_result1_upvr.new()
	local any_GetFramesPerSecond_result1_upvr = arg1._spritesheet:GetFramesPerSecond()
	local any_GetFrames_result1_upvr = arg1._spritesheet:GetFrames()
	any_new_result1:GiveTask(RunService_upvr.RenderStepped:Connect(function() -- Line 52
		--[[ Upvalues[3]:
			[1]: any_GetFramesPerSecond_result1_upvr (readonly)
			[2]: any_GetFrames_result1_upvr (readonly)
			[3]: arg1 (readonly)
		]]
		arg1._spritesheet:GetSprite(math.floor(tick() * any_GetFramesPerSecond_result1_upvr) % any_GetFrames_result1_upvr + 1):Style(arg1._imageLabel)
	end))
	arg1._maid._play = any_new_result1
end
return setmetatable_result1_2_upvr