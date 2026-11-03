-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:45
-- Luau version 6, Types version 3
-- Time taken: 0.002083 seconds

local var2_upvr = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)("ObservableMap")
return function() -- Line 9
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	describe("ObservableMap.new()", function() -- Line 10
		--[[ Upvalues[1]:
			[1]: var2_upvr (copied, readonly)
		]]
		local any_new_result1_upvr = var2_upvr.new()
		it("should return nil for unset values", function() -- Line 13
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:Get('a')).to.equal(nil)
		end)
		it("should allow setting a value", function() -- Line 17
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:GetCount()).to.equal(0)
			any_new_result1_upvr:Set('a', "Hello World")
			expect(any_new_result1_upvr:Get('a')).to.equal("Hello World")
			expect(any_new_result1_upvr:GetCount()).to.equal(1)
		end)
		it("should overwrite values", function() -- Line 26
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:Get('a')).to.equal("Hello World")
			any_new_result1_upvr:Set('a', "Hello World 2")
			expect(any_new_result1_upvr:Get('a')).to.equal("Hello World 2")
		end)
		it("should allow false as a key", function() -- Line 34
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			expect(any_new_result1_upvr:Get(false)).to.equal(nil)
			any_new_result1_upvr:Set(false, "Hello")
			expect(any_new_result1_upvr:Get(false)).to.equal("Hello")
		end)
		it("should fire off events for a specific key", function() -- Line 40
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			local tbl_upvr_2 = {}
			any_new_result1_upvr:Set('c', "Hello")
			any_new_result1_upvr:ObserveValueForKey('c'):Subscribe(function(arg1) -- Line 42
				--[[ Upvalues[1]:
					[1]: tbl_upvr_2 (readonly)
				]]
				table.insert(tbl_upvr_2, arg1)
			end):Destroy()
			expect(#tbl_upvr_2).to.equal(1)
			expect(tbl_upvr_2[1]).to.equal("Hello")
		end)
		it("should fire off events for all keys", function() -- Line 53
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			local tbl_upvr = {}
			any_new_result1_upvr:Set('d', "Hello")
			expect(#tbl_upvr).to.equal(4)
			expect(tbl_upvr[4]:GetValue()).to.equal("Hello")
			expect(tbl_upvr[4]:IsDead()).to.equal(false)
			any_new_result1_upvr:ObserveValuesBrio():Subscribe(function(arg1) -- Line 55
				--[[ Upvalues[1]:
					[1]: tbl_upvr (readonly)
				]]
				table.insert(tbl_upvr, arg1)
			end):Destroy()
			expect(#tbl_upvr).to.equal(4)
			expect(tbl_upvr[4]:IsDead()).to.equal(true)
		end)
		it("should clean up", function() -- Line 70
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr:Destroy()
		end)
	end)
end