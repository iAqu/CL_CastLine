-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:07
-- Luau version 6, Types version 3
-- Time taken: 0.003001 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "AnimatedEyesClient"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local var1_result1_upvr = any_load_result1("HumanoidUtils")
local any_load_result1_result1_upvr = any_load_result1("RagdollBindersClient")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 17
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_2.new(arg1), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._obj)
	setmetatable_result1_upvr._humanoid = assert(var1_result1_upvr.getHumanoid(setmetatable_result1_upvr._obj))
	setmetatable_result1_upvr._ragdollBinders = arg2:GetService(any_load_result1_result1_upvr)
	setmetatable_result1_upvr:Open()
	local var7_upvw = true
	setmetatable_result1_upvr._maid:GiveTask(function() -- Line 27
		--[[ Upvalues[1]:
			[1]: var7_upvw (read and write)
		]]
		var7_upvw = false
	end)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._ragdollBinders.Ragdoll:ObserveInstance(setmetatable_result1_upvr._humanoid, function(arg1_2) -- Line 31, Named "handleRagdoll"
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		if arg1_2 then
			setmetatable_result1_upvr:Close()
		else
			setmetatable_result1_upvr:Open()
		end
	end))
	if setmetatable_result1_upvr._ragdollBinders.Ragdoll:Get(setmetatable_result1_upvr._humanoid) then
		setmetatable_result1_upvr:Close()
	else
		setmetatable_result1_upvr:Open()
	end
	task.spawn(function() -- Line 42
		--[[ Upvalues[2]:
			[1]: var7_upvw (read and write)
			[2]: setmetatable_result1_upvr (readonly)
		]]
		task.wait(2.5 + (1.5) * (2 * (math.random() - 0.5)))
		while var7_upvw do
			if setmetatable_result1_upvr._ragdollBinders.Ragdoll:Get(setmetatable_result1_upvr._humanoid) then
				setmetatable_result1_upvr:Close()
				task.wait(2)
			else
				if math.random() <= 0.2 then
					setmetatable_result1_upvr:DoubleBlink()
				else
					setmetatable_result1_upvr:Blink()
				end
				task.wait(2.5 + (1.5) * (2 * (math.random() - 0.5)))
			end
		end
	end)
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.Blink(arg1) -- Line 63
	arg1:Close()
	task.delay(0.1, function() -- Line 65
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1.Destroy then
			arg1:Open()
		end
	end)
end
function setmetatable_result1_upvr_2.DoubleBlink(arg1) -- Line 72
	arg1:Blink()
	task.delay(0.15000000000000002, function() -- Line 74
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1.Destroy and not arg1._ragdollBinders.Ragdoll:Get(arg1._humanoid) then
			arg1:Blink()
		end
	end)
end
function setmetatable_result1_upvr_2.Close(arg1) -- Line 81
	arg1._obj.Texture = "rbxassetid://176208715"
end
function setmetatable_result1_upvr_2.Open(arg1) -- Line 85
	arg1._obj.Texture = "rbxassetid://176206791"
end
return setmetatable_result1_upvr_2