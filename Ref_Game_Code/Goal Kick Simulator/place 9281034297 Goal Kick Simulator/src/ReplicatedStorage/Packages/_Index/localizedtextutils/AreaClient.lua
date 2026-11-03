-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:40
-- Luau version 6, Types version 3
-- Time taken: 0.000504 seconds

local var1_upvr = require(script.Parent.loader).load(script)("AreaBase")
local setmetatable_result1_2_upvr = setmetatable({}, var1_upvr)
setmetatable_result1_2_upvr.ClassName = "AreaClient"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1, arg2) -- Line 16
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_upvr.new(arg1), setmetatable_result1_2_upvr)
	setmetatable_result1._serviceBag = assert(arg2, "Bad serviceBag")
	return setmetatable_result1
end
return setmetatable_result1_2_upvr