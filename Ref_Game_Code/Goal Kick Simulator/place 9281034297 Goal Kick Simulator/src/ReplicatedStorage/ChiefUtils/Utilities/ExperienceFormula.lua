-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:28
-- Luau version 6, Types version 3
-- Time taken: 0.002658 seconds

local module_upvr = {}
local floor_upvr = math.floor
local tbl_upvr = {
	Fast = function(arg1) -- Line 6, Named "Fast"
		return 0.8 * arg1 ^ 3
	end;
	MediumFast = function(arg1) -- Line 9, Named "MediumFast"
		return arg1 ^ 3
	end;
	MediumSlow = function(arg1) -- Line 12, Named "MediumSlow"
		return 1.2 * arg1 ^ 3
	end;
	Slow = function(arg1) -- Line 15, Named "Slow"
		return 1.25 * arg1 ^ 3
	end;
	Fluctuating = function(arg1) -- Line 18, Named "Fluctuating"
		--[[ Upvalues[1]:
			[1]: floor_upvr (readonly)
		]]
		if arg1 < 15 then
			return (floor_upvr((arg1 + 1) / 3) + 24) / 50 * arg1 ^ 3
		end
		if arg1 < 36 then
			return (arg1 + 14) / 50 * arg1 ^ 3
		end
		return (floor_upvr(arg1 / 2) + 32) / 50 * arg1 ^ 3
	end;
	Erratic = function(arg1) -- Line 27, Named "Erratic"
		--[[ Upvalues[1]:
			[1]: floor_upvr (readonly)
		]]
		if arg1 < 50 then
			return arg1 ^ 3 * (100 - arg1) / 50
		end
		if arg1 < 68 then
			return arg1 ^ 3 * (150 - arg1) / 100
		end
		if arg1 <= 98 then
			return arg1 ^ 3 * floor_upvr((1911 - arg1 * 10) / 3) / 500
		end
		return arg1 ^ 3 * (160 - arg1) / 100
	end;
}
function module_upvr.CalculateLevelExperience(arg1, arg2, arg3) -- Line 40
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	assert(arg3, "Level was not given!")
	local var4 = arg2
	if var4 then
		var4 = tbl_upvr[arg2]
	end
	assert(var4, "ExperienceType is invalid!")
	return var4(arg3)
end
function module_upvr.GetExperienceNeeded(arg1, arg2, arg3) -- Line 47
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr:CalculateLevelExperience(arg2, arg3 + 1) - module_upvr:CalculateLevelExperience(arg2, arg3)
end
return module_upvr