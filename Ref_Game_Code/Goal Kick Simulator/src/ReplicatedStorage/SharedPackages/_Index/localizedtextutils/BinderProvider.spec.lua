-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:22
-- Luau version 6, Types version 3
-- Time taken: 0.001450 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_2 = any_load_result1("BinderProvider")
local var1_result1_upvr = any_load_result1("Binder")
return function() -- Line 10
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	describe("BinderProvider.new()", function() -- Line 11
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		local var6_upvw
		local var7_upvw = false
		it("should execute immediately", function() -- Line 15
			--[[ Upvalues[4]:
				[1]: var6_upvw (read and write)
				[2]: var1_result1_upvr_2 (copied, readonly)
				[3]: var7_upvw (read and write)
				[4]: var1_result1_upvr (copied, readonly)
			]]
			var6_upvw = var1_result1_upvr_2.new("BinderServiceName", function(arg1, arg2) -- Line 16
				--[[ Upvalues[2]:
					[1]: var7_upvw (copied, read and write)
					[2]: var1_result1_upvr (copied, readonly)
				]]
				var7_upvw = true
				local var10
				if arg2 ~= 12345 then
					var10 = false
				else
					var10 = true
				end
				assert(var10, "Bad arg")
				arg1:Add(var1_result1_upvr.new("Test", function() -- Line 20
					return {
						Destroy = function() -- Line 21, Named "Destroy"
						end;
					}
				end))
			end)
			expect(var6_upvw).to.be.a("table")
		end)
		it("should initialize", function() -- Line 28
			--[[ Upvalues[2]:
				[1]: var7_upvw (read and write)
				[2]: var6_upvw (read and write)
			]]
			expect(var7_upvw).to.equal(false)
			var6_upvw:Init(12345)
			expect(var7_upvw).to.equal(true)
		end)
		it("should contain the binder", function() -- Line 34
			--[[ Upvalues[1]:
				[1]: var6_upvw (read and write)
			]]
			expect(var6_upvw.Test).to.be.a("table")
		end)
		var6_upvw:Destroy()
	end)
end