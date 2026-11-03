-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:32
-- Luau version 6, Types version 3
-- Time taken: 0.001928 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Util = require(ReplicatedStorage.Util)
local tbl = {
	Controllers = {};
	ClientModules = {};
	Modules = {};
	SharedRunners = {};
}
local tbl_2_upvr = {
	__index = tbl;
}
local tbl_3_upvr = {}
local function _initFolder(arg1, arg2, arg3) -- Line 17
	--[[ Upvalues[2]:
		[1]: tbl_2_upvr (readonly)
		[2]: tbl_3_upvr (readonly)
	]]
	setmetatable(arg1, {
		__index = function(arg1_2, arg2_2) -- Line 19, Named "__index"
			--[[ Upvalues[3]:
				[1]: arg2 (readonly)
				[2]: arg3 (readonly)
				[3]: tbl_2_upvr (copied, readonly)
			]]
			if not rawget(arg1_2, arg2_2) then
				local SOME = arg2:FindFirstChild(arg2_2)
				if SOME then
					if SOME:IsA("ModuleScript") then
						local SOME_3 = require(SOME)
						if not arg3 and SOME_3.Start then
							SOME_3:Start()
						end
						setmetatable(SOME_3, tbl_2_upvr)
						arg1_2[arg2_2] = SOME_3
						return SOME_3
					end
					return SOME
				end
			end
			return SOME_3
		end;
	})
	if arg3 then
		local tbl_4 = {}
		for _, v in pairs(arg2:GetChildren()) do
			if v:IsA("ModuleScript") then
				tbl_4[#tbl_4 + 1] = arg1[v.Name]
			end
		end
		for _, v_2 in pairs(tbl_4) do
			if v_2.Start then
				task.spawn(v_2.Start)
			end
			if v_2.PostRun then
				tbl_3_upvr[#tbl_3_upvr + 1] = v_2.PostRun
			end
		end
	end
end
Util.DialogClient = Util.ServiceBag:GetService(Util.Packages.DialogServiceClient)
Util.ServiceBag:GetService(script.Parent.SoccerTranslator)
Util.ServiceBag:Init()
_initFolder(tbl.Modules, ReplicatedStorage.Shared.SharedModules)
_initFolder(tbl.ClientModules, script.Parent.ClientModules)
_initFolder(tbl.Controllers, script.Parent.Controllers, true)
_initFolder(tbl.SharedRunners, ReplicatedStorage.Shared.SharedRunnables, true)
for _, v_3 in pairs(tbl_3_upvr) do
	task.spawn(v_3)
end
Util.ServiceBag:Start()
return true