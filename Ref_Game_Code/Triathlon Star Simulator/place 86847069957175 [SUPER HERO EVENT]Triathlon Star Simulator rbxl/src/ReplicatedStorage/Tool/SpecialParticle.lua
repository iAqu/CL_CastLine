-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:54
-- Luau version 6, Types version 3
-- Time taken: 0.002340 seconds

local module = {}
local RunService_upvr = game:GetService("RunService")
function module.RainBowParticle(arg1, arg2) -- Line 9
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not arg2 then
	end
	local const_number_upvw = 1
	task.spawn(function() -- Line 15
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: const_number_upvw (read and write)
			[3]: RunService_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		while arg1 ~= nil and arg1.Parent ~= nil do
			if arg1 == nil then return end
			if arg1.Parent == nil then return end
			if arg1.Parent.Parent.Parent.ClassName == "Folder" then return end
			for i = 0, 1, 0.1 do
				table.insert({}, ColorSequenceKeypoint.new(i, Color3.fromHSV((tick() * 0.1 * const_number_upvw % 1 + i * 0.6) % 1, 0.8, 1)))
				local var10
			end
			arg1.Color = ColorSequence.new(var10)
			RunService_upvr.Heartbeat:Wait()
		end
	end)
end
function module.SecretParticle(arg1, arg2) -- Line 40
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not arg2 then
	end
	local const_number_upvw_2 = 1
	task.spawn(function() -- Line 46
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: const_number_upvw_2 (read and write)
			[3]: RunService_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		while arg1 ~= nil and arg1.Parent ~= nil do
			if arg1 == nil then return end
			if arg1.Parent == nil then return end
			if arg1.Parent.Parent.Parent.ClassName == "Folder" then return end
			local var17 = tick() * 0.1 * const_number_upvw_2 % 1
			for i_2 = 0, 1, 0.1 do
				table.insert({}, ColorSequenceKeypoint.new(i_2, Color3.fromHSV((var17 + i_2 * 0.6) % 1, (var17 + i_2 * 0.6) % 1, (var17 + i_2 * 0.6) % 0.3)))
				local var19
			end
			Color3.fromHSV(1, 1, 0.2)
			arg1.Color = ColorSequence.new(var19)
			RunService_upvr.Heartbeat:Wait()
		end
	end)
end
return module