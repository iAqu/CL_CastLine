-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:49
-- Luau version 6, Types version 3
-- Time taken: 0.002331 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr_3 = any_load_result1("Signal")
local var1_result1_upvr = any_load_result1("HairLines")
local function createLines_upvr(arg1, arg2, arg3, arg4, arg5) -- Line 12, Named "createLines"
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_upvr_2 = var1_result1_upvr_2.new()
	local any_new_result1_3_upvr = var1_result1_upvr_3.new()
	any_new_result1_upvr_2:GiveTask(any_new_result1_3_upvr)
	local var7_upvw = true
	any_new_result1_upvr_2:GiveTask(function() -- Line 19
		--[[ Upvalues[1]:
			[1]: var7_upvw (read and write)
		]]
		var7_upvw = false
	end)
	any_new_result1_upvr_2:GiveTask(any_new_result1_3_upvr:Connect(function() -- Line 23
		--[[ Upvalues[9]:
			[1]: var7_upvw (read and write)
			[2]: var1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: arg3 (readonly)
			[5]: arg4 (readonly)
			[6]: arg5 (readonly)
			[7]: arg2 (readonly)
			[8]: any_new_result1_upvr_2 (readonly)
			[9]: any_new_result1_3_upvr (readonly)
		]]
		if not var7_upvw then
		else
			local any_new_result1_2 = var1_result1_upvr.new(arg1, arg3, arg4, arg5)
			any_new_result1_2.Gui.Parent = arg2
			any_new_result1_2.Gui.BackgroundTransparency = 0.5
			any_new_result1_upvr_2._hairLines = any_new_result1_2
			any_new_result1_2:Play(function() -- Line 33
				--[[ Upvalues[3]:
					[1]: var7_upvw (copied, read and write)
					[2]: any_new_result1_upvr_2 (copied, readonly)
					[3]: any_new_result1_3_upvr (copied, readonly)
				]]
				delay(1, function() -- Line 34
					--[[ Upvalues[3]:
						[1]: var7_upvw (copied, read and write)
						[2]: any_new_result1_upvr_2 (copied, readonly)
						[3]: any_new_result1_3_upvr (copied, readonly)
					]]
					if var7_upvw then
						any_new_result1_upvr_2._hairLines = nil
						any_new_result1_3_upvr:Fire()
					end
				end)
			end)
		end
	end))
	any_new_result1_3_upvr:Fire()
	return any_new_result1_upvr_2
end
local var1_result1_upvr_4 = any_load_result1("ServiceBag")
return function(arg1) -- Line 48
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: createLines_upvr (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_2.new()
	local any_new_result1 = var1_result1_upvr_4.new()
	any_new_result1_upvr:GiveTask(any_new_result1)
	local Frame = Instance.new("Frame")
	Frame.BorderSizePixel = 0
	Frame.BackgroundTransparency = 0
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.Parent = arg1
	any_new_result1_upvr:GiveTask(Frame)
	local UIGridLayout = Instance.new("UIGridLayout")
	UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIGridLayout.CellPadding = UDim2.fromOffset(100, 100)
	UIGridLayout.CellSize = UDim2.new(0, 50, 0, 50)
	UIGridLayout.Parent = Frame
	any_new_result1_upvr:GiveTask(createLines_upvr(any_new_result1, Frame, -45, -135, 3))
	any_new_result1_upvr:GiveTask(createLines_upvr(any_new_result1, Frame, 45, 135, 3))
	any_new_result1_upvr:GiveTask(createLines_upvr(any_new_result1, Frame, 0, 300, 6))
	return function() -- Line 73
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end