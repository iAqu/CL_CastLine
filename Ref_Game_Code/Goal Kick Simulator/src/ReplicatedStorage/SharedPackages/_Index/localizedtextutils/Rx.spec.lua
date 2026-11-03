-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:00
-- Luau version 6, Types version 3
-- Time taken: 0.001580 seconds

local var2_upvr = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)("Rx")
return function() -- Line 9
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	describe("Rx.combineLatest({})", function() -- Line 10
		--[[ Upvalues[1]:
			[1]: var2_upvr (copied, readonly)
		]]
		local any_combineLatest_result1_upvr_2 = var2_upvr.combineLatest({})
		local var6_upvw
		it("should execute immediately", function() -- Line 14
			--[[ Upvalues[2]:
				[1]: any_combineLatest_result1_upvr_2 (readonly)
				[2]: var6_upvw (read and write)
			]]
			expect(var6_upvw).to.be.a("table")
			any_combineLatest_result1_upvr_2:Subscribe(function(arg1) -- Line 15
				--[[ Upvalues[1]:
					[1]: var6_upvw (copied, read and write)
				]]
				var6_upvw = arg1
			end):Destroy()
		end)
	end)
	describe("Rx.combineLatest({ value = 5 })", function() -- Line 24
		--[[ Upvalues[1]:
			[1]: var2_upvr (copied, readonly)
		]]
		local any_combineLatest_result1_upvr = var2_upvr.combineLatest({
			value = 5;
		})
		local var12_upvw
		it("should execute immediately", function() -- Line 28
			--[[ Upvalues[2]:
				[1]: any_combineLatest_result1_upvr (readonly)
				[2]: var12_upvw (read and write)
			]]
			expect(var12_upvw).to.be.a("table")
			expect(var12_upvw.value).to.equal(5)
			any_combineLatest_result1_upvr:Subscribe(function(arg1) -- Line 29
				--[[ Upvalues[1]:
					[1]: var12_upvw (copied, read and write)
				]]
				var12_upvw = arg1
			end):Destroy()
		end)
	end)
	describe("Rx.combineLatest({ value = Rx.of(5) })", function() -- Line 39
		--[[ Upvalues[1]:
			[1]: var2_upvr (copied, readonly)
		]]
		local any_combineLatest_result1_upvr_3 = var2_upvr.combineLatest({
			value = var2_upvr.of(5);
		})
		local var18_upvw
		it("should execute immediately", function() -- Line 43
			--[[ Upvalues[2]:
				[1]: any_combineLatest_result1_upvr_3 (readonly)
				[2]: var18_upvw (read and write)
			]]
			expect(var18_upvw).to.be.a("table")
			expect(var18_upvw.value).to.equal(5)
			any_combineLatest_result1_upvr_3:Subscribe(function(arg1) -- Line 44
				--[[ Upvalues[1]:
					[1]: var18_upvw (copied, read and write)
				]]
				var18_upvw = arg1
			end):Destroy()
		end)
	end)
end