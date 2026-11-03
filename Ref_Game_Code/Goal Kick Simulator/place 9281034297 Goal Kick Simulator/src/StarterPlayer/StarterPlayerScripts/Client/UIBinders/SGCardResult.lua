-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:18
-- Luau version 6, Types version 3
-- Time taken: 0.000556 seconds

local module = {}
local tbl = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function tbl.Create(arg1, arg2) -- Line 6
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	Util_upvr.Network.Events.OpenPack = function(...) -- Line 8
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg2 (readonly)
		]]
		Util_upvr.Windows.Object.Enabled = false
		Util_upvr.PackAnimation:SyncCards(arg2, ...)
		Util_upvr.Windows.Object.Enabled = true
	end
	return Util_upvr.Maid.new()
end
module.Binder = tbl
return module