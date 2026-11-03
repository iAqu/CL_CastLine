-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:51
-- Luau version 6, Types version 3
-- Time taken: 0.017960 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("BaseObject")
local var1_result1_upvr_4 = any_load_result1("DialogStyleUtils")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_3)
setmetatable_result1_upvr.ClassName = "DialogTextRenderer"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr_5 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr = any_load_result1("AccelTween")
local any_load_result1_result1_upvr_4 = any_load_result1("Signal")
function setmetatable_result1_upvr.new(arg1, arg2, arg3) -- Line 29
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr_5 (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr_3.new(), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr_2._guiThemeService = setmetatable_result1_upvr_2._serviceBag:GetService(var1_result1_upvr_5)
	local var9 = arg2
	if not var9 then
		var9 = error("No container")
	end
	setmetatable_result1_upvr_2._container = var9
	var9 = arg3
	local var10 = var9
	if not var10 then
		var10 = error("No dialogInput")
	end
	setmetatable_result1_upvr_2._dialogInput = var10
	setmetatable_result1_upvr_2._percentVisible = 0
	setmetatable_result1_upvr_2._textScrolling = true
	setmetatable_result1_upvr_2._labelCount = 0
	setmetatable_result1_upvr_2._renderLines = {}
	setmetatable_result1_upvr_2._yOffset = any_load_result1_result1_upvr.new(2000)
	setmetatable_result1_upvr_2.WritingText = any_load_result1_result1_upvr_4.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.WritingText)
	setmetatable_result1_upvr_2.DoneWaitingForInput = any_load_result1_result1_upvr_4.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.DoneWaitingForInput)
	setmetatable_result1_upvr_2.HumanoidParticipantEvent = any_load_result1_result1_upvr_4.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.HumanoidParticipantEvent)
	setmetatable_result1_upvr_2.WaitingForRequestNextInput = Instance.new("BoolValue")
	setmetatable_result1_upvr_2.WaitingForRequestNextInput.Value = false
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.WaitingForRequestNextInput)
	setmetatable_result1_upvr_2.Done = any_load_result1_result1_upvr_4.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.Done)
	setmetatable_result1_upvr_2._skipToEndOfLine = false
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._dialogInput.RequestedNextInput:Connect(function() -- Line 64
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._skipToEndOfLine = true
	end))
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.DisableTextScrolling(arg1) -- Line 72
	arg1._textScrolling = false
end
function setmetatable_result1_upvr.SetTalkingSounds(arg1, arg2) -- Line 76
	local var12
	if type(arg2) ~= "table" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad dialogTalkingSounds")
	arg1._talkingSounds = arg2
	arg1._maid:GiveTask(arg1._talkingSounds)
end
function setmetatable_result1_upvr.SetPercentVisible(arg1, arg2) -- Line 83
	local var17 = arg2
	if not var17 then
		var17 = error("No percentVisible")
	end
	arg1._percentVisible = var17
	for _, v in pairs(arg1._renderLines) do
		v:SetPercentVisible(arg2)
	end
end
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_upvr.ShowLines(arg1, arg2, arg3) -- Line 91
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: RunService_upvr (readonly)
	]]
	assert(arg2, "Bad lines")
	assert(arg3, "Bad availableHeight")
	local var22_upvw = true
	arg1._maid:GiveTask(function() -- Line 96
		--[[ Upvalues[1]:
			[1]: var22_upvw (read and write)
		]]
		var22_upvw = false
	end)
	task.spawn(function() -- Line 100
		--[[ Upvalues[6]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
			[5]: RunService_upvr (copied, readonly)
			[6]: var22_upvw (read and write)
		]]
		arg1._playbackSpeed = 1
		arg1._volumeMultiplier = 1
		arg1._currentStyleStack = var1_result1_upvr_4.createDefaultStack()
		arg1._currentStyle = var1_result1_upvr_4.getStyleFromStack(arg1._currentStyleStack)
		for _ in arg1:_renderLoop(arg2, arg3) do
			RunService_upvr.RenderStepped:wait()
			if not var22_upvw then break end
		end
	end)
end
function setmetatable_result1_upvr._loopUntilEvent(arg1, arg2) -- Line 115
	local var29_upvw = false
	local any_GiveTask_result1_upvr = arg1._maid:GiveTask(arg2:Connect(function() -- Line 117
		--[[ Upvalues[1]:
			[1]: var29_upvw (read and write)
		]]
		var29_upvw = true
	end))
	return coroutine.wrap(function() -- Line 121
		--[[ Upvalues[3]:
			[1]: var29_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: any_GiveTask_result1_upvr (readonly)
		]]
		while not var29_upvw do
			coroutine.yield(true)
		end
		arg1._maid[any_GiveTask_result1_upvr] = nil
	end)
end
local var1_result1_upvr_9 = any_load_result1("DialogLineTypes")
local var1_result1_upvr_3 = any_load_result1("DialogRenderLine")
function setmetatable_result1_upvr._renderLoop(arg1, arg2, arg3) -- Line 129
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_9 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
	]]
	assert(arg2, "Bad lines")
	assert(arg3, "Bad availableHeight")
	return coroutine.wrap(function() -- Line 133
		--[[ Upvalues[5]:
			[1]: arg2 (readonly)
			[2]: var1_result1_upvr_9 (copied, readonly)
			[3]: arg1 (readonly)
			[4]: arg3 (readonly)
			[5]: var1_result1_upvr_3 (copied, readonly)
		]]
		for i_3, v_2 in pairs(arg2) do
			if v_2.type == var1_result1_upvr_9.LINE then
				if arg3 < v_2.offsetY + v_2.height + arg1._yOffset.t then
					arg1:_waitForNextYValueInCoroutine()
					arg1._skipToEndOfLine = false
					for _ in arg1:_setYOffsetLoop(-v_2.offsetY) do
						coroutine.yield(true)
					end
				end
				local any_new_result1 = var1_result1_upvr_3.new(arg1._container, v_2)
				any_new_result1:SetPercentVisible(arg1._percentVisible)
				any_new_result1:SetYOffset(arg1._yOffset.p)
				table.insert(arg1._renderLines, any_new_result1)
				arg1._maid:GiveTask(any_new_result1)
				for i_5 in arg1:_renderLineLoop(v_2, any_new_result1) do
					coroutine.yield(true)
				end
			elseif v_2.type == var1_result1_upvr_9.FORCED_PAGE_BREAK_LINE then
				local var50 = arg2[i_3 + 1]
				if var50 and var50.type == var1_result1_upvr_9.LINE then
					arg1:_waitForNextYValueInCoroutine()
					arg1._skipToEndOfLine = false
					arg1._yOffset.t = -var50.offsetY
					i_5 = arg1
					arg1._yOffset.p = i_5._yOffset.t
					arg1:_updateYOffset()
				else
					warn("[DialogTextRenderer._renderLoop] - Invalid FORCED_PAGE_BREAK, next item isn't a line")
				end
			else
				i_5 = v_2.type
				warn("[DialogTextRenderer._renderLoop] - Uknown line type %q":format(tostring(i_5)))
			end
		end
		arg1:_waitForNextYValueInCoroutine()
		arg1.Done:Fire()
	end)
end
function setmetatable_result1_upvr._waitForNextYValueInCoroutine(arg1) -- Line 177
	arg1.WaitingForRequestNextInput.Value = true
	for _ in arg1:_loopUntilEvent(arg1._dialogInput.RequestedNextInput) do
		coroutine.yield(true)
	end
	arg1.WaitingForRequestNextInput.Value = false
	arg1.DoneWaitingForInput:Fire()
end
function setmetatable_result1_upvr._setYOffsetLoop(arg1, arg2) -- Line 186
	arg1._yOffset.t = arg2
	return coroutine.wrap(function() -- Line 189
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		while 0 < arg1._yOffset.rtime do
			arg1:_updateYOffset()
			coroutine.yield(true)
		end
		arg1:_updateYOffset()
	end)
end
function setmetatable_result1_upvr._updateYOffset(arg1) -- Line 199
	for _, v_3 in pairs(arg1._renderLines) do
		v_3:SetYOffset(arg1._yOffset.p)
	end
end
local any_load_result1_result1_upvr_2 = any_load_result1("DialogEventTypes")
local var1_result1_upvr = any_load_result1("DialogConstants")
function setmetatable_result1_upvr._renderLineLoop(arg1, arg2, arg3) -- Line 205
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	return coroutine.wrap(function() -- Line 206
		--[[ Upvalues[6]:
			[1]: arg2 (readonly)
			[2]: any_load_result1_result1_upvr_2 (copied, readonly)
			[3]: arg1 (readonly)
			[4]: var1_result1_upvr_4 (copied, readonly)
			[5]: arg3 (readonly)
			[6]: var1_result1_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		local pairs_result1_2, pairs_result2_2, pairs_result3_2 = pairs(arg2.items)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [398] 279. Error Block 56 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [398] 279. Error Block 56 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [8] 7. Error Block 100 start (CF ANALYSIS FAILED)
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [398.6]
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [398.7]
		if nil == nil then
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			if nil == nil then
			else
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				if nil == nil then
					if not nil then
					end
					if nil then
						-- KONSTANTERROR: Expression was reused, decompilation is incorrect
						if not nil then
							-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [398.8]
							-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [398.9]
							-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [398.10]
							for i_8, _ in nil do
							end
							-- KONSTANTERROR: Expression was reused, decompilation is incorrect
							if nil <= nil then
							end
							repeat
								if i_8 < nil then
								end
								if i_8 < nil then
									-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [398.13]
									if nil then
									end
								else
								end
								-- KONSTANTERROR: Expression was reused, decompilation is incorrect
							until nil == i_8 and i_8
						end
					end
				else
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					if nil == nil then
						-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
						if nil <= nil and not nil then
							-- KONSTANTWARNING: GOTO [251] #179
						end
					else
						-- KONSTANTERROR: Expression was reused, decompilation is incorrect
						if nil == nil then
						else
							-- KONSTANTERROR: Expression was reused, decompilation is incorrect
							if nil == nil then
							else
								-- KONSTANTERROR: Expression was reused, decompilation is incorrect
								if nil == nil then
									-- KONSTANTERROR: Expression was reused, decompilation is incorrect
									if nil then
										-- KONSTANTWARNING: GOTO [398] #279
									end
								else
									-- KONSTANTERROR: Expression was reused, decompilation is incorrect
									if nil == nil then
									else
										-- KONSTANTERROR: Expression was reused, decompilation is incorrect
										if nil == nil then
										else
										end
									end
								end
							end
						end
					end
				end
			end
		end
		-- KONSTANTERROR: [8] 7. Error Block 100 end (CF ANALYSIS FAILED)
	end)
end
local var1_result1_upvr_2 = any_load_result1("HintInput")
function setmetatable_result1_upvr._createHintInput(arg1, arg2, arg3) -- Line 294
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local var87
	if type(arg3.inputKeyMapList) ~= "table" then
		var87 = false
	else
		var87 = true
	end
	assert(var87, "Bad positionedInputHint.inputKeyMapList")
	if type(arg3.offsetX) ~= "number" then
		var87 = false
	else
		var87 = true
	end
	assert(var87, "Bad positionedInputHint.offsetX")
	var87 = arg1._labelCount
	arg1._labelCount = var87 + 1
	var87 = arg2.height
	var87 = var1_result1_upvr_2.new(arg1._serviceBag, arg3.inputKeyMapList)
	var87.Gui.Name = "%03d_DialogInputHint":format(arg1._labelCount)
	var87.Gui.AnchorPoint = Vector2.new(0, 0)
	var87.Gui.Size = UDim2.new(0, arg3.size.x, 0, arg3.size.y)
	var87.Gui.Position = UDim2.new(0, arg3.offsetX, 0, (arg2.offsetY) + (var87 - arg3.size.y))
	return var87
end
local var1_result1_upvr_8 = any_load_result1("Maid")
local var1_result1_upvr_6 = any_load_result1("Blend")
local var1_result1_upvr_7 = any_load_result1("DialogAccentColorUtils")
function setmetatable_result1_upvr._getNewTextLabel(arg1, arg2, arg3) -- Line 311
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_8 (readonly)
		[2]: var1_result1_upvr_6 (readonly)
		[3]: var1_result1_upvr_7 (readonly)
	]]
	assert(arg3.offsetX, "Bad positionedWord.offsetX")
	assert(arg2.offsetY, "Bad line.offsetY")
	assert(arg2.height, "Bad line.height")
	arg1._labelCount += 1
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Text = ""
	TextLabel.Name = "%03d_DialogTextLabel":format(arg1._labelCount)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 1
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	TextLabel.LineHeight = 1
	TextLabel.Font = arg1._currentStyle.font
	TextLabel.TextSize = arg1._currentStyle.textSize
	TextLabel.Size = UDim2.new(0, 0, 0, arg2.height)
	TextLabel.Position = UDim2.new(0, arg3.offsetX, 0, arg2.offsetY)
	var1_result1_upvr_8.new():GiveTask(var1_result1_upvr_6.mount(TextLabel, {
		TextColor3 = var1_result1_upvr_7.computeTextColor(arg1._guiThemeService:ObserveColor("surface"), arg1._currentStyle.textColor3);
	}))
	return TextLabel
end
return setmetatable_result1_upvr