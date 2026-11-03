-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:19
-- Luau version 6, Types version 3
-- Time taken: 0.001431 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink()
	local function CheckFrame_upvr(arg1_2) -- Line 10, Named "CheckFrame"
		--[[ Upvalues[3]:
			[1]: any_GetLink_result1_upvr (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		if arg1_2:IsA("ImageButton") then
			arg1_2.AutoSell.Visible = any_GetLink_result1_upvr.AutoSellStar[arg1_2.Name]
			any_GetLink_result1_upvr.AutoSellStar.Changed:On(arg1_2.Name, function(arg1_3) -- Line 12, Named "UpdateIsSelling"
				--[[ Upvalues[1]:
					[1]: arg1_2 (readonly)
				]]
				arg1_2.AutoSell.Visible = arg1_3
			end)
			any_new_result1_upvr[arg1_2] = arg1_2.MouseButton1Click:Connect(function() -- Line 17
				--[[ Upvalues[2]:
					[1]: Util_upvr (copied, readonly)
					[2]: arg1_2 (readonly)
				]]
				Util_upvr.Network:Fire("ToggleAutoSellStar", arg1_2.Name)
			end)
		end
	end
	local any_Sync_result1 = Util_upvr.Streamer:Sync(arg1, "Chances")
	any_new_result1_upvr:GiveTask(any_Sync_result1)
	any_new_result1_upvr:GiveTask(any_Sync_result1.Loaded:Connect(function(arg1_4) -- Line 26
		--[[ Upvalues[2]:
			[1]: any_new_result1_upvr (readonly)
			[2]: CheckFrame_upvr (readonly)
		]]
		any_new_result1_upvr.TrackOnAdded = arg1_4.Content.ChildAdded:Connect(CheckFrame_upvr)
		for _, v in pairs(arg1_4.Content:GetChildren()) do
			CheckFrame_upvr(v)
		end
		any_new_result1_upvr.TrackOnRemoved = arg1_4.Content.ChildRemoved:Connect(function(arg1_5) -- Line 31
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (copied, readonly)
			]]
			if any_new_result1_upvr[arg1_5] then
				any_new_result1_upvr[arg1_5] = nil
			end
		end)
	end))
	return any_new_result1_upvr
end
return module