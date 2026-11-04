-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:43
-- Luau version 6, Types version 3
-- Time taken: 0.007768 seconds

return {
	GetViewPortInfo = function(arg1, arg2) -- Line 2, Named "GetViewPortInfo"
		if arg2 == 1 then
			do
				return UDim2.new(0.8, 0, 0.8, 0), UDim2.new(0.5, 0, 0.5, 0)
			end
			local var2
		end
		if arg2 == 2 then
			local udim2_3 = UDim2.new(0.4, 0, 0.4, 0)
			if arg1 == 1 then
				var2 = UDim2.new(0.5 - udim2_3.X.Scale / 2, 0, 0.5, 0)
				return udim2_3, var2
			end
			if arg1 == 2 then
				var2 = UDim2.new(0.5 + udim2_3.X.Scale / 2, 0, 0.5, 0)
			end
			return udim2_3, var2
		end
		if arg2 == 3 then
			local udim2_2 = UDim2.new(0.33, 0, 0.33, 0)
			if arg1 == 1 then
				var2 = UDim2.new(0.5 - udim2_2.X.Scale, 0, 0.5, 0)
				return udim2_2, var2
			end
			if arg1 == 2 then
				var2 = UDim2.new(0.5, 0, 0.5, 0)
				return udim2_2, var2
			end
			if arg1 == 3 then
				var2 = UDim2.new(0.5 + udim2_2.X.Scale, 0, 0.5, 0)
			end
			return udim2_2, var2
		end
		if arg2 == 4 then
			local udim2_6 = UDim2.new(0.4, 0, 0.4, 0)
			if arg1 == 1 then
				var2 = UDim2.new(0.5 - udim2_6.X.Scale / 2, 0, 0.5 - udim2_6.Y.Scale / 2, 0)
				return udim2_6, var2
			end
			if arg1 == 2 then
				var2 = UDim2.new(0.5 + udim2_6.X.Scale / 2, 0, 0.5 - udim2_6.Y.Scale / 2, 0)
				return udim2_6, var2
			end
			if arg1 == 3 then
				var2 = UDim2.new(0.5 - udim2_6.X.Scale / 2, 0, 0.5 + udim2_6.Y.Scale / 2, 0)
				return udim2_6, var2
			end
			if arg1 == 4 then
				var2 = UDim2.new(0.5 + udim2_6.X.Scale / 2, 0, 0.5 + udim2_6.Y.Scale / 2, 0)
			end
			return udim2_6, var2
		end
		if arg2 == 5 then
			local udim2_4 = UDim2.new(0.3, 0, 0.3, 0)
			if arg1 == 1 then
				var2 = UDim2.new(0.5 - udim2_4.X.Scale, 0, 0.5 - udim2_4.Y.Scale, 0)
				return udim2_4, var2
			end
			if arg1 == 2 then
				var2 = UDim2.new(0.5, 0, 0.5 - udim2_4.Y.Scale, 0)
				return udim2_4, var2
			end
			if arg1 == 3 then
				var2 = UDim2.new(0.5 + udim2_4.X.Scale, 0, 0.5 - udim2_4.Y.Scale, 0)
				return udim2_4, var2
			end
			if arg1 == 4 then
				var2 = UDim2.new(0.5 - udim2_4.X.Scale / 2, 0, 0.5 + udim2_4.Y.Scale, 0)
				return udim2_4, var2
			end
			if arg1 == 5 then
				var2 = UDim2.new(0.5 + udim2_4.X.Scale / 2, 0, 0.5 + udim2_4.Y.Scale, 0)
			end
			return udim2_4, var2
		end
		if arg2 == 6 then
			local udim2_5 = UDim2.new(0.3, 0, 0.3, 0)
			if arg1 == 1 then
				var2 = UDim2.new(0.5 - udim2_5.X.Scale, 0, 0.5 - udim2_5.Y.Scale, 0)
				return udim2_5, var2
			end
			if arg1 == 2 then
				var2 = UDim2.new(0.5, 0, 0.5 - udim2_5.Y.Scale, 0)
				return udim2_5, var2
			end
			if arg1 == 3 then
				var2 = UDim2.new(0.5 + udim2_5.X.Scale, 0, 0.5 - udim2_5.Y.Scale, 0)
				return udim2_5, var2
			end
			if arg1 == 4 then
				var2 = UDim2.new(0.5 - udim2_5.X.Scale, 0, 0.5 + udim2_5.Y.Scale, 0)
				return udim2_5, var2
			end
			if arg1 == 5 then
				var2 = UDim2.new(0.5, 0, 0.5 + udim2_5.Y.Scale, 0)
				return udim2_5, var2
			end
			if arg1 == 6 then
				var2 = UDim2.new(0.5 + udim2_5.X.Scale, 0, 0.5 + udim2_5.Y.Scale, 0)
			end
			return udim2_5, var2
		end
		if arg2 == 7 then
			local udim2 = UDim2.new(0.2, 0, 0.2, 0)
			if arg1 == 1 then
				var2 = UDim2.new(0.5 - 3 * udim2.X.Scale / 2, 0, 0.5 - udim2.Y.Scale, 0)
				return udim2, var2
			end
			if arg1 == 2 then
				var2 = UDim2.new(0.5 - udim2.X.Scale / 2, 0, 0.5 - udim2.Y.Scale, 0)
				return udim2, var2
			end
			if arg1 == 3 then
				var2 = UDim2.new(0.5 + udim2.X.Scale / 2, 0, 0.5 - udim2.Y.Scale, 0)
				return udim2, var2
			end
			if arg1 == 4 then
				var2 = UDim2.new(0.5 + 3 * udim2.X.Scale / 2, 0, 0.5 - udim2.Y.Scale, 0)
				return udim2, var2
			end
			if arg1 == 5 then
				var2 = UDim2.new(0.5 - udim2.X.Scale, 0, 0.5 + udim2.Y.Scale, 0)
				return udim2, var2
			end
			if arg1 == 6 then
				var2 = UDim2.new(0.5, 0, 0.5 + udim2.Y.Scale, 0)
				return udim2, var2
			end
			if arg1 == 7 then
				var2 = UDim2.new(0.5 + udim2.X.Scale, 0, 0.5 + udim2.Y.Scale, 0)
			end
			return udim2, var2
		end
		if arg2 == 8 then
			local udim2_9 = UDim2.new(0.25, 0, 0.25, 0)
			if arg1 == 1 then
				var2 = UDim2.new(0.5 - 3 * udim2_9.X.Scale / 2, 0, 0.5 - udim2_9.Y.Scale, 0)
				return udim2_9, var2
			end
			if arg1 == 2 then
				var2 = UDim2.new(0.5 - udim2_9.X.Scale / 2, 0, 0.5 - udim2_9.Y.Scale, 0)
				return udim2_9, var2
			end
			if arg1 == 3 then
				var2 = UDim2.new(0.5 + udim2_9.X.Scale / 2, 0, 0.5 - udim2_9.Y.Scale, 0)
				return udim2_9, var2
			end
			if arg1 == 4 then
				var2 = UDim2.new(0.5 + 3 * udim2_9.X.Scale / 2, 0, 0.5 - udim2_9.Y.Scale, 0)
				return udim2_9, var2
			end
			if arg1 == 5 then
				var2 = UDim2.new(0.5 - 3 * udim2_9.X.Scale / 2, 0, 0.5 + udim2_9.Y.Scale, 0)
				return udim2_9, var2
			end
			if arg1 == 6 then
				var2 = UDim2.new(0.5 - udim2_9.X.Scale / 2, 0, 0.5 + udim2_9.Y.Scale, 0)
				return udim2_9, var2
			end
			if arg1 == 7 then
				var2 = UDim2.new(0.5 + udim2_9.X.Scale / 2, 0, 0.5 + udim2_9.Y.Scale, 0)
				return udim2_9, var2
			end
			if arg1 == 8 then
				var2 = UDim2.new(0.5 + 3 * udim2_9.X.Scale / 2, 0, 0.5 + udim2_9.Y.Scale, 0)
			end
			return udim2_9, var2
		end
		if arg2 == 9 then
			local udim2_8 = UDim2.new(0.25, 0, 0.25, 0)
			if arg1 == 1 then
				var2 = UDim2.new(0.5, 0, 0.5 - udim2_8.Y.Scale, 0)
				return udim2_8, var2
			end
			if arg1 == 2 then
				var2 = UDim2.new(0.3, 0, 0.5 - udim2_8.Y.Scale, 0)
				return udim2_8, var2
			end
			if arg1 == 3 then
				var2 = UDim2.new(0.7, 0, 0.5 - udim2_8.Y.Scale, 0)
				return udim2_8, var2
			end
			if arg1 == 4 then
				var2 = UDim2.new(0.9, 0, 0.5 - udim2_8.Y.Scale, 0)
				return udim2_8, var2
			end
			if arg1 == 5 then
				var2 = UDim2.new(0.1, 0, 0.5 - udim2_8.Y.Scale, 0)
				return udim2_8, var2
			end
			if arg1 == 6 then
				var2 = UDim2.new(0.4, 0, 0.5 + udim2_8.Y.Scale, 0)
				return udim2_8, var2
			end
			if arg1 == 7 then
				var2 = UDim2.new(0.6, 0, 0.5 + udim2_8.Y.Scale, 0)
				return udim2_8, var2
			end
			if arg1 == 8 then
				var2 = UDim2.new(0.8, 0, 0.5 + udim2_8.Y.Scale, 0)
				return udim2_8, var2
			end
			if arg1 == 9 then
				var2 = UDim2.new(0.2, 0, 0.5 + udim2_8.Y.Scale, 0)
			end
			return udim2_8, var2
		end
		if arg2 == 10 then
			local udim2_7 = UDim2.new(0.25, 0, 0.25, 0)
			if arg1 == 1 then
				var2 = UDim2.new(0.5, 0, 0.5 - udim2_7.Y.Scale, 0)
				return udim2_7, var2
			end
			if arg1 == 2 then
				var2 = UDim2.new(0.3, 0, 0.5 - udim2_7.Y.Scale, 0)
				return udim2_7, var2
			end
			if arg1 == 3 then
				var2 = UDim2.new(0.9, 0, 0.5 - udim2_7.Y.Scale, 0)
				return udim2_7, var2
			end
			if arg1 == 4 then
				var2 = UDim2.new(0.7, 0, 0.5 - udim2_7.Y.Scale, 0)
				return udim2_7, var2
			end
			if arg1 == 5 then
				var2 = UDim2.new(0.1, 0, 0.5 - udim2_7.Y.Scale, 0)
				return udim2_7, var2
			end
			if arg1 == 6 then
				var2 = UDim2.new(0.5, 0, 0.5 + udim2_7.Y.Scale, 0)
				return udim2_7, var2
			end
			if arg1 == 7 then
				var2 = UDim2.new(0.9, 0, 0.5 + udim2_7.Y.Scale, 0)
				return udim2_7, var2
			end
			if arg1 == 8 then
				var2 = UDim2.new(0.7, 0, 0.5 + udim2_7.Y.Scale, 0)
				return udim2_7, var2
			end
			if arg1 == 9 then
				var2 = UDim2.new(0.3, 0, 0.5 + udim2_7.Y.Scale, 0)
				return udim2_7, var2
			end
			if arg1 == 10 then
				var2 = UDim2.new(0.1, 0, 0.5 + udim2_7.Y.Scale, 0)
			end
			return udim2_7, var2
		end
	end;
}