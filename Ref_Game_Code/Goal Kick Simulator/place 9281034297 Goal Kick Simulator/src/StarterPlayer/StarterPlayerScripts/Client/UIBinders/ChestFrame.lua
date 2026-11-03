-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:16
-- Luau version 6, Types version 3
-- Time taken: 0.001297 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink()
	local function CheckFrame(arg1_2) -- Line 10
		--[[ Upvalues[3]:
			[1]: any_GetLink_result1_upvr (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		if arg1_2:IsA("ImageButton") then
			arg1_2.AutoSell.Visible = any_GetLink_result1_upvr.AutoSell[arg1_2.Name]
			any_GetLink_result1_upvr.AutoSell.Changed:On(arg1_2.Name, function(arg1_3) -- Line 12, Named "UpdateIsSelling"
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
				Util_upvr.Network:Fire("ToggleAutoSell", arg1_2.Name)
			end)
		end
	end
	any_new_result1_upvr.TrackOnAdded = arg1.Chances.Content.ChildAdded:Connect(CheckFrame)
	for _, v in pairs(arg1.Chances.Content:GetChildren()) do
		CheckFrame(v)
	end
	any_new_result1_upvr.TrackOnRemoved = arg1.Chances.Content.ChildRemoved:Connect(function(arg1_4) -- Line 26
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		if any_new_result1_upvr[arg1_4] then
			any_new_result1_upvr[arg1_4] = nil
		end
	end)
	return any_new_result1_upvr
end
return module