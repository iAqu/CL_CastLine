-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:47
-- Luau version 6, Types version 3
-- Time taken: 0.003115 seconds

return {
	spanSearch = function(arg1, arg2) -- Line 21, Named "spanSearch"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local len = #arg1
		local var3
		if len < var3 then
			return nil, nil
		end
		if arg2 < arg1[var3] then
			return nil, var3
		end
		if arg1[len] < arg2 then
			return len, nil
		end
		if var3 == len then
			return var3, nil
		end
		while 1 < len - var3 do
			local var4 = (var3 + len) / 2
			local var5 = var4 - var4 % 1
			if arg2 < arg1[var5] then
			else
				var3 = var5
			end
		end
		return var3, var5
	end;
	spanSearchNodes = function(arg1, arg2, arg3) -- Line 57, Named "spanSearchNodes"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local len_2 = #arg1
		local var7
		if len_2 < var7 then
			return nil, nil
		end
		if arg3 < arg1[var7][arg2] then
			return nil, var7
		end
		if arg1[len_2][arg2] < arg3 then
			return len_2, nil
		end
		if var7 == len_2 then
			return var7, nil
		end
		while 1 < len_2 - var7 do
			local var8 = (var7 + len_2) / 2
			local var9 = var8 - var8 % 1
			if arg3 < arg1[var9][arg2] then
			else
				var7 = var9
			end
		end
		return var7, var9
	end;
	spanSearchAnything = function(arg1, arg2, arg3) -- Line 92, Named "spanSearchAnything"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var10 = arg1
		local var11
		if var10 < var11 then
			return nil, nil
		end
		if arg3 < arg2(var11) then
			return nil, var11
		end
		if arg2(var10) < arg3 then
			return var10, nil
		end
		if var11 == var10 then
			return var11, nil
		end
		while 1 < var10 - var11 do
			local var12 = (var11 + var10) / 2
			local var13 = var12 - var12 % 1
			if arg3 < arg2(var13) then
			else
				var11 = var13
			end
		end
		return var11, var13
	end;
}