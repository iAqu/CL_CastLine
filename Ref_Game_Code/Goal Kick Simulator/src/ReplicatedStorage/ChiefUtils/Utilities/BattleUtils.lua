-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:23
-- Luau version 6, Types version 3
-- Time taken: 0.006484 seconds

local module_2_upvr = {}
function module_2_upvr.GetTrainerIDFromMonster(arg1, arg2) -- Line 3
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr:GetTrainerIDFromFieldPlacement(arg2.FieldPlacement)
end
function module_2_upvr.GetTrainerIDFromFieldPlacement(arg1, arg2) -- Line 7
	return unpack(string.split(arg2, '/'))
end
function module_2_upvr.GetTrainerIDParty(arg1, arg2, arg3) -- Line 12
	assert(arg3, "Invalid Battle")
	for _, v in pairs(arg3.Teams) do
		for _, v_2 in pairs(v.Parties) do
			if v_2.TrainerID == arg2 then
				return v_2
			end
		end
	end
end
function module_2_upvr.GetTrainerIDTeam(arg1, arg2, arg3) -- Line 23
	assert(arg3, "Invalid Battle")
	for _, v_3 in pairs(arg3.Teams) do
		for _, v_4 in pairs(v_3.Parties) do
			if v_4.TrainerID == arg2 then
				return v_3
			end
		end
	end
end
function module_2_upvr.GetPlayerFromTrainerID(arg1, arg2, arg3) -- Line 34
	assert(arg2, "Invalid Battle")
	for _, v_5 in pairs(arg2.Teams) do
		for _, v_6 in pairs(v_5.Parties) do
			if v_6.TrainerID == arg3 then
				local Player = v_6.Player
				if not Player then
					Player = v_6.OwnerID
					if Player then
						Player = game.Players:GetPlayerByUserId(v_6.OwnerID)
					end
				end
				return Player
			end
		end
	end
end
function module_2_upvr.GetPlayerParty(arg1, arg2, arg3) -- Line 46
	assert(arg3, "Invalid Battle")
	assert(arg2, "Player not valid")
	for _, v_7 in pairs(arg3.Teams) do
		for _, v_8 in pairs(v_7.Parties) do
			if v_8.Player == arg2 or v_8.OwnerID == arg2.UserId then
				return v_8
			end
		end
	end
end
function module_2_upvr.GetPlayerTrainerID(arg1, arg2, arg3) -- Line 59
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	assert(arg3, "Invalid Battle")
	assert(arg2, "Invalid Player")
	return module_2_upvr:GetPlayerParty(arg2, arg3).TrainerID
end
function module_2_upvr.GetTrainerIDFoeTeams(arg1, arg2, arg3) -- Line 66
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	assert(arg3, "Invalid Battle")
	local _, _, _ = pairs(arg3.Teams)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [14] 11. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [16.8]
	local _, _, _ = pairs(nil.Parties)
	-- KONSTANTERROR: [14] 11. Error Block 2 end (CF ANALYSIS FAILED)
end
function module_2_upvr.GetMonsterFromFieldPlacement(arg1, arg2, arg3) -- Line 89
	for _, v_9 in pairs(arg3.Teams) do
		for _, v_10 in pairs(v_9.Parties) do
			for _, v_11 in pairs(v_10.Party) do
				if v_11.FieldPlacement == arg2 then
					return v_11
				end
			end
		end
	end
end
function module_2_upvr.GetMonstersInField(arg1, arg2) -- Line 102
	local module_5 = {}
	for _, v_12 in pairs(arg2.Teams) do
		for _, v_13 in pairs(v_12.Parties) do
			for _, v_14 in pairs(v_13.Party) do
				if v_14.FieldPlacement and 0 < v_14.Health then
					module_5[#module_5 + 1] = v_14
				end
			end
		end
	end
	return module_5
end
function module_2_upvr.IsSameTeam(arg1, arg2, arg3, arg4) -- Line 117
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local var99
	if module_2_upvr:GetTrainerIDTeam(module_2_upvr:GetTrainerIDFromFieldPlacement(arg3), arg2) ~= module_2_upvr:GetTrainerIDTeam(module_2_upvr:GetTrainerIDFromFieldPlacement(arg4), arg2) then
		var99 = false
	else
		var99 = true
	end
	return var99
end
function module_2_upvr.GetMonstersInFieldExcluding(arg1, arg2, arg3) -- Line 126
	local module_3 = {}
	for _, v_15 in pairs(arg2.Teams) do
		for _, v_16 in pairs(v_15.Parties) do
			for _, v_17 in pairs(v_16.Party) do
				if 0 < v_17.Health and v_17.FieldPlacement and v_17.FieldPlacement ~= arg3 then
					module_3[#module_3 + 1] = v_17
				end
			end
		end
	end
	return module_3
end
function module_2_upvr.GetTrainerDataFromBattlefield(arg1, arg2, ...) -- Line 141
	local module_4 = {}
	for _, v_18 in pairs({...}) do
		module_4[#module_4 + 1] = arg2.TrainerLocations[v_18]
	end
	return unpack(module_4)
end
function module_2_upvr.GetMonsterModelFromBattlefield(arg1, arg2, ...) -- Line 158
	local module = {}
	for _, v_19 in pairs({...}) do
		module[#module + 1] = arg2.FieldSettings.MonsterModels:FindFirstChild(v_19)
	end
	return unpack(module)
end
return module_2_upvr