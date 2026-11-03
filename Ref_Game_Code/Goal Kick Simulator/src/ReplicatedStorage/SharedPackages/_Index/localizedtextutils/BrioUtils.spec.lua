-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:44
-- Luau version 6, Types version 3
-- Time taken: 0.003103 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_2 = any_load_result1("BrioUtils")
local var1_result1_upvr = any_load_result1("Brio")
return function() -- Line 10
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	describe("BrioUtils.flatten({})", function() -- Line 11
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		local any_flatten_result1_upvr_2 = var1_result1_upvr_2.flatten({})
		describe("should return a brio that", function() -- Line 14
			--[[ Upvalues[2]:
				[1]: any_flatten_result1_upvr_2 (readonly)
				[2]: var1_result1_upvr (copied, readonly)
			]]
			it("is a brio", function() -- Line 15
				--[[ Upvalues[2]:
					[1]: any_flatten_result1_upvr_2 (copied, readonly)
					[2]: var1_result1_upvr (copied, readonly)
				]]
				expect(any_flatten_result1_upvr_2).to.be.a("table")
				expect(var1_result1_upvr.isBrio(any_flatten_result1_upvr_2)).to.equal(true)
			end)
			it("is alive", function() -- Line 20
				--[[ Upvalues[1]:
					[1]: any_flatten_result1_upvr_2 (copied, readonly)
				]]
				expect(not any_flatten_result1_upvr_2:IsDead()).to.equal(true)
			end)
			it("contains a table", function() -- Line 24
				--[[ Upvalues[1]:
					[1]: any_flatten_result1_upvr_2 (copied, readonly)
				]]
				expect(any_flatten_result1_upvr_2:GetValue()).to.be.a("table")
			end)
			it("contains a table with nothing in it", function() -- Line 28
				--[[ Upvalues[1]:
					[1]: any_flatten_result1_upvr_2 (copied, readonly)
				]]
				expect(next(any_flatten_result1_upvr_2:GetValue())).to.equal(nil)
			end)
		end)
	end)
	describe("BrioUtils.flatten with out a brio in it", function() -- Line 34
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		local any_flatten_result1_upvr = var1_result1_upvr_2.flatten({
			value = 5;
		})
		describe("should return a brio that", function() -- Line 39
			--[[ Upvalues[2]:
				[1]: any_flatten_result1_upvr (readonly)
				[2]: var1_result1_upvr (copied, readonly)
			]]
			it("is a brio", function() -- Line 40
				--[[ Upvalues[2]:
					[1]: any_flatten_result1_upvr (copied, readonly)
					[2]: var1_result1_upvr (copied, readonly)
				]]
				expect(any_flatten_result1_upvr).to.be.a("table")
				expect(var1_result1_upvr.isBrio(any_flatten_result1_upvr)).to.equal(true)
			end)
			it("is alive", function() -- Line 45
				--[[ Upvalues[1]:
					[1]: any_flatten_result1_upvr (copied, readonly)
				]]
				expect(not any_flatten_result1_upvr:IsDead()).to.equal(true)
			end)
			it("contains a table", function() -- Line 49
				--[[ Upvalues[1]:
					[1]: any_flatten_result1_upvr (copied, readonly)
				]]
				expect(any_flatten_result1_upvr:GetValue()).to.be.a("table")
			end)
			it("contains a table with value", function() -- Line 53
				--[[ Upvalues[1]:
					[1]: any_flatten_result1_upvr (copied, readonly)
				]]
				expect(any_flatten_result1_upvr:GetValue().value).to.equal(5)
			end)
		end)
	end)
	describe("BrioUtils.flatten a dead brio in it", function() -- Line 59
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		local any_flatten_result1_upvr_3 = var1_result1_upvr_2.flatten({
			value = var1_result1_upvr.DEAD;
		})
		describe("should return a brio that", function() -- Line 64
			--[[ Upvalues[2]:
				[1]: any_flatten_result1_upvr_3 (readonly)
				[2]: var1_result1_upvr (copied, readonly)
			]]
			it("is a brio", function() -- Line 65
				--[[ Upvalues[2]:
					[1]: any_flatten_result1_upvr_3 (copied, readonly)
					[2]: var1_result1_upvr (copied, readonly)
				]]
				expect(any_flatten_result1_upvr_3).to.be.a("table")
				expect(var1_result1_upvr.isBrio(any_flatten_result1_upvr_3)).to.equal(true)
			end)
			it("is dead", function() -- Line 70
				--[[ Upvalues[1]:
					[1]: any_flatten_result1_upvr_3 (copied, readonly)
				]]
				expect(any_flatten_result1_upvr_3:IsDead()).to.equal(true)
			end)
		end)
	end)
end