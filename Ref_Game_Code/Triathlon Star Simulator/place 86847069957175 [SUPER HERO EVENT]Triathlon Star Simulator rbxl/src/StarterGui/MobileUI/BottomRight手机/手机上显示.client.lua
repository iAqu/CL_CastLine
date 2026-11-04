-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:21
-- Luau version 6, Types version 3
-- Time taken: 0.001407 seconds

-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
local var1
if not game:GetService("UserInputService").TouchEnabled then
	var1 = script
	var1.Parent.Parent:Destroy()
else
	script.Parent.Visible = true
	var1 = script.Parent.AbsoluteSize
	local x = var1.x
	var1 = script.Parent.AbsoluteSize.y
	var1 = 500
	if math.min(x, var1) > var1 then
		x = false
	else
		x = true
	end
	if x then
		var1 = 50
	else
		var1 = 85.71428571428572
	end
	local ____________ = script.Parent["冲刺按钮"]
	____________.Size = UDim2.new(0, var1, 0, var1)
	if x then
		local const_number = 70
	else
	end
	print("屏幕大小", x)
	if not x or not UDim2.new(1, -(var1 * 0.5), 1, -120 * 0.9 - 25 - var1) then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	end
	____________.Position = UDim2.new(1, -(var1 * 0.5), 1, -120 * 1.75 * 1 - var1 * 1 - 5)
end