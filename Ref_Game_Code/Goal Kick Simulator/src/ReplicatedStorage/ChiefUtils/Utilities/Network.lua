-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:36
-- Luau version 6, Types version 3
-- Time taken: 0.005409 seconds

local module_upvr = {
	Events = {};
}
local tbl_2_upvr = {}
setmetatable(module_upvr.Events, {
	__newindex = function(arg1, arg2, arg3) -- Line 6, Named "__newindex"
		--[[ Upvalues[1]:
			[1]: tbl_2_upvr (readonly)
		]]
		if not tbl_2_upvr[arg2] then
			local tbl = {}
			tbl[1] = arg3
			tbl_2_upvr[arg2] = tbl
		else
			table.insert(tbl_2_upvr[arg2], arg3)
		end
	end;
	__index = function(arg1, arg2) -- Line 13, Named "__index"
		--[[ Upvalues[1]:
			[1]: tbl_2_upvr (readonly)
		]]
		if not tbl_2_upvr[arg2] then
			return nil
		end
		return tbl_2_upvr[arg2][1]
	end;
})
local Players_upvr = game:GetService("Players")
function module_upvr.ListenTo(arg1, arg2, arg3) -- Line 26
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
	]]
	local function var6_upvr(...) -- Line 27
		--[[ Upvalues[1]:
			[1]: arg3 (readonly)
		]]
		arg3(...)
	end
	module_upvr.Events[arg2] = var6_upvr
	return {
		Disconnect = function() -- Line 31, Named "Disconnect"
			--[[ Upvalues[3]:
				[1]: tbl_2_upvr (copied, readonly)
				[2]: arg2 (readonly)
				[3]: var6_upvr (readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			local var8 = tbl_2_upvr[arg2]
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [12] 11. Error Block 4 start (CF ANALYSIS FAILED)
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [15.4]
			table.remove(var8, nil)
			-- KONSTANTERROR: [12] 11. Error Block 4 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [29] 25. Error Block 7 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [29] 25. Error Block 7 end (CF ANALYSIS FAILED)
		end;
	}
end
local OnGetData
if OnGetData then
	function OnGetData(arg1, ...) -- Line 48
		--[[ Upvalues[1]:
			[1]: tbl_2_upvr (readonly)
		]]
		local var14 = tbl_2_upvr[arg1]
		local var15
		if not var14 then
			var15 = warn
			var15("[ClientEvent] - No event connected for %s":format(arg1))
			return
		end
		var15 = nil
		for _, v in ipairs(var14) do
			var15 = table.pack(v(...))
		end
		return table.unpack(var15)
	end
	OnGetData = OnGetData -- Setting global
	OnGetData = false
	local var19_upvw
	local function Fire(arg1, arg2, ...) -- Line 64
		--[[ Upvalues[2]:
			[1]: OnGetData (read and write)
			[2]: var19_upvw (read and write)
		]]
		if not OnGetData then
			repeat
				task.wait()
			until OnGetData
		end
		var19_upvw:FireServer(arg2, ...)
	end
	module_upvr.Fire = Fire
	local var20_upvw
	local function Invoke(arg1, arg2, ...) -- Line 68
		--[[ Upvalues[2]:
			[1]: OnGetData (read and write)
			[2]: var20_upvw (read and write)
		]]
		if not OnGetData then
			repeat
				task.wait()
			until OnGetData
		end
		return var20_upvw:InvokeServer(arg2, ...)
	end
	module_upvr.Invoke = Invoke
	task.spawn(function() -- Line 73
		--[[ Upvalues[3]:
			[1]: var20_upvw (read and write)
			[2]: var19_upvw (read and write)
			[3]: OnGetData (read and write)
		]]
		var20_upvw = game.ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RemoteFunction")
		var19_upvw = game.ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RemoteEvent")
		var20_upvw.OnClientInvoke = OnGetData
		var19_upvw.OnClientEvent:Connect(OnGetData)
		OnGetData = true
	end)
else
	function OnGetData(arg1, arg2, ...) -- Line 82
		--[[ Upvalues[1]:
			[1]: tbl_2_upvr (readonly)
		]]
		local var26 = tbl_2_upvr[arg2]
		local var27
		if not var26 then return end
		var27 = nil
		for _, v_2 in ipairs(var26) do
			var27 = v_2(arg1, ...)
		end
		return var27
	end
	if not game.ReplicatedStorage:FindFirstChild("Remote") then
	end
	Instance.new("Folder", game.ReplicatedStorage).Name = "Remote"
	local RemoteFunction = game.ReplicatedStorage.Remote:FindFirstChild("RemoteFunction")
	if not RemoteFunction then
		RemoteFunction = Instance.new
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		RemoteFunction = RemoteFunction("RemoteFunction", Instance.new("Folder", game.ReplicatedStorage))
	end
	var20_upvw = RemoteFunction
	local var32_upvw = var20_upvw
	local RemoteEvent = game.ReplicatedStorage.Remote:FindFirstChild("RemoteEvent")
	if not RemoteEvent then
		RemoteEvent = Instance.new
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		RemoteEvent = RemoteEvent("RemoteEvent", Instance.new("Folder", game.ReplicatedStorage))
	end
	var19_upvw = RemoteEvent
	local var34_upvw = var19_upvw
	function module_upvr.FireWithCondition(arg1, arg2, arg3, ...) -- Line 100
		--[[ Upvalues[2]:
			[1]: Players_upvr (readonly)
			[2]: var34_upvw (read and write)
		]]
		local var39 = arg3
		if var39 then
			if typeof(arg3) ~= "function" then
				var39 = false
			else
				var39 = true
			end
		end
		assert(var39, "Condition must be a function")
		for _, v_3 in pairs(Players_upvr:GetPlayers()) do
			if arg3(v_3) then
				var34_upvw:FireClient(v_3, arg2, ...)
			end
		end
	end
	function module_upvr.FireAllWithin(arg1, arg2, arg3, ...) -- Line 108
		--[[ Upvalues[1]:
			[1]: var34_upvw (read and write)
		]]
		local var47 = arg2
		if var47 then
			if typeof(arg2) ~= "table" then
				var47 = false
			else
				var47 = true
			end
		end
		assert(var47, "Target must be a table")
		for _, v_4 in pairs(arg2) do
			var34_upvw:FireClient(v_4, arg3, ...)
		end
	end
	function module_upvr.FireAllExcept(arg1, arg2, arg3, ...) -- Line 114
		--[[ Upvalues[2]:
			[1]: Players_upvr (readonly)
			[2]: var34_upvw (read and write)
		]]
		for _, v_5 in pairs(Players_upvr:GetChildren()) do
			if v_5 ~= arg2 then
				var34_upvw:FireClient(v_5, arg3, ...)
			end
		end
	end
	function module_upvr.FireAllClients(arg1, arg2, ...) -- Line 121
		--[[ Upvalues[1]:
			[1]: var34_upvw (read and write)
		]]
		var34_upvw:FireAllClients(arg2, ...)
	end
	function module_upvr.Fire(arg1, arg2, arg3, ...) -- Line 124
		--[[ Upvalues[1]:
			[1]: var34_upvw (read and write)
		]]
		var34_upvw:FireClient(arg2, arg3, ...)
	end
	function module_upvr.Invoke(arg1, arg2, arg3, ...) -- Line 127
		--[[ Upvalues[1]:
			[1]: var32_upvw (read and write)
		]]
		return var32_upvw:InvokeClient(arg2, arg3, ...)
	end
	var32_upvw.OnServerInvoke = OnGetData
	var34_upvw.OnServerEvent:Connect(OnGetData)
end
return module_upvr