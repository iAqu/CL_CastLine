-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:35
-- Luau version 6, Types version 3
-- Time taken: 0.001120 seconds

local module = {}
local function _(arg1) -- Line 9, Named "checkAttachment"
	local var2
	if arg1.Name:sub(1, 8) ~= "DmgPoint" then
		var2 = false
	else
		var2 = true
	end
	return var2
end
local Maid_upvr = require(script.Parent.Maid)
local Thread_upvr = require(script.Parent.Thread)
local Vector_upvr = require(script.Parent.Parent.Numerical.Vector)
local VectorViewer_upvr = require(script.Parent.VectorViewer)
function module.ListenHits(arg1, arg2, arg3) -- Line 13
	--[[ Upvalues[4]:
		[1]: Maid_upvr (readonly)
		[2]: Thread_upvr (readonly)
		[3]: Vector_upvr (readonly)
		[4]: VectorViewer_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [6] 5. Error Block 2 start (CF ANALYSIS FAILED)
	warn("Object must be parented under workspace.")
	do
		return
	end
	-- KONSTANTERROR: [6] 5. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [12] 10. Error Block 3 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [12] 10. Error Block 3 end (CF ANALYSIS FAILED)
end
return module