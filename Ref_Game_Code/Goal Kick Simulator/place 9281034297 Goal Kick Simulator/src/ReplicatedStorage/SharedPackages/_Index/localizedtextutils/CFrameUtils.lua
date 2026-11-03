-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:00
-- Luau version 6, Types version 3
-- Time taken: 0.012829 seconds

return {
	lookAt = function(arg1, arg2, arg3) -- Line 24, Named "lookAt"
		local Unit = (arg1 - arg2).Unit
		local any_Cross_result1_3 = Unit:Cross(arg3 or Vector3.new(0, 1, 0))
		return CFrame.fromMatrix(arg1, any_Cross_result1_3, any_Cross_result1_3:Cross(Unit)):Orthonormalize()
	end;
	redirectLocalAxis = function(arg1, arg2, arg3) -- Line 52, Named "redirectLocalAxis"
		local any_VectorToObjectSpace_result1 = arg1:VectorToObjectSpace(arg3)
		local any_Cross_result1 = arg2:Cross(any_VectorToObjectSpace_result1)
		local cframe = CFrame.new(0, 0, 0, any_Cross_result1.x, any_Cross_result1.y, any_Cross_result1.z, arg2:Dot(any_VectorToObjectSpace_result1) + arg2.magnitude * any_VectorToObjectSpace_result1.magnitude)
		if cframe == cframe then
			return arg1 * cframe
		end
		return arg1
	end;
	fromUpRight = function(arg1, arg2, arg3) -- Line 85, Named "fromUpRight"
		local any_Cross_result1_2 = arg3:Cross(arg2)
		if any_Cross_result1_2.magnitude == 0 then
			return nil
		end
		return CFrame.fromMatrix(arg1, any_Cross_result1_2.Unit:Cross(arg2), arg2)
	end;
	scalePosition = function(arg1, arg2) -- Line 104, Named "scalePosition"
		if arg2 == 1 then
			return arg1
		end
		local Position = arg1.Position
		return arg1 - Position + Position * arg2
	end;
	areClose = function(arg1, arg2, arg3) -- Line 113, Named "areClose"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var269
		if type(arg3) ~= "number" then
			var269 = false
		else
			var269 = true
		end
		assert(var269, "Bad epsilon")
		local any_components_result1_18, any_components_result2_19, any_components_result3_7, any_components_result4_20, any_components_result5_8, any_components_result6_17, any_components_result7_11, any_components_result8_10, any_components_result9_3, any_components_result10_7, any_components_result11_14, any_components_result12_15 = arg1:components()
		local any_components_result1_16, any_components_result2_9, any_components_result3_22, any_components_result4_12, any_components_result5_13, any_components_result6_4, any_components_result7_10, any_components_result8_8, any_components_result9, any_components_result10_16, any_components_result11_13, any_components_result12_14 = arg2:components()
		if math.abs(any_components_result1_16 - any_components_result1_18) <= arg3 then
			if math.abs(any_components_result2_9 - any_components_result2_19) <= arg3 then
				if math.abs(any_components_result3_22 - any_components_result3_7) <= arg3 then
					if math.abs(any_components_result4_12 - any_components_result4_20) <= arg3 then
						if math.abs(any_components_result5_13 - any_components_result5_8) <= arg3 then
							if math.abs(any_components_result6_4 - any_components_result6_17) <= arg3 then
								if math.abs(any_components_result7_10 - any_components_result7_11) <= arg3 then
									if math.abs(any_components_result8_8 - any_components_result8_10) <= arg3 then
										if math.abs(any_components_result9 - any_components_result9_3) <= arg3 then
											if math.abs(any_components_result10_16 - any_components_result10_7) <= arg3 then
												if math.abs(any_components_result11_13 - any_components_result11_14) <= arg3 then
													if math.abs(any_components_result12_14 - any_components_result12_15) > arg3 then
													else
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		return true
	end;
}