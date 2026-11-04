-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:40
-- Luau version 6, Types version 3
-- Time taken: 0.000589 seconds

if game:GetService("UserInputService").TouchEnabled then
	local x = script.Parent.AbsoluteSize.x
	if math.min(x, script.Parent.AbsoluteSize.y) > 500 then
		x = false
	else
		x = true
	end
	if x then
		script.Parent.UIScale.Scale = 0.9
	else
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		script.Parent.UIScale.Scale = 1
	end
	script.Parent.Position = UDim2.new(0.995, 0, 0.12, 0)
else
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	script.Parent.UIScale.Scale = 1
end