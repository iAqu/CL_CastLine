-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:41
-- Luau version 6, Types version 3
-- Time taken: 0.004633 seconds

local var1_upvr = require(script.Parent.loader).load(script)("Promise")
return {
	any = function(arg1) -- Line 17, Named "any"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local any_new_result1_upvr_3 = var1_upvr.new()
		local function resolve(...) -- Line 20
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_3 (readonly)
			]]
			any_new_result1_upvr_3:Resolve(...)
		end
		local function reject(...) -- Line 24
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_3 (readonly)
			]]
			any_new_result1_upvr_3:Reject(...)
		end
		for _, v in pairs(arg1) do
			v:Then(resolve, reject)
		end
		return any_new_result1_upvr_3
	end;
	all = function(arg1) -- Line 46, Named "all"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		if #arg1 == 0 then
			return var1_upvr.resolved()
		end
		if #arg1 == 1 then
			return arg1[1]
		end
		local len_upvw = #arg1
		local any_new_result1_upvr = var1_upvr.new()
		local tbl_upvr = {}
		local var22_upvw = true
		local function _(arg1_2, arg2) -- Line 58, Named "syncronize"
			--[[ Upvalues[5]:
				[1]: var22_upvw (read and write)
				[2]: tbl_upvr (readonly)
				[3]: len_upvw (read and write)
				[4]: any_new_result1_upvr (readonly)
				[5]: arg1 (readonly)
			]]
			return function(arg1_3) -- Line 59
				--[[ Upvalues[7]:
					[1]: var22_upvw (copied, read and write)
					[2]: arg2 (readonly)
					[3]: tbl_upvr (copied, readonly)
					[4]: arg1_2 (readonly)
					[5]: len_upvw (copied, read and write)
					[6]: any_new_result1_upvr (copied, readonly)
					[7]: arg1 (copied, readonly)
				]]
				local var24 = var22_upvw
				if var24 then
					var24 = arg2
				end
				var22_upvw = var24
				tbl_upvr[arg1_2] = arg1_3
				len_upvw -= 1
				local var25 = len_upvw
				if var25 == 0 then
					if var22_upvw then
						var25 = "Resolve"
					else
						var25 = "Reject"
					end
					any_new_result1_upvr[var25](any_new_result1_upvr, unpack(tbl_upvr, 1, #arg1))
				end
			end
		end
		for i_2_upvr, v_2 in pairs(arg1) do
			local var33_upvr = true
			local var34_upvr = false
			function var33_upvr(arg1_5) -- Line 59
				--[[ Upvalues[7]:
					[1]: var22_upvw (read and write)
					[2]: var34_upvr (readonly)
					[3]: tbl_upvr (readonly)
					[4]: i_2_upvr (readonly)
					[5]: len_upvw (read and write)
					[6]: any_new_result1_upvr (readonly)
					[7]: arg1 (readonly)
				]]
				local var35 = var22_upvw
				if var35 then
					var35 = var34_upvr
				end
				var22_upvw = var35
				tbl_upvr[i_2_upvr] = arg1_5
				len_upvw -= 1
				local var36 = len_upvw
				if var36 == 0 then
					if var22_upvw then
						var36 = "Resolve"
					else
						var36 = "Reject"
					end
					any_new_result1_upvr[var36](any_new_result1_upvr, unpack(tbl_upvr, 1, #arg1))
				end
			end
			v_2:Then(function(arg1_4) -- Line 59
				--[[ Upvalues[7]:
					[1]: var22_upvw (read and write)
					[2]: var33_upvr (readonly)
					[3]: tbl_upvr (readonly)
					[4]: i_2_upvr (readonly)
					[5]: len_upvw (read and write)
					[6]: any_new_result1_upvr (readonly)
					[7]: arg1 (readonly)
				]]
				local var31 = var22_upvw
				if var31 then
					var31 = var33_upvr
				end
				var22_upvw = var31
				tbl_upvr[i_2_upvr] = arg1_4
				len_upvw -= 1
				local var32 = len_upvw
				if var32 == 0 then
					if var22_upvw then
						var32 = "Resolve"
					else
						var32 = "Reject"
					end
					any_new_result1_upvr[var32](any_new_result1_upvr, unpack(tbl_upvr, 1, #arg1))
				end
			end, var33_upvr)
			local _
		end
		return any_new_result1_upvr
	end;
	invert = function(arg1) -- Line 84, Named "invert"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		if arg1:IsPending() then
			return arg1:Then(function(...) -- Line 86
				--[[ Upvalues[1]:
					[1]: var1_upvr (copied, readonly)
				]]
				return var1_upvr.rejected(...)
			end, function(...) -- Line 88
				--[[ Upvalues[1]:
					[1]: var1_upvr (copied, readonly)
				]]
				return var1_upvr.resolved(...)
			end)
		end
		local module = {arg1:GetResults()}
		if module[1] then
			return var1_upvr.rejected(unpack(module, 2))
		end
		return var1_upvr.resolved(unpack(module, 2))
	end;
	fromSignal = function(arg1) -- Line 107, Named "fromSignal"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local any_new_result1_upvr_2 = var1_upvr.new()
		local var43_upvw
		any_new_result1_upvr_2:Finally(function() -- Line 111
			--[[ Upvalues[1]:
				[1]: var43_upvw (read and write)
			]]
			var43_upvw:Disconnect()
			var43_upvw = nil
		end)
		var43_upvw = arg1:Connect(function(...) -- Line 116
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_2 (readonly)
			]]
			any_new_result1_upvr_2:Resolve(...)
		end)
		return any_new_result1_upvr_2
	end;
	timeout = function(arg1, arg2) -- Line 131, Named "timeout"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var45
		if type(arg1) ~= "number" then
			var45 = false
		else
			var45 = true
		end
		assert(var45, "Bad timeoutTime")
		var45 = arg2
		assert(var45, "Bad fromPromise")
		if not arg2:IsPending() then
			return arg2
		end
		var45 = var1_upvr
		local any_new_result1_upvr_4 = var45.new()
		var45 = any_new_result1_upvr_4:Resolve
		var45(arg2)
		var45 = task.delay
		var45(arg1, function() -- Line 143
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_4 (readonly)
			]]
			any_new_result1_upvr_4:Reject()
		end)
		return any_new_result1_upvr_4
	end;
}