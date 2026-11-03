-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:57
-- Luau version 6, Types version 3
-- Time taken: 0.001346 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("BaseObject")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_3)
setmetatable_result1_upvr_2.ClassName = "RagdollHumanoidOnFallClient"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
any_load_result1("PromiseRemoteEventMixin"):Add(setmetatable_result1_upvr_2, any_load_result1("RagdollHumanoidOnFallConstants").REMOTE_EVENT_NAME)
local var1_result1_upvr = any_load_result1("RagdollBindersClient")
local any_load_result1_result1_upvr = any_load_result1("CharacterUtils")
local Players_upvr = game:GetService("Players")
local var1_result1_upvr_2 = any_load_result1("BindableRagdollHumanoidOnFall")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 30
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: Players_upvr (readonly)
		[6]: var1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_3.new(arg1), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._ragdollBinder = arg2:GetService(var1_result1_upvr).Ragdoll
	if any_load_result1_result1_upvr.getPlayerFromCharacter(setmetatable_result1_upvr._obj) == Players_upvr.LocalPlayer then
		setmetatable_result1_upvr._ragdollLogic = var1_result1_upvr_2.new(setmetatable_result1_upvr._obj, setmetatable_result1_upvr._ragdollBinder)
		setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._ragdollLogic)
		setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._ragdollLogic.ShouldRagdoll.Changed:Connect(function() -- Line 40
			--[[ Upvalues[1]:
				[1]: setmetatable_result1_upvr (readonly)
			]]
			setmetatable_result1_upvr:_update()
		end))
	end
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2._update(arg1) -- Line 48
	if arg1._ragdollLogic.ShouldRagdoll.Value then
		arg1._ragdollBinder:BindClient(arg1._obj)
		arg1:PromiseRemoteEvent():Then(function(arg1_2) -- Line 51
			arg1_2:FireServer(true)
		end)
	end
end
return setmetatable_result1_upvr_2