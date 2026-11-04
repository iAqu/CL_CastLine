-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:35
-- Luau version 6, Types version 3
-- Time taken: 0.001151 seconds

-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
local LocalPlayer = game.Players.LocalPlayer
local Parent_upvr = script.Parent
repeat
	wait(1)
until LocalPlayer:FindFirstChild("GamePass")
local GamePass = LocalPlayer:FindFirstChild("GamePass")
repeat
	wait(1)
until GamePass:FindFirstChild("ToolStorage1")
local const_string = "ToolStorage1"
local SOME_upvr = GamePass:FindFirstChild(const_string)
if SOME_upvr.Value == 1 then
else
end
Parent_upvr.Visible = true
SOME_upvr.Changed:Connect(function() -- Line 18
	--[[ Upvalues[2]:
		[1]: Parent_upvr (readonly)
		[2]: SOME_upvr (readonly)
	]]
	local var7
	if SOME_upvr.Value == 1 then
		var7 = false
	else
		var7 = true
	end
	Parent_upvr.Visible = var7
end)