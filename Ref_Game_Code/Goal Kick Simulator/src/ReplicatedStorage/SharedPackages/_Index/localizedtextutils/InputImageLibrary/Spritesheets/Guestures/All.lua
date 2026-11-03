-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:47
-- Luau version 6, Types version 3
-- Time taken: 0.001693 seconds

local class_ModuleScript = script:FindFirstAncestorWhichIsA("ModuleScript")
local var2_upvr = require(class_ModuleScript.Parent.loader).load(class_ModuleScript)("Spritesheet")
local setmetatable_result1_2_upvr = setmetatable({}, var2_upvr)
setmetatable_result1_2_upvr.ClassName = "Gestures"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new() -- Line 15
	--[[ Upvalues[2]:
		[1]: var2_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var2_upvr.new("rbxassetid://1244652786"), setmetatable_result1_2_upvr)
	setmetatable_result1:AddSprite("DoubleRotate", Vector2.new(0, 0), Vector2.new(102, 139))
	setmetatable_result1:AddSprite("DoubleTap", Vector2.new(102, 0), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("FingerFront", Vector2.new(202, 0), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("FingerSide", Vector2.new(302, 0), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("FullCircle", Vector2.new(402, 0), Vector2.new(100, 137))
	setmetatable_result1:AddSprite("HalfCircle", Vector2.new(502, 0), Vector2.new(76, 141))
	setmetatable_result1:AddSprite("Hold", Vector2.new(578, 0), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("QuarterCircle", Vector2.new(678, 0), Vector2.new(87, 110))
	setmetatable_result1:AddSprite("ScrollDown", Vector2.new(765, 0), Vector2.new(71, 105))
	setmetatable_result1:AddSprite("ScrollLeft", Vector2.new(836, 0), Vector2.new(109, 63))
	setmetatable_result1:AddSprite("ScrollRight", Vector2.new(0, 141), Vector2.new(106, 63))
	setmetatable_result1:AddSprite("ScrollUp", Vector2.new(106, 141), Vector2.new(71, 102))
	setmetatable_result1:AddSprite("SwipeBottom", Vector2.new(177, 141), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("SwipeBottomLeft", Vector2.new(277, 141), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("SwipeBottomRight", Vector2.new(377, 141), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("SwipeLeft", Vector2.new(477, 141), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("SwipeRight", Vector2.new(577, 141), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("SwipeTopLeft", Vector2.new(677, 141), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("SwipeTopRight", Vector2.new(777, 141), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("SwipeUp", Vector2.new(877, 141), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("Tap", Vector2.new(0, 243), Vector2.new(100, 100))
	setmetatable_result1:AddSprite("ZoomIn", Vector2.new(100, 243), Vector2.new(114, 106))
	setmetatable_result1:AddSprite("ZoomOut", Vector2.new(214, 243), Vector2.new(154, 105))
	return setmetatable_result1
end
return setmetatable_result1_2_upvr