-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:46
-- Luau version 6, Types version 3
-- Time taken: 0.005013 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local tbl_upvr = {}
local ToolInfo_upvr = Util_upvr.ReplicatedStorage.Shared.ToolInfo
local function CreateTool_upvr(arg1, arg2) -- Line 12, Named "CreateTool"
	--[[ Upvalues[4]:
		[1]: Util_upvr (readonly)
		[2]: ToolInfo_upvr (readonly)
		[3]: tbl_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr_2 = Util_upvr.Maid.new()
	local module_upvr = {}
	module_upvr.Tool = arg1
	module_upvr.Maid = any_new_result1_upvr_2
	module_upvr.Character = arg2
	function module_upvr.Destroy() -- Line 18
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2:Destroy()
	end
	function module_upvr.Fire(arg1_5, arg2_5, ...) -- Line 21
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return Util_upvr.Network:Fire("FireTool", arg1, arg2_5, ...)
	end
	function module_upvr.GetEntityInRange(arg1_6, arg2_6, arg3, ...) -- Line 24
		--[[ Upvalues[1]:
			[1]: Util_upvr (copied, readonly)
		]]
		return Util_upvr.CFrame.GetChildrenInRange(workspace, arg2_6 * CFrame.new(0, 0, -arg3.Z / 2), arg3, ...)
	end
	local SOME = ToolInfo_upvr:FindFirstChild(arg1.Name)
	local var28
	if SOME then
		var28 = SOME
		local var28_2 = require(var28)
		var28 = pairs(var28_2)
		local pairs_result1_3, pairs_result2_2, pairs_result3_3 = pairs(var28_2)
		for i, v in pairs_result1_3, pairs_result2_2, pairs_result3_3 do
			module_upvr[i] = v
		end
		pairs_result1_3 = var28_2
		if pairs_result1_3 then
			pairs_result1_3 = var28_2.ToolType
			if pairs_result1_3 then
				i = Util_upvr
				pairs_result1_3 = i.ReplicatedStorage.Shared.ClientToolSettings:FindFirstChild(var28_2.ToolType)
			end
		end
		if pairs_result1_3 then
			i = {}
			v = require(pairs_result1_3)
			i.__index = v
			setmetatable(module_upvr, i)
		end
	end
	any_new_result1_upvr_2:GiveTask(Util_upvr.UserInputService.InputBegan:Connect(function(arg1_7, arg2_7) -- Line 41
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		if not arg2_7 and arg1_7.KeyCode == Enum.KeyCode.Backspace then
			module_upvr:Fire("DropTool")
		end
	end))
	if module_upvr.Setup then
		module_upvr:Setup(arg1)
	end
	any_new_result1_upvr_2:GiveTask(function() -- Line 51
		--[[ Upvalues[3]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: module_upvr (readonly)
		]]
		if tbl_upvr[arg1] == module_upvr then
			tbl_upvr[arg1] = nil
		end
	end)
	any_new_result1_upvr_2:GiveTask(arg1:GetPropertyChangedSignal("Parent"):Connect(function() -- Line 56
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: any_new_result1_upvr_2 (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [2] 3. Error Block 13 start (CF ANALYSIS FAILED)
		if not LocalPlayer_upvr:FindFirstChild("Backpack") or not arg1:IsDescendantOf(LocalPlayer_upvr.Backpack) or not LocalPlayer_upvr.Character or not arg1:IsDescendantOf(LocalPlayer_upvr.Character) then
			-- KONSTANTERROR: [28] 23. Error Block 10 start (CF ANALYSIS FAILED)
			any_new_result1_upvr_2:Destroy()
			-- KONSTANTERROR: [28] 23. Error Block 10 end (CF ANALYSIS FAILED)
		end
		-- KONSTANTERROR: [2] 3. Error Block 13 end (CF ANALYSIS FAILED)
	end))
	return module_upvr
end
local function _(arg1, arg2) -- Line 64, Named "OnToolAdded"
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: CreateTool_upvr (readonly)
	]]
	if arg1:IsA("Tool") and not tbl_upvr[arg1] then
		tbl_upvr[arg1] = CreateTool_upvr(arg1, arg2)
	end
end
local function OnSpawn_upvr(arg1, arg2) -- Line 72, Named "OnSpawn"
	--[[ Upvalues[3]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: CreateTool_upvr (readonly)
	]]
	local Backpack = LocalPlayer_upvr:FindFirstChild("Backpack")
	local tbl = {Backpack}
	tbl[2] = arg1
	for _, v_2 in pairs(tbl) do
		for _, v_3 in pairs(v_2:GetChildren()) do
			if v_3:IsA("Tool") and not tbl_upvr[v_3] then
				tbl_upvr[v_3] = CreateTool_upvr(v_3, arg1)
			end
		end
	end
	arg2.CheckBackpackToolAdded = Backpack.ChildAdded:Connect(function(arg1_8) -- Line 79
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: tbl_upvr (copied, readonly)
			[3]: CreateTool_upvr (copied, readonly)
		]]
		if arg1_8:IsA("Tool") and not tbl_upvr[arg1_8] then
			tbl_upvr[arg1_8] = CreateTool_upvr(arg1_8, arg1)
		end
	end)
	arg2.CheckCharacterToolAdded = arg1.ChildAdded:Connect(function(arg1_9) -- Line 82
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: tbl_upvr (copied, readonly)
			[3]: CreateTool_upvr (copied, readonly)
		]]
		if arg1_9:IsA("Tool") and not tbl_upvr[arg1_9] then
			tbl_upvr[arg1_9] = CreateTool_upvr(arg1_9, arg1)
		end
	end)
end
function module.Start(arg1) -- Line 87
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: OnSpawn_upvr (readonly)
	]]
	Util_upvr.PlayerMaids.Client.CharacterAdded:Connect(OnSpawn_upvr)
end
return module