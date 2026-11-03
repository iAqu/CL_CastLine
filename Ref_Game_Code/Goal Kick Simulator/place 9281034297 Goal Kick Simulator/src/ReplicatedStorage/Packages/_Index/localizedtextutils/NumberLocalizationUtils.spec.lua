-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:06
-- Luau version 6, Types version 3
-- Time taken: 0.002803 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("NumberLocalizationUtils")
local any_load_result1_result1_upvr = any_load_result1("RoundingBehaviourTypes")
return function() -- Line 6
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local function checkLocale_upvr(arg1, arg2) -- Line 8, Named "checkLocale"
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr_2 (copied, readonly)
		]]
		for i, v in pairs(arg2) do
			expect(any_load_result1_result1_upvr_2.localize(i, arg1)).to.equal(v)
		end
	end
	local function _(arg1) -- Line 14, Named "checkValid_en_zh"
		--[[ Upvalues[1]:
			[1]: checkLocale_upvr (readonly)
		]]
		checkLocale_upvr(arg1, {'1', -- : First try: K:0: attempt to index nil with 't'
)
	end
	describe("NumberLocalizationUtils.localize", function() -- Line 31
		--[[ Upvalues[1]:
			[1]: checkLocale_upvr (readonly)
		]]
		it("should localize correctly. (en-us)", function() -- Line 53
			--[[ Upvalues[1]:
				[1]: checkLocale_upvr (copied, readonly)
			]]
			checkLocale_upvr("en-us", {'1', -- : First try: K:0: attempt to index nil with 't'
)
		end)
		it("should localize correctly. (en-gb)", function() -- Line 57
			--[[ Upvalues[1]:
				[1]: checkLocale_upvr (copied, readonly)
			]]
			checkLocale_upvr("en-gb", {'1', -- : First try: K:0: attempt to index nil with 't'
)
		end)
		it("should localize correctly. (zh-cn)", function() -- Line 61
			--[[ Upvalues[1]:
				[1]: checkLocale_upvr (copied, readonly)
			]]
			checkLocale_upvr("zh-cn", {'1', -- : First try: K:0: attempt to index nil with 't'
)
		end)
		it("should localize correctly. (zh-tw)", function() -- Line 65
			--[[ Upvalues[1]:
				[1]: checkLocale_upvr (copied, readonly)
			]]
			checkLocale_upvr("zh-tw", {'1', -- : First try: K:0: attempt to index nil with 't'
)
		end)
	end)
	describe("NumberLocalizationUtils.abbreviate", function() -- Line 70
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_2 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		it("should round towards zero when using RoundingBehaviour.Truncate", function() -- Line 71
			--[[ Upvalues[2]:
				[1]: any_load_result1_result1_upvr_2 (copied, readonly)
				[2]: any_load_result1_result1_upvr (copied, readonly)
			]]
			for i_2, v_2 in pairs({'1', -- : First try: K:0: attempt to index nil with 't'
) do
				expect(any_load_result1_result1_upvr_2.abbreviate(i_2, "en-us", any_load_result1_result1_upvr.Truncate)).to.equal(v_2)
			end
		end)
	end)
end