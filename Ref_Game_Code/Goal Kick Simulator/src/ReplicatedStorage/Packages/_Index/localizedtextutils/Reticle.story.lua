-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:50
-- Luau version 6, Types version 3
-- Time taken: 0.002251 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_3 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("ServiceBag")
local var1_result1_upvr_2 = any_load_result1("Reticle")
local RunService_upvr = game:GetService("RunService")
local UserInputService_upvr = game:GetService("UserInputService")
return function(arg1) -- Line 16
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: RunService_upvr (readonly)
		[5]: UserInputService_upvr (readonly)
	]]
	local any_new_result1_upvr_2 = var1_result1_upvr_3.new()
	local any_new_result1 = var1_result1_upvr.new()
	any_new_result1_upvr_2:GiveTask(any_new_result1)
	local any_new_result1_upvr = var1_result1_upvr_2.new(any_new_result1)
	any_new_result1_upvr:SetHairsFromRotationDegrees({0, 180})
	any_new_result1_upvr.Gui.Size = UDim2.new(0.1, 0, 0.1, 0)
	any_new_result1_upvr_2:GiveTask(any_new_result1_upvr)
	any_new_result1_upvr:Show()
	any_new_result1_upvr.Gui.Parent = arg1
	local var13_upvr = tick() / 1.5 % 2
	local var14_upvw = 0
	any_new_result1_upvr_2:GiveTask(RunService_upvr.RenderStepped:Connect(function() -- Line 31
		--[[ Upvalues[4]:
			[1]: any_new_result1_upvr (readonly)
			[2]: var13_upvr (readonly)
			[3]: UserInputService_upvr (copied, readonly)
			[4]: var14_upvw (read and write)
		]]
		local var16
		if math.floor(tick() / 1.5 + var13_upvr) % 2 ~= 0 then
			var16 = false
		else
			var16 = true
		end
		any_new_result1_upvr:SetVisible(var16)
		var16 = Enum.UserInputType.MouseButton1
		if UserInputService_upvr:IsMouseButtonPressed(var16) then
			var14_upvw += 1
			if var14_upvw % 6 == 0 then
				any_new_result1_upvr:ImpulseDistance()
			end
		end
	end))
	return function() -- Line 44
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2:DoCleaning()
	end
end