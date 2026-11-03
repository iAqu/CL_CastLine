-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:42
-- Luau version 6, Types version 3
-- Time taken: 0.000607 seconds

return {
	create = function(arg1, arg2) -- Line 29, Named "create"
		assert(arg1, "Bad binder")
		local var2 = false
		if typeof(arg2) == "Instance" then
			var2 = arg2:IsA("Humanoid")
		end
		assert(var2, "Bad humanoid")
		local ObjectValue = Instance.new("ObjectValue")
		ObjectValue.Name = arg1:GetTag()
		ObjectValue.Value = arg2
		arg1:Bind(ObjectValue)
		return ObjectValue
	end;
}