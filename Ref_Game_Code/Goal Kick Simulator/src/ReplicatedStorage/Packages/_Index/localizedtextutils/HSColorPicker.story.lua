-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:27
-- Luau version 6, Types version 3
-- Time taken: 0.000730 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("HSColorPicker")
return function(arg1) -- Line 10
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local any_new_result1_upvr = any_load_result1_result1_upvr_2.new()
	local any_new_result1 = any_load_result1_result1_upvr.new()
	any_new_result1:SetColor(Color3.new(1, 1, 1))
	any_new_result1.Gui.AnchorPoint = Vector2.new(0.5, 0.5)
	any_new_result1.Gui.Position = UDim2.fromScale(0.5, 0.5)
	any_new_result1.Gui.Size = UDim2.fromScale(0.8, 0.8)
	any_new_result1.Gui.Parent = arg1
	any_new_result1_upvr:GiveTask(any_new_result1)
	return function() -- Line 21
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end