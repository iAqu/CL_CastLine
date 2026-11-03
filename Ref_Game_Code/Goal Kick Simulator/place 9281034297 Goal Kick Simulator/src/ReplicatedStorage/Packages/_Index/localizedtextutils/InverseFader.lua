-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:13
-- Luau version 6, Types version 3
-- Time taken: 0.001110 seconds

local module_upvr = {
	ClassName = "InverseFader";
}
function module_upvr.new(arg1, arg2) -- Line 13
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	local var3 = arg1
	if not var3 then
		var3 = error("No camera")
	end
	setmetatable_result1._camera = var3
	var3 = arg2
	local var4 = var3
	if not var4 then
		var4 = error("No fader")
	end
	setmetatable_result1._fader = var4
	return setmetatable_result1
end
local var5_upvr = require(script.Parent.loader).load(script)("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 22
	--[[ Upvalues[1]:
		[1]: var5_upvr (readonly)
	]]
	return var5_upvr.new(arg1, arg2)
end
function module_upvr.__index(arg1, arg2) -- Line 26
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local CameraState = arg1._camera.CameraState
		if not CameraState then
			CameraState = arg1._camera
		end
		return CameraState * (1 - arg1._fader.Value)
	end
	return module_upvr[arg2]
end
return module_upvr