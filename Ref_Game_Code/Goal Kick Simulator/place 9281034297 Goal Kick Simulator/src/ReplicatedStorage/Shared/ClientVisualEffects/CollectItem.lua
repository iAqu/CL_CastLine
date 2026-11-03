-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:55
-- Luau version 6, Types version 3
-- Time taken: 0.000862 seconds

return function(arg1, arg2, arg3) -- Line 4
	local cframe_upvr_2 = CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, math.random() * math.pi * 2)
	local cframe_upvr = CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, math.random() * math.pi * 2)
	return function(arg1_2) -- Line 8
		--[[ Upvalues[5]:
			[1]: arg3 (readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
			[4]: cframe_upvr_2 (readonly)
			[5]: cframe_upvr (readonly)
		]]
		local Position = arg3:GetPivot().Position
		if arg1_2 < 1 then
			arg1:PivotTo(CFrame.new(CFrame.new(arg2, Position) * CFrame.new(0, 0, -(arg2 - Position).Magnitude * arg1_2).Position) * CFrame.new(0, math.sin(arg1_2 * math.pi) * 7, 0) * cframe_upvr_2:Lerp(cframe_upvr, arg1_2))
		else
			arg1.Parent = nil
		end
	end
end