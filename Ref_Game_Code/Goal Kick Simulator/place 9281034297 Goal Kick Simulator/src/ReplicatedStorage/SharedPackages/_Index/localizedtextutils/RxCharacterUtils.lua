-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:59
-- Luau version 6, Types version 3
-- Time taken: 0.001616 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("RxBrioUtils")
local var1_result1_upvr_3 = any_load_result1("RxInstanceUtils")
local module_upvr = {
	observeLastCharacterBrio = function(arg1) -- Line 21, Named "observeLastCharacterBrio"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr_3 (readonly)
		]]
		return var1_result1_upvr_3.observePropertyBrio(arg1, "Character", function(arg1_2) -- Line 24
			if arg1_2 == nil then
			else
			end
			return true
		end)
	end;
}
function module_upvr.observeLastHumanoidBrio(arg1) -- Line 34
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
	]]
	return module_upvr.observeLastCharacterBrio(arg1):Pipe({var1_result1_upvr.switchMapBrio(function(arg1_3) -- Line 36
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr_3 (copied, readonly)
		]]
		return var1_result1_upvr_3.observeLastNamedChildBrio(arg1_3, "Humanoid", "Humanoid")
	end)})
end
local var1_result1_upvr_4 = any_load_result1("Observable")
local var1_result1_upvr_5 = any_load_result1("Maid")
local var1_result1_upvr_2 = any_load_result1("Brio")
local function observeHumanoidLifetimeAsBrio_upvr(arg1) -- Line 49, Named "observeHumanoidLifetimeAsBrio"
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_4.new(function(arg1_4) -- Line 50
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_5 (copied, readonly)
			[3]: var1_result1_upvr_2 (copied, readonly)
		]]
		if 0 < arg1.Health then
			local any_new_result1 = var1_result1_upvr_5.new()
			any_new_result1._brio = var1_result1_upvr_2.new(arg1)
			arg1_4:Fire(any_new_result1._brio)
			any_new_result1:GiveTask(arg1.Died:Connect(function() -- Line 51, Named "onDeath"
				--[[ Upvalues[1]:
					[1]: arg1_4 (readonly)
				]]
				arg1_4:Complete()
			end))
			return any_new_result1
		end
		arg1_4:Complete()
	end)
end
function module_upvr.observeLastAliveHumanoidBrio(arg1) -- Line 95
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: observeHumanoidLifetimeAsBrio_upvr (readonly)
	]]
	return module_upvr.observeLastHumanoidBrio(arg1):Pipe({var1_result1_upvr.switchMapBrio(function(arg1_5) -- Line 97
		--[[ Upvalues[1]:
			[1]: observeHumanoidLifetimeAsBrio_upvr (copied, readonly)
		]]
		return observeHumanoidLifetimeAsBrio_upvr(arg1_5)
	end)})
end
return module_upvr