-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:05
-- Luau version 6, Types version 3
-- Time taken: 0.004721 seconds

local ReplicatedFirst_upvr = game:GetService("ReplicatedFirst")
spawn(function() -- Line 3
	--[[ Upvalues[1]:
		[1]: ReplicatedFirst_upvr (readonly)
	]]
	for _ = 1, 5 do
		ReplicatedFirst_upvr:RemoveDefaultLoadingScreen()
		wait(1)
	end
end)
local TweenService = game:GetService("TweenService")
local TweenInfo_new_result1 = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 2)
local PreloadGui_upvr = script.Parent:WaitForChild("PreloadGui")
local bg = PreloadGui_upvr:WaitForChild("bg")
bg.Visible = false
local skipBtn_upvr = PreloadGui_upvr:WaitForChild("skipBtn")
local Frame = PreloadGui_upvr:WaitForChild("Frame")
local UIScale = Frame:WaitForChild("UIScale")
local progressBar_upvr = PreloadGui_upvr.progressBar
local bar_upvr = progressBar_upvr:WaitForChild("bar")
local percent_upvr = progressBar_upvr:WaitForChild("percent")
local loadingText_upvr = PreloadGui_upvr.loadingText
local Magnitude = PreloadGui_upvr.AbsoluteSize.Magnitude
local var16_upvw = false
local any_Create_result1_upvr = TweenService:Create(bg, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0), {
	Size = UDim2.fromOffset(Magnitude, Magnitude);
})
local any_Create_result1_upvw = TweenService:Create(PreloadGui_upvr:WaitForChild("背景"), TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
	Position = UDim2.new(0.2, 0, 0.3, 0);
})
local any_Create_result1_upvw_3 = TweenService:Create(Frame, TweenInfo_new_result1, {
	Position = UDim2.new(0.5, 0, 0.5, 0);
})
local any_Create_result1_upvw_4 = TweenService:Create(UIScale, TweenInfo_new_result1, {
	Scale = 1.2;
})
local any_Create_result1_upvw_2 = TweenService:Create(UIScale, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true), {
	Scale = 1.4;
})
any_Create_result1_upvr.Completed:Connect(function() -- Line 73
	--[[ Upvalues[1]:
		[1]: PreloadGui_upvr (readonly)
	]]
	PreloadGui_upvr:Destroy()
end)
local function _(arg1, arg2, arg3) -- Line 79
	if arg2 == nil then
		local const_number = 1
	end
	if not arg1 then
		error("_uiGradient is invalid")
	else
		if 1 < const_number or const_number < 0 then
			error("_rate is out of range")
			return
		end
		if const_number ~= const_number then
			error("_rate is nan or inf")
			return
		end
		local var30 = const_number
		local var31 = const_number
		if var31 <= 1 then
			if var31 == 1 then
				var31 -= 0.01
			end
			var30 = var31 - 0.01
		end
		if 0 <= var30 then
			if var30 == 0 then
				var30 += 0.01
			end
			var31 = var30 + 0.01
		end
		if not arg3 then
			local var32 = 0
		end
		arg1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(math.clamp(var30, 0, 1), 1, 0), NumberSequenceKeypoint.new(math.clamp(var31, 0, 1), var32, 0), NumberSequenceKeypoint.new(1, var32, 0)})
	end
end
local var34_upvw = 0
local function _() -- Line 132, Named "updateLoadProgress"
	--[[ Upvalues[3]:
		[1]: var34_upvw (read and write)
		[2]: bar_upvr (readonly)
		[3]: percent_upvr (readonly)
	]]
	local var35 = 100 * var34_upvw / 100
	local ceiled = math.ceil(var35)
	if 100 < ceiled then
		var35 = 100
	else
		var35 = ceiled
	end
	local var37 = var35
	bar_upvr.Size = UDim2.fromScale(var37 / 100, 1)
	percent_upvr.Text = var37..'%'
end
local var38_upvw
local function finishPreload_upvr() -- Line 146, Named "finishPreload"
	--[[ Upvalues[8]:
		[1]: any_Create_result1_upvw (read and write)
		[2]: any_Create_result1_upvw_3 (read and write)
		[3]: any_Create_result1_upvw_4 (read and write)
		[4]: any_Create_result1_upvw_2 (read and write)
		[5]: var38_upvw (read and write)
		[6]: loadingText_upvr (readonly)
		[7]: PreloadGui_upvr (readonly)
		[8]: any_Create_result1_upvr (readonly)
	]]
	if any_Create_result1_upvw then
		any_Create_result1_upvw:Pause()
		any_Create_result1_upvw:Destroy()
		any_Create_result1_upvw = nil
	end
	if any_Create_result1_upvw_3 then
		any_Create_result1_upvw_3:Pause()
		any_Create_result1_upvw_3:Destroy()
		any_Create_result1_upvw_3 = nil
	end
	if any_Create_result1_upvw_4 then
		any_Create_result1_upvw_4:Pause()
		any_Create_result1_upvw_4:Destroy()
		any_Create_result1_upvw_4 = nil
	end
	if any_Create_result1_upvw_2 then
		any_Create_result1_upvw_2:Pause()
		any_Create_result1_upvw_2:Destroy()
		any_Create_result1_upvw_2 = nil
	end
	if var38_upvw then
		var38_upvw:Disconnect()
		var38_upvw = nil
	end
	loadingText_upvr.Text = "Loaded!"
	wait(0.5)
	for _, v in pairs(PreloadGui_upvr:GetChildren()) do
		if v.Name ~= "bg" then
			v.Visible = false
		else
			v.Visible = true
		end
	end
	if any_Create_result1_upvr then
		any_Create_result1_upvr:Play()
	end
end
skipBtn_upvr.MouseButton1Click:Connect(function() -- Line 194
	--[[ Upvalues[2]:
		[1]: skipBtn_upvr (readonly)
		[2]: finishPreload_upvr (readonly)
	]]
	skipBtn_upvr:Destroy()
	finishPreload_upvr()
end)
PreloadGui_upvr.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
any_Create_result1_upvw_3.Completed:Connect(function() -- Line 200
	--[[ Upvalues[4]:
		[1]: var16_upvw (read and write)
		[2]: progressBar_upvr (readonly)
		[3]: loadingText_upvr (readonly)
		[4]: any_Create_result1_upvw_2 (read and write)
	]]
	var16_upvw = true
	progressBar_upvr.Visible = true
	loadingText_upvr.Visible = true
	any_Create_result1_upvw_2:Play()
end)
Frame.Position = UDim2.new(0.5, 0, 1.2, 0)
UIScale.Scale = 0.1
var34_upvw = 0
local var46_upvw = var34_upvw
local var47 = 100 * var46_upvw / 100
local ceiled_2 = math.ceil(var47)
if 100 < ceiled_2 then
	var47 = 100
else
	var47 = ceiled_2
end
local var49 = var47
bar_upvr.Size = UDim2.fromScale(var49 / 100, 1)
percent_upvr.Text = var49..'%'
progressBar_upvr.Visible = false
loadingText_upvr.Visible = false
any_Create_result1_upvw:Play()
any_Create_result1_upvw_3:Play()
any_Create_result1_upvw_4:Play()
local var51_upvw = false
var38_upvw = game:GetService("RunService").Heartbeat:Connect(function(arg1) -- Line 218
	--[[ Upvalues[6]:
		[1]: var16_upvw (read and write)
		[2]: var51_upvw (read and write)
		[3]: var46_upvw (read and write)
		[4]: bar_upvr (readonly)
		[5]: percent_upvr (readonly)
		[6]: finishPreload_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 40 start (CF ANALYSIS FAILED)
	if var51_upvw and var46_upvw <= 100 then
		var46_upvw += 10
		local var52 = 100 * var46_upvw / 100
		local ceiled_3 = math.ceil(var52)
		if 100 < ceiled_3 then
			var52 = 100
		else
			var52 = ceiled_3
		end
		local var54 = var52
		bar_upvr.Size = UDim2.fromScale(var54 / 100, 1)
		percent_upvr.Text = var54..'%'
		-- KONSTANTWARNING: GOTO [118] #100
	end
	-- KONSTANTERROR: [3] 3. Error Block 40 end (CF ANALYSIS FAILED)
end)
delay(20, function() -- Line 242
	--[[ Upvalues[1]:
		[1]: skipBtn_upvr (readonly)
	]]
	skipBtn_upvr.Visible = true
end)
local LocalPlayer = game.Players.LocalPlayer
LocalPlayer:WaitForChild("人物加载完成", math.huge)
while wait(0.1) do
	if LocalPlayer:WaitForChild("本地脚本加载完成", math.huge).Value == true then
		var51_upvw = true
		return
	end
end