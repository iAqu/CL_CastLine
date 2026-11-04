-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:37
-- Luau version 6, Types version 3
-- Time taken: 0.000650 seconds

local tonumber_result1_upvr = tonumber(script.Parent.Name)
local Position_upvr = script.Parent.Position
local OFF_upvr = script.Parent.OFF
require(game:GetService("ReplicatedStorage").Tool.AddListen).NumValueAdd(script.Parent.Parent.Parent.Parent["当前背包标签"], function(arg1) -- Line 16
	--[[ Upvalues[3]:
		[1]: tonumber_result1_upvr (readonly)
		[2]: Position_upvr (readonly)
		[3]: OFF_upvr (readonly)
	]]
	if arg1 == tonumber_result1_upvr then
		script.Parent.Position = Position_upvr
		OFF_upvr.Visible = false
	else
		script.Parent.Position = Position_upvr + UDim2.new(0, 0, 0, 10)
		OFF_upvr.Visible = true
	end
end)