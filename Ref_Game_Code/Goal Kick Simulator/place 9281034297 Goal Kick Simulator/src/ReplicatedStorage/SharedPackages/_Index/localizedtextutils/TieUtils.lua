-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:32
-- Luau version 6, Types version 3
-- Time taken: 0.001570 seconds

local module_upvr = {
	encode = function(...) -- Line 13, Named "encode"
		local packed_2 = table.pack(...)
		for i = 1, packed_2.n do
			if type(packed_2[i]) == "table" or type(packed_2[i]) == "function" then
				local var5_upvr = packed_2[i]
				packed_2[i] = function() -- Line 19
					--[[ Upvalues[1]:
						[1]: var5_upvr (readonly)
					]]
					return var5_upvr
				end
			end
		end
		var5_upvr = packed_2.n
		return unpack(packed_2, 1, var5_upvr)
	end;
}
function module_upvr.encodeCallback(arg1) -- Line 32
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var6
	if type(arg1) ~= "function" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad callback")
	return function(...) -- Line 35
		--[[ Upvalues[2]:
			[1]: module_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return module_upvr.encode(arg1(module_upvr.decode(...)))
	end
end
function module_upvr.invokeEncodedBindableFunction(arg1, ...) -- Line 46
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var8 = false
	if typeof(arg1) == "Instance" then
		var8 = arg1:IsA("BindableFunction")
	end
	assert(var8, "Bad bindableFunction")
	return module_upvr.decode(arg1:Invoke(module_upvr.encode(...)))
end
function module_upvr.decode(...) -- Line 57
	local packed = table.pack(...)
	for i_2 = 1, packed.n do
		if type(packed[i_2]) == "function" then
			packed[i_2] = packed[i_2]()
		end
	end
	return unpack(packed, 1, packed.n)
end
return module_upvr