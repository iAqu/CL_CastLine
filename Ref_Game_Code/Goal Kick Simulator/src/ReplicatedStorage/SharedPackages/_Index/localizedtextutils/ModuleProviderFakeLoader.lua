-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:34
-- Luau version 6, Types version 3
-- Time taken: 0.000381 seconds

return {
	load = function(arg1) -- Line 6, Named "load"
		local class_ModuleScript = arg1:FindFirstAncestorWhichIsA("ModuleScript")
		assert(class_ModuleScript, "No moduleProvider")
		return require(class_ModuleScript.Parent.loader).load(class_ModuleScript)
	end;
}