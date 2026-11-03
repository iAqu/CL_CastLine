-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:18
-- Luau version 6, Types version 3
-- Time taken: 0.004084 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_4 = any_load_result1("Observable")
local var1_result1_upvr_3 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("Rx")
local var1_result1_upvr_5 = any_load_result1("BasicPane")
local module_upvr = {
	observeVisible = function(arg1) -- Line 27, Named "observeVisible"
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_5 (readonly)
			[2]: var1_result1_upvr_4 (readonly)
			[3]: var1_result1_upvr_3 (readonly)
		]]
		assert(var1_result1_upvr_5.isBasicPane(arg1), "Bad BasicPane")
		return var1_result1_upvr_4.new(function(arg1_2) -- Line 30
			--[[ Upvalues[2]:
				[1]: var1_result1_upvr_3 (copied, readonly)
				[2]: arg1 (readonly)
			]]
			local any_new_result1_3 = var1_result1_upvr_3.new()
			any_new_result1_3:GiveTask(arg1.VisibleChanged:Connect(function(arg1_3) -- Line 33
				--[[ Upvalues[1]:
					[1]: arg1_2 (readonly)
				]]
				arg1_2:Fire(arg1_3)
			end))
			arg1_2:Fire(arg1:IsVisible())
			return any_new_result1_3
		end)
	end;
}
local var1_result1_upvr_2 = any_load_result1("Brio")
function module_upvr.whenVisibleBrio(arg1) -- Line 67
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr_5 (readonly)
		[4]: var1_result1_upvr_2 (readonly)
	]]
	return function(arg1_4) -- Line 68
		--[[ Upvalues[5]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: var1_result1_upvr_3 (copied, readonly)
			[3]: arg1 (readonly)
			[4]: var1_result1_upvr_5 (copied, readonly)
			[5]: var1_result1_upvr_2 (copied, readonly)
		]]
		return var1_result1_upvr_4.new(function(arg1_5) -- Line 69
			--[[ Upvalues[5]:
				[1]: var1_result1_upvr_3 (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: var1_result1_upvr_5 (copied, readonly)
				[4]: var1_result1_upvr_2 (copied, readonly)
				[5]: arg1_4 (readonly)
			]]
			local any_new_result1_2_upvr = var1_result1_upvr_3.new()
			local var14_upvw
			local function ensurePane_upvr() -- Line 74, Named "ensurePane"
				--[[ Upvalues[7]:
					[1]: var14_upvw (read and write)
					[2]: var1_result1_upvr_3 (copied, readonly)
					[3]: arg1 (copied, readonly)
					[4]: var1_result1_upvr_5 (copied, readonly)
					[5]: var1_result1_upvr_2 (copied, readonly)
					[6]: any_new_result1_2_upvr (readonly)
					[7]: arg1_5 (readonly)
				]]
				if var14_upvw then
					return var14_upvw
				end
				local any_new_result1 = var1_result1_upvr_3.new()
				local arg1_result1_upvr = arg1(any_new_result1)
				assert(var1_result1_upvr_5.isBasicPane(arg1_result1_upvr), "Bad BasicPane")
				any_new_result1:GiveTask(arg1_result1_upvr)
				local any_new_result1_4 = var1_result1_upvr_2.new(arg1_result1_upvr.Gui)
				any_new_result1:GiveTask(any_new_result1_4)
				var14_upvw = arg1_result1_upvr
				any_new_result1_2_upvr:GiveTask(function() -- Line 90
					--[[ Upvalues[2]:
						[1]: var14_upvw (copied, read and write)
						[2]: arg1_result1_upvr (readonly)
					]]
					if var14_upvw == arg1_result1_upvr then
						var14_upvw = nil
					end
				end)
				any_new_result1_2_upvr._currentPaneMaid = any_new_result1
				arg1_5:Fire(any_new_result1_4)
				return var14_upvw
			end
			any_new_result1_2_upvr:GiveTask(arg1_4:Subscribe(function(arg1_6) -- Line 104
				--[[ Upvalues[3]:
					[1]: any_new_result1_2_upvr (readonly)
					[2]: ensurePane_upvr (readonly)
					[3]: var14_upvw (read and write)
				]]
				if arg1_6 then
					any_new_result1_2_upvr._hideTask = nil
					ensurePane_upvr():Show()
				elseif var14_upvw and var14_upvw:IsVisible() then
					var14_upvw:Hide()
					any_new_result1_2_upvr._hideTask = task.delay(1, function() -- Line 111
						--[[ Upvalues[2]:
							[1]: var14_upvw (copied, read and write)
							[2]: any_new_result1_2_upvr (copied, readonly)
						]]
						var14_upvw = nil
						any_new_result1_2_upvr._currentPaneMaid = nil
					end)
				end
			end))
			return any_new_result1_2_upvr
		end)
	end
end
function module_upvr.observePercentVisible(arg1) -- Line 130
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: module_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	assert(var1_result1_upvr_5.isBasicPane(arg1), "Bad BasicPane")
	return module_upvr.observeVisible(arg1):Pipe({var1_result1_upvr.map(function(arg1_7) -- Line 134
		if arg1_7 then
			return 1
		end
		return 0
	end), var1_result1_upvr.startWith({0})})
end
module_upvr.toTransparency = var1_result1_upvr.map(function(arg1) -- Line 149
	return 1 - arg1
end)
function module_upvr.observeShow(arg1) -- Line 160
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	return module_upvr.observeVisible(arg1):Pipe({var1_result1_upvr.where(function(arg1_8) -- Line 162
		return arg1_8
	end)})
end
return module_upvr