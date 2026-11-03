-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:19
-- Luau version 6, Types version 3
-- Time taken: 0.001228 seconds

local var2_upvr = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)("ObservableCountingMap")
return function() -- Line 9
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	describe("ObservableCountingMap.new()", function() -- Line 10
		--[[ Upvalues[1]:
			[1]: var2_upvr (copied, readonly)
		]]
		local any_new_result1_upvr = var2_upvr.new()
		it("should return 0 for unset values", function() -- Line 13
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:Get('a')).to.equal(0)
			expect(any_new_result1_upvr:GetTotalKeyCount()).to.equal(0)
		end)
		it("should allow you to add to a value", function() -- Line 18
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:Get('a')).to.equal(0)
			expect(any_new_result1_upvr:GetTotalKeyCount()).to.equal(0)
			any_new_result1_upvr:Add('a', 5)
			expect(any_new_result1_upvr:Get('a')).to.equal(5)
			expect(any_new_result1_upvr:GetTotalKeyCount()).to.equal(1)
		end)
		it("should allow you to add to a value that is already defined", function() -- Line 26
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:Get('a')).to.equal(5)
			expect(any_new_result1_upvr:GetTotalKeyCount()).to.equal(1)
			any_new_result1_upvr:Add('a', 5)
			expect(any_new_result1_upvr:Get('a')).to.equal(10)
			expect(any_new_result1_upvr:GetTotalKeyCount()).to.equal(1)
		end)
		it("should clean up", function() -- Line 34
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr:Destroy()
		end)
	end)
end