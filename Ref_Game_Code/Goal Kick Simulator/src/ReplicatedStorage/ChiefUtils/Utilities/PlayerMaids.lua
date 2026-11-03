-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:38
-- Luau version 6, Types version 3
-- Time taken: 0.004033 seconds

-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
local module_upvr = {}
local Players_upvr = game:GetService("Players")
local Maid_upvr = require(script.Parent.Maid)
local function CreatePlayerMaid_upvr(arg1) -- Line 8, Named "CreatePlayerMaid"
	--[[ Upvalues[1]:
		[1]: Maid_upvr (readonly)
	]]
	local tbl_upvr = {}
	local any_new_result1_upvr = Maid_upvr.new()
	any_new_result1_upvr.Character = Maid_upvr.new()
	local function onCharAdded(arg1_2) -- Line 15
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr (readonly)
			[2]: Maid_upvr (copied, readonly)
			[3]: tbl_upvr (readonly)
		]]
		any_new_result1_upvr.Character = Maid_upvr.new()
		for _, v in pairs(tbl_upvr) do
			task.defer(v, arg1_2, any_new_result1_upvr.Character)
		end
	end
	local tbl = {}
	local var20_upvw = 0
	local function Connect(arg1_3, arg2, arg3) -- Line 23
		--[[ Upvalues[4]:
			[1]: var20_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: tbl_upvr (readonly)
		]]
		var20_upvw += 1
		local tostring_result1_upvr_2 = tostring(var20_upvw)
		if arg1.Character and not arg3 then
			arg2(arg1.Character, any_new_result1_upvr.Character)
		end
		tbl_upvr[tostring_result1_upvr_2] = arg2
		local module = {}
		local function Disconnect() -- Line 31
			--[[ Upvalues[2]:
				[1]: tbl_upvr (copied, readonly)
				[2]: tostring_result1_upvr_2 (readonly)
			]]
			tbl_upvr[tostring_result1_upvr_2] = nil
		end
		module.Disconnect = Disconnect
		return module
	end
	tbl.Connect = Connect
	any_new_result1_upvr.CharacterAdded = tbl
	arg1.CharacterAdded:Connect(onCharAdded)
	if arg1.Character then
		onCharAdded(arg1.Character)
	end
	return any_new_result1_upvr
end
module_upvr.PlayerAdded = {}
module_upvr.__PlayerAdded = {}
if game:GetService("RunService"):IsServer() then
	local var23_upvw = 0
	local function Connect(arg1, arg2) -- Line 48
		--[[ Upvalues[3]:
			[1]: Players_upvr (readonly)
			[2]: module_upvr (readonly)
			[3]: var23_upvw (read and write)
		]]
		assert(arg2, "Connect Function is missing!")
		for _, v_2 in pairs(Players_upvr:GetPlayers()) do
			task.spawn(arg2, v_2, module_upvr[v_2])
		end
		var23_upvw += 1
		local tostring_result1_upvr = tostring(var23_upvw)
		module_upvr.__PlayerAdded[tostring_result1_upvr] = arg2
		return {
			Disconnect = function() -- Line 59, Named "Disconnect"
				--[[ Upvalues[2]:
					[1]: module_upvr (copied, readonly)
					[2]: tostring_result1_upvr (readonly)
				]]
				module_upvr.__PlayerAdded[tostring_result1_upvr] = nil
			end;
		}
	end
	module_upvr.PlayerAdded.Connect = Connect
	for _, v_4 in pairs(Players_upvr:GetPlayers()) do
		(function(arg1) -- Line 73, Named "OnPlayerAdded"
			--[[ Upvalues[2]:
				[1]: module_upvr (readonly)
				[2]: CreatePlayerMaid_upvr (readonly)
			]]
			module_upvr[arg1] = CreatePlayerMaid_upvr(arg1)
			for _, v_3 in pairs(module_upvr.__PlayerAdded) do
				task.defer(v_3, arg1, module_upvr[arg1])
			end
		end)(v_4)
		local var40
	end
	Players_upvr.PlayerAdded:Connect(var40)
	Players_upvr.PlayerRemoving:Connect(function(arg1) -- Line 65, Named "OnPlayerRemoved"
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		local var31 = module_upvr[arg1]
		if var31 then
			var31:Destroy()
			module_upvr[arg1] = nil
		end
	end)
	function module_upvr.GetPlayerMaid(arg1, arg2, arg3) -- Line 86
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		local var41
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var41 = arg3
			return var41
		end
		if typeof(arg3) ~= "number" or not INLINED() then
			var41 = 60
		end
		repeat
			var41 = task.wait()
			if not arg2 then break end
			var41 = arg2.Parent
			if not var41 then break end
			var41 = module_upvr[arg2]
		until var41 and var41 <= 0 + var41
		var41 = arg2
		if var41 then
			var41 = module_upvr[arg2]
		end
		return var41
	end
	return module_upvr
end
local LocalPlayer_upvr = Players_upvr.LocalPlayer
module_upvr.PlayerAdded.Connect = function(arg1, arg2) -- Line 95, Named "Connect"
	--[[ Upvalues[1]:
		[1]: LocalPlayer_upvr (readonly)
	]]
	assert(arg2, "Connect Function is missing!")
	arg2(LocalPlayer_upvr)
end
module_upvr.Client = CreatePlayerMaid_upvr(Players_upvr.LocalPlayer)
return module_upvr