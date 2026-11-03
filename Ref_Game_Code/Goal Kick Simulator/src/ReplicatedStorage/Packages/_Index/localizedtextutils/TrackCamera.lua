-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:04
-- Luau version 6, Types version 3
-- Time taken: 0.003897 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "TrackCamera";
	FieldOfView = 0;
}
function module_upvr.new(arg1) -- Line 21
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.CameraSubject = arg1
	return setmetatable_result1
end
local var1_result1_upvr_2 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 29
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_2.new(arg1, arg2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 33
	if arg2 == "CameraSubject" then
		local var8 = false
		if typeof(arg3) == "Instance" then
			var8 = arg3:IsA("BasePart")
			if not var8 then
				var8 = arg3:IsA("Model")
				if not var8 then
					var8 = arg3:IsA("Attachment")
					if not var8 then
						var8 = arg3:IsA("Humanoid")
					end
				end
			end
		end
		assert(var8, "CameraSubject must be a Roblox Model, Roblox Part, Attachment, Humanoid, or nil")
		rawset(arg1, arg2, arg3)
	else
		if arg2 == "FieldOfView" then
			rawset(arg1, arg2, arg3)
			return
		end
		error(arg2.." is not a valid member of TrackCamera")
	end
end
local var1_result1_upvr = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 64
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [79] 55. Error Block 16 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [79.2]
	do
		return nil
	end
	-- KONSTANTERROR: [79] 55. Error Block 16 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [80] 56. Error Block 17 start (CF ANALYSIS FAILED)
	do
		return module_upvr[arg2]
	end
	-- KONSTANTERROR: [80] 56. Error Block 17 end (CF ANALYSIS FAILED)
end
return module_upvr