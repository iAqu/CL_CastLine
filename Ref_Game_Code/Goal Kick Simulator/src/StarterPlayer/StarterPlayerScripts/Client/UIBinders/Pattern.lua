-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:41
-- Luau version 6, Types version 3
-- Time taken: 0.001374 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local Tiles_upvr = arg1:WaitForChild("Tiles", 5)
	Tiles_upvr.Size = UDim2.new(3, 0, 3, 0)
	any_new_result1.Tweening = Util_upvr.Thread.Loop(function() -- Line 10
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: Tiles_upvr (readonly)
		]]
		if Util_upvr:IsGuiObjectVisible(arg1) then
			local os_clock_result1 = os.clock()
			if Util_upvr:IsGuiObjectVisible(arg1) then
				Tiles_upvr.Position = UDim2.new(0.5, math.sin(os_clock_result1) * Tiles_upvr.TileSize.X.Offset, 0.5, os_clock_result1 * 30 % Tiles_upvr.TileSize.Y.Offset)
			end
		end
	end)
	return any_new_result1
end
return module