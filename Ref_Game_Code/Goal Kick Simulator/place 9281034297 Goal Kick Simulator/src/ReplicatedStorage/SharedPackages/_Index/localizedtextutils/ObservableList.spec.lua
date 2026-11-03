-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:00
-- Luau version 6, Types version 3
-- Time taken: 0.002238 seconds

local var2_upvr = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)("ObservableList")
return function() -- Line 9
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	describe("ObservableList.new()", function() -- Line 10
		--[[ Upvalues[1]:
			[1]: var2_upvr (copied, readonly)
		]]
		local any_new_result1_upvr = var2_upvr.new()
		it("should return nil for unset values", function() -- Line 13
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:Get(1)).to.equal(nil)
		end)
		it("should allow inserting an value", function() -- Line 17
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:GetCount()).to.equal(0)
			any_new_result1_upvr:Add('a')
			expect(any_new_result1_upvr:Get(1)).to.equal('a')
			expect(any_new_result1_upvr:GetCount()).to.equal(1)
		end)
		it("should allow false as a value", function() -- Line 27
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:Get(2)).to.equal(nil)
			any_new_result1_upvr:Add(false)
			expect(any_new_result1_upvr:Get(2)).to.equal(false)
		end)
		it("should fire off events for a specific key", function() -- Line 33
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			local tbl_upvr = {}
			any_new_result1_upvr:InsertAt('c', 1)
			any_new_result1_upvr:ObserveIndex(1):Subscribe(function(arg1) -- Line 35
				--[[ Upvalues[1]:
					[1]: tbl_upvr (readonly)
				]]
				table.insert(tbl_upvr, arg1)
			end):Destroy()
			expect(#tbl_upvr).to.equal(2)
			expect(tbl_upvr[1]).to.equal(1)
			expect(tbl_upvr[2]).to.equal(2)
		end)
		it("should fire off events for all keys", function() -- Line 47
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			local tbl_upvr_2 = {}
			any_new_result1_upvr:Add('a')
			expect(#tbl_upvr_2).to.equal(4)
			expect(tbl_upvr_2[4]:GetValue()).to.equal('a')
			expect(tbl_upvr_2[4]:IsDead()).to.equal(false)
			any_new_result1_upvr:ObserveItemsBrio():Subscribe(function(arg1) -- Line 49
				--[[ Upvalues[1]:
					[1]: tbl_upvr_2 (readonly)
				]]
				table.insert(tbl_upvr_2, arg1)
			end):Destroy()
			expect(#tbl_upvr_2).to.equal(4)
			expect(tbl_upvr_2[4]:IsDead()).to.equal(true)
		end)
		it("should fire off events on removal", function() -- Line 64
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			local tbl_upvr_3 = {}
			any_new_result1_upvr:RemoveAt(1)
			any_new_result1_upvr:ObserveIndex(2):Subscribe(function(arg1) -- Line 66
				--[[ Upvalues[1]:
					[1]: tbl_upvr_3 (readonly)
				]]
				table.insert(tbl_upvr_3, arg1)
			end):Destroy()
			expect(#tbl_upvr_3).to.equal(2)
			expect(tbl_upvr_3[1]).to.equal(2)
			expect(tbl_upvr_3[2]).to.equal(1)
		end)
		it("should clean up", function() -- Line 78
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr:Destroy()
		end)
	end)
end