-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:18
-- Luau version 6, Types version 3
-- Time taken: 0.001179 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_2 = any_load_result1("ObservableSortedList")
local var1_result1_upvr = any_load_result1("Rx")
return function() -- Line 10
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	describe("ObservableSortedList.new()", function() -- Line 11
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		local any_new_result1_upvr = var1_result1_upvr_2.new()
		it("should return nil for unset values", function() -- Line 14
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:Get(1)).to.equal(nil)
		end)
		it("should allow inserting an value", function() -- Line 18
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr (readonly)
				[2]: var1_result1_upvr (copied, readonly)
			]]
			expect(any_new_result1_upvr:GetCount()).to.equal(0)
			any_new_result1_upvr:Add('b', var1_result1_upvr.of('b'))
			expect(any_new_result1_upvr:Get(1)).to.equal('b')
			expect(any_new_result1_upvr:GetCount()).to.equal(1)
		end)
		it("should sort the items", function() -- Line 27
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr (readonly)
				[2]: var1_result1_upvr (copied, readonly)
			]]
			expect(any_new_result1_upvr:GetCount()).to.equal(1)
			any_new_result1_upvr:Add('a', var1_result1_upvr.of('a'))
			expect(any_new_result1_upvr:Get(1)).to.equal('a')
			expect(any_new_result1_upvr:Get(2)).to.equal('b')
			expect(any_new_result1_upvr:GetCount()).to.equal(2)
		end)
	end)
end