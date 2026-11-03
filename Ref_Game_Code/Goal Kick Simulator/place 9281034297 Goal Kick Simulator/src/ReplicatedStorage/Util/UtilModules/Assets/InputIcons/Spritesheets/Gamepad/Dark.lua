-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:23
-- Luau version 6, Types version 3
-- Time taken: 0.001534 seconds

return function(arg1, arg2) -- Line 3
	local any_Create_result1 = arg1:Create(arg2..'_'..script.Name, "rbxassetid://5104051626")
	any_Create_result1:AddSprite("DPad", Vector2.new(0, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.ButtonA, Vector2.new(100, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.ButtonB, Vector2.new(200, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.ButtonL1, Vector2.new(300, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.ButtonL2, Vector2.new(400, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.ButtonR1, Vector2.new(500, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.ButtonR2, Vector2.new(600, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.ButtonSelect, Vector2.new(700, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.ButtonX, Vector2.new(800, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.ButtonY, Vector2.new(900, 0), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.DPadDown, Vector2.new(0, 100), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.DPadLeft, Vector2.new(100, 100), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.DPadRight, Vector2.new(200, 100), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.DPadUp, Vector2.new(300, 100), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.Menu, Vector2.new(400, 100), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.Thumbstick2, Vector2.new(500, 100), Vector2.new(100, 100))
	any_Create_result1:AddSprite(Enum.KeyCode.Thumbstick1, Vector2.new(600, 100), Vector2.new(100, 100))
	return any_Create_result1
end