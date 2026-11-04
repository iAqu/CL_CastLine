-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:44
-- Luau version 6, Types version 3
-- Time taken: 0.001457 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HatchEffect_upvr = require(ReplicatedStorage.Tool.HatchEffect)
ReplicatedStorage.ServerMsg.drawSpecialEgg.OnClientEvent:Connect(function(arg1, arg2) -- Line 27, Named "ShowHatchPet"
	--[[ Upvalues[1]:
		[1]: HatchEffect_upvr (readonly)
	]]
	if #arg2 <= 5 then
		HatchEffect_upvr.ShowHatchEffect_5X(arg1, arg2, 1, false)
	else
		if #arg2 <= 10 then
			for i_2 = 1, #arg2 do
				if i_2 <= 5 then
					({})[i_2] = arg2[i_2]
				else
					({})[i_2 - 5] = arg2[i_2]
				end
			end
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			HatchEffect_upvr.ShowHatchEffect_5X(arg1, {}, 1, false)
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			HatchEffect_upvr.ShowHatchEffect_5X(arg1, {}, 1, false)
			return
		end
		print("暂不支持超过10个的显示")
	end
end)
ReplicatedStorage.ServerMsg.showItems.OnClientEvent:Connect(function(arg1, arg2) -- Line 8, Named "ShowItems"
	--[[ Upvalues[1]:
		[1]: HatchEffect_upvr (readonly)
	]]
	if arg2 == "展示武器" then
		task.spawn(function() -- Line 12
			--[[ Upvalues[2]:
				[1]: HatchEffect_upvr (copied, readonly)
				[2]: arg1 (readonly)
			]]
			local tbl = {}
			tbl[1] = arg1
			HatchEffect_upvr.ShowItemEffect_NewWeapon(tbl)
		end)
	else
		for _, v in pairs(arg1) do
			HatchEffect_upvr.ShowItemEffect({v})
		end
	end
end)