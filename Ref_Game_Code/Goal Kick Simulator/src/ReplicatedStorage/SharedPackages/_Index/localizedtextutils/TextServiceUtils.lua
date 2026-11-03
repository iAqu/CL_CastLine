-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:10
-- Luau version 6, Types version 3
-- Time taken: 0.001532 seconds

local TextService_upvr = game:GetService("TextService")
local module = {
	getSizeForLabel = function(arg1, arg2, arg3) -- Line 13, Named "getSizeForLabel"
		--[[ Upvalues[1]:
			[1]: TextService_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
		local var3
		if typeof(arg1) ~= "Instance" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad textLabel")
		if type(arg2) ~= "string" then
			var3 = false
			-- KONSTANTWARNING: GOTO [24] #19
		end
		-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
		var3 = true
		assert(var3, "Bad text")
		local var4 = arg3 or 1000000
		if 0 >= var4 then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad maxWidth")
		do
			return TextService_upvr:GetTextSize(arg2, arg1.TextSize, arg1.Font, Vector2.new(var4, 1000000))
		end
		-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
	end;
}
local var5_upvr = require(script.Parent.loader).load(script)("Blend")
function module.observeSizeForLabelProps(arg1) -- Line 23
	--[[ Upvalues[2]:
		[1]: var5_upvr (readonly)
		[2]: TextService_upvr (readonly)
	]]
	assert(arg1.Text, "Bad props.Text")
	assert(arg1.TextSize, "Bad props.TextSize")
	assert(arg1.Font, "Bad props.Font")
	local MaxSize = arg1.MaxSize
	if not MaxSize then
		MaxSize = Vector2.new(1000000, 1000000)
	end
	return var5_upvr.Computed(arg1.Text, arg1.TextSize, arg1.Font, MaxSize, arg1.LineHeight or 1, function(arg1_2, arg2, arg3, arg4, arg5) -- Line 29
		--[[ Upvalues[1]:
			[1]: TextService_upvr (copied, readonly)
		]]
		local any_GetTextSize_result1 = TextService_upvr:GetTextSize(arg1_2, arg2, arg3, arg4)
		return Vector2.new(any_GetTextSize_result1.x, arg5 * any_GetTextSize_result1.y)
	end)
end
return module