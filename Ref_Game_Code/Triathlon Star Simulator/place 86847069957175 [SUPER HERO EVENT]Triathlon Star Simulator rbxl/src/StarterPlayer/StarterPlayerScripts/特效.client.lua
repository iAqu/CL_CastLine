-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:52
-- Luau version 6, Types version 3
-- Time taken: 0.001592 seconds

local ServerUtil_upvr = require(game.ReplicatedStorage.ServerUtil)
local function _(arg1) -- Line 5, Named "BindRebirthEffect"
	--[[ Upvalues[1]:
		[1]: ServerUtil_upvr (readonly)
	]]
	local rebirthCount = arg1:WaitForChild("rebirthCount", math.huge)
	if rebirthCount then
		local Value_upvr_2 = rebirthCount.Value
		ServerUtil_upvr.AddListen.NumValueAdd(rebirthCount, function(arg1_2) -- Line 12
			--[[ Upvalues[2]:
				[1]: Value_upvr_2 (readonly)
				[2]: arg1 (readonly)
			]]
			if Value_upvr_2 < arg1_2 then
				local Character_2 = arg1.Character
				if Character_2 and Character_2.PrimaryPart then
					require(game.ReplicatedStorage.Tool["晋升表现"]).ShowLevelUp(Character_2)
				end
			end
		end)
	end
end
for _, v_upvr in pairs(ServerUtil_upvr.Players:GetPlayers()) do
	local rebirthCount_3 = v_upvr:WaitForChild("rebirthCount", math.huge)
	if rebirthCount_3 then
		local Value_upvr_3 = rebirthCount_3.Value
		ServerUtil_upvr.AddListen.NumValueAdd(rebirthCount_3, function(arg1) -- Line 12
			--[[ Upvalues[2]:
				[1]: Value_upvr_3 (readonly)
				[2]: v_upvr (readonly)
			]]
			if Value_upvr_3 < arg1 then
				local Character = v_upvr.Character
				if Character and Character.PrimaryPart then
					require(game.ReplicatedStorage.Tool["晋升表现"]).ShowLevelUp(Character)
				end
			end
		end)
	end
end
ServerUtil_upvr.Players.PlayerAdded:Connect(function(arg1) -- Line 35
	--[[ Upvalues[1]:
		[1]: ServerUtil_upvr (readonly)
	]]
	local rebirthCount_2 = arg1:WaitForChild("rebirthCount", math.huge)
	if rebirthCount_2 then
		local Value_upvr = rebirthCount_2.Value
		ServerUtil_upvr.AddListen.NumValueAdd(rebirthCount_2, function(arg1_3) -- Line 12
			--[[ Upvalues[2]:
				[1]: Value_upvr (readonly)
				[2]: arg1 (readonly)
			]]
			if Value_upvr < arg1_3 then
				local Character_3 = arg1.Character
				if Character_3 and Character_3.PrimaryPart then
					require(game.ReplicatedStorage.Tool["晋升表现"]).ShowLevelUp(Character_3)
				end
			end
		end)
	end
end)