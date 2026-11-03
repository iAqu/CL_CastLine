-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:43
-- Luau version 6, Types version 3
-- Time taken: 0.002420 seconds

local module_upvr = {}
local Network_upvr = require(script.Parent.Network)
if game:GetService("RunService"):IsServer() then
	function module_upvr.PlayLocal(arg1, arg2, ...) -- Line 9
		--[[ Upvalues[1]:
			[1]: Network_upvr (readonly)
		]]
		Network_upvr:Fire(arg2, "PlayLocal", ...)
	end
	function module_upvr.PlayLocalAt(arg1, arg2, ...) -- Line 12
		--[[ Upvalues[1]:
			[1]: Network_upvr (readonly)
		]]
		Network_upvr:Fire(arg2, "PlayLocalAt", ...)
	end
else
	Network_upvr.Events.PlayLocal = function(...) -- Line 16
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		module_upvr:Play(...)
	end
	Network_upvr.Events.PlayLocalAt = function(...) -- Line 19
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		module_upvr:PlayAt(...)
	end
end
local SoundService_upvr = game:GetService("SoundService")
function module_upvr.Play(arg1, arg2, arg3, ...) -- Line 24
	--[[ Upvalues[1]:
		[1]: SoundService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1, pairs_result2, pairs_result3_2 = pairs(SoundService_upvr:GetDescendants())
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [40] 32. Error Block 9 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [40] 32. Error Block 9 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [10] 9. Error Block 40 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [40.9]
	local function INLINED() -- Internal function, doesn't exist in bytecode
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		return nil
	end
	local function INLINED_2() -- Internal function, doesn't exist in bytecode
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		return nil
	end
	if nil == arg2 and (INLINED() or INLINED_2()) then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if nil then
		end
		if not nil then return end
		local function INLINED_3() -- Internal function, doesn't exist in bytecode
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			return nil.Playing
		end
		local function INLINED_4() -- Internal function, doesn't exist in bytecode
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			return nil.Looped
		end
		if arg3 or INLINED_3() or INLINED_4() then
			nil:Clone():Stop()
			local var9 = arg3
			if not var9 then
				var9 = SoundService_upvr
			end
		end
		local _, _, pairs_result3 = pairs(nil:Clone():GetAttributes())
		-- KONSTANTWARNING: GOTO [70] #55
	end
	-- KONSTANTERROR: [10] 9. Error Block 40 end (CF ANALYSIS FAILED)
end
function module_upvr.PlayAt(arg1, arg2, arg3, ...) -- Line 68
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local Part_upvr = Instance.new("Part")
	Part_upvr.Size = Vector3.new()
	Part_upvr.Anchored = true
	Part_upvr.Massless = true
	Part_upvr.CanCollide = false
	Part_upvr.Position = arg2
	Part_upvr.Transparency = 1
	local any_Play_result1 = module_upvr:Play(arg3, Part_upvr, ...)
	if any_Play_result1 then
		local var16_upvw
		var16_upvw = any_Play_result1.Ended:Connect(function() -- Line 79
			--[[ Upvalues[2]:
				[1]: var16_upvw (read and write)
				[2]: Part_upvr (readonly)
			]]
			var16_upvw:Disconnect()
			Part_upvr:Destroy()
		end)
		Part_upvr.Parent = workspace.Ignore
		return any_Play_result1
	end
	Part_upvr:Destroy()
end
return module_upvr