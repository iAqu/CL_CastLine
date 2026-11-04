-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:58
-- Luau version 6, Types version 3
-- Time taken: 0.000954 seconds

local AddListen = require(game:GetService("ReplicatedStorage").Tool.AddListen)
local Parent_upvr = script.Parent
local LocalPlayer = game:GetService("Players").LocalPlayer
local TrainEquipment_upvr = LocalPlayer:WaitForChild("TrainEquipment", math.huge)
local EquipmentName_upvr = LocalPlayer:WaitForChild("EquipmentName", math.huge)
local function _() -- Line 17, Named "refresh"
	--[[ Upvalues[3]:
		[1]: TrainEquipment_upvr (readonly)
		[2]: EquipmentName_upvr (readonly)
		[3]: Parent_upvr (readonly)
	]]
	if 0 < TrainEquipment_upvr.Value and EquipmentName_upvr.Value ~= "" then
		Parent_upvr.Visible = true
	else
		Parent_upvr.Visible = false
	end
end
AddListen.NumValueAdd(TrainEquipment_upvr, function(arg1) -- Line 25
	--[[ Upvalues[3]:
		[1]: TrainEquipment_upvr (readonly)
		[2]: EquipmentName_upvr (readonly)
		[3]: Parent_upvr (readonly)
	]]
	if 0 < TrainEquipment_upvr.Value and EquipmentName_upvr.Value ~= "" then
		Parent_upvr.Visible = true
	else
		Parent_upvr.Visible = false
	end
end)
AddListen.NumValueAdd(EquipmentName_upvr, function() -- Line 29
	--[[ Upvalues[3]:
		[1]: TrainEquipment_upvr (readonly)
		[2]: EquipmentName_upvr (readonly)
		[3]: Parent_upvr (readonly)
	]]
	if 0 < TrainEquipment_upvr.Value and EquipmentName_upvr.Value ~= "" then
		Parent_upvr.Visible = true
	else
		Parent_upvr.Visible = false
	end
end)