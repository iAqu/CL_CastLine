-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:42
-- Luau version 6, Types version 3
-- Time taken: 0.003630 seconds

local module = {}
local function _(arg1) -- Line 11, Named "SCurveTranform"
	local clamped = math.clamp(arg1, -1, 1)
	if 0 <= clamped then
		return 0.35 * clamped / (0.35 - clamped + 1)
	end
	return -(0.8 * -clamped / (0.8 + clamped + 1))
end
local function _(arg1) -- Line 20, Named "toSCurveSpace"
	return (math.abs(arg1) * 2 - 1) * 1.1 - 0.1
end
local function _(arg1) -- Line 24, Named "fromSCurveSpace"
	return arg1 / 2 + 0.5
end
function module.outOfDeadZone(arg1) -- Line 28
	local var3
	if 0.1 > arg1.Position.Magnitude then
		var3 = false
	else
		var3 = true
	end
	return var3
end
function module.gamepadLinearToCurve(arg1) -- Line 33
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local function _(arg1_2) -- Line 34, Named "onAxis"
		local var4 = 1
		local var5
		if arg1_2 < 0 then
			var4 = -1
		end
		local clamped_2 = math.clamp((math.abs(math.abs(arg1_2)) * 2 - 1) * 1.1 - 0.1, -1, 1)
		if 0 <= clamped_2 then
			var5 = 0.35 * clamped_2 / (0.35 - clamped_2 + 1)
		else
			var5 = -(0.8 * -clamped_2 / (0.8 + clamped_2 + 1))
		end
		var5 = math.clamp((var5 / 2 + 0.5) * var4, -1, 1)
		return var5
	end
	local x = arg1.x
	local var8 = 1
	local var9
	if x < 0 then
		var8 = -1
	end
	local clamped_3 = math.clamp((math.abs(math.abs(x)) * 2 - 1) * 1.1 - 0.1, -1, 1)
	if 0 <= clamped_3 then
		var9 = 0.35 * clamped_3 / (0.35 - clamped_3 + 1)
	else
		var9 = -(0.8 * -clamped_3 / (0.8 + clamped_3 + 1))
	end
	var9 = math.clamp((var9 / 2 + 0.5) * var8, -1, 1)
	local y = arg1.y
	local var12 = 1
	var9 = 0
	if y < var9 then
		var12 = -1
	end
	if 0 <= math.clamp((math.abs(math.abs(y)) * 2 - 1) * 1.1 - 0.1, -1, 1) then
	else
	end
	var9 = -(0.8 * -math.clamp((math.abs(math.abs(y)) * 2 - 1) * 1.1 - 0.1, -1, 1) / (0.8 + math.clamp((math.abs(math.abs(y)) * 2 - 1) * 1.1 - 0.1, -1, 1) + 1)) / 2 + 0.5
	var9 *= var12
	return Vector2.new(var9, math.clamp(var9, -1, 1))
end
return module