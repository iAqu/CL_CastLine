-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:23
-- Luau version 6, Types version 3
-- Time taken: 0.000696 seconds

return {
	ReadPlayer = function(arg1) -- Line 15, Named "ReadPlayer"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local Character = arg1.Character
		if not Character or not Character.Parent then
		end
		local Humanoid = arg1.CharacterAdded:Wait():WaitForChild("Humanoid")
		local module = {}
		module.player = arg1
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		module.character = arg1.CharacterAdded:Wait()
		module.humanoid = Humanoid
		module.rootPart = arg1.CharacterAdded:Wait().PrimaryPart
		module.animator = Humanoid:WaitForChild("Animator")
		return module
	end;
}