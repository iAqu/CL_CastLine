-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:56
-- Luau version 6, Types version 3
-- Time taken: 0.001484 seconds

local ServerUtil_upvr = require(game.ReplicatedStorage.ServerUtil)
local function _(arg1) -- Line 8, Named "BindTrainingEffect"
	--[[ Upvalues[1]:
		[1]: ServerUtil_upvr (readonly)
	]]
	ServerUtil_upvr.AddListen.NumValueAdd(arg1:WaitForChild("CurStamina", math.huge), function(arg1_2) -- Line 12
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: ServerUtil_upvr (copied, readonly)
		]]
		local Character = arg1.Character
		if Character and Character.PrimaryPart then
			if arg1_2 <= 500 then
				ServerUtil_upvr.EffectUtil.PlayTrainingEffect(Character)
				return
			end
			ServerUtil_upvr.EffectUtil.StopTrainingEffect(Character)
		end
	end)
end
for _, v_upvr in pairs(ServerUtil_upvr.Players:GetPlayers()) do
	ServerUtil_upvr.AddListen.NumValueAdd(v_upvr:WaitForChild("CurStamina", math.huge), function(arg1) -- Line 12
		--[[ Upvalues[2]:
			[1]: v_upvr (readonly)
			[2]: ServerUtil_upvr (readonly)
		]]
		local Character_3 = v_upvr.Character
		if Character_3 and Character_3.PrimaryPart then
			if arg1 <= 500 then
				ServerUtil_upvr.EffectUtil.PlayTrainingEffect(Character_3)
				return
			end
			ServerUtil_upvr.EffectUtil.StopTrainingEffect(Character_3)
		end
	end)
end
ServerUtil_upvr.Players.PlayerAdded:Connect(function(arg1) -- Line 30
	--[[ Upvalues[1]:
		[1]: ServerUtil_upvr (readonly)
	]]
	ServerUtil_upvr.AddListen.NumValueAdd(arg1:WaitForChild("CurStamina", math.huge), function(arg1_3) -- Line 12
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: ServerUtil_upvr (copied, readonly)
		]]
		local Character_2 = arg1.Character
		if Character_2 and Character_2.PrimaryPart then
			if arg1_3 <= 500 then
				ServerUtil_upvr.EffectUtil.PlayTrainingEffect(Character_2)
				return
			end
			ServerUtil_upvr.EffectUtil.StopTrainingEffect(Character_2)
		end
	end)
end)