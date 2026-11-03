-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:59
-- Luau version 6, Types version 3
-- Time taken: 0.004215 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_upvr = {
	Soundtrack = function(arg1) -- Line 9, Named "Soundtrack"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		Util_upvr.SoundService.Soundtracks.Volume = (arg1 or 0) * 5
	end;
	SFX = function(arg1) -- Line 12, Named "SFX"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		Util_upvr.SoundService.SFX.Volume = (arg1 or 0) * 5
	end;
	Animations = function(arg1) -- Line 15, Named "Animations"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		local var4 = Util_upvr
		if arg1 ~= "false" then
			var4 = false
		else
			var4 = true
		end
		var4.AnimationsDisabled.Value = var4
	end;
}
local StarsFolder_upvr = workspace:WaitForChild("Ignore"):WaitForChild("StarsFolder")
function tbl_upvr.ShowStars(arg1) -- Line 18
	--[[ Upvalues[2]:
		[1]: StarsFolder_upvr (readonly)
		[2]: Util_upvr (readonly)
	]]
	local var6
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var6 = workspace.Ignore
		return var6
	end
	if arg1 ~= "true" or not INLINED() then
		var6 = Util_upvr.ReplicatedStorage
	end
	StarsFolder_upvr.Parent = var6
end
function tbl_upvr.ShowAwards(arg1) -- Line 21
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local var7
	if arg1 ~= "true" then
		var7 = false
	else
		var7 = true
	end
	Util_upvr.ShowAwards = var7
end
local function _(arg1, arg2) -- Line 26, Named "ApplySetting"
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local var8 = tbl_upvr[arg1]
	if not var8 then
	else
		var8(arg2)
	end
end
local mouse_upvr = game:GetService("Players").LocalPlayer:GetMouse()
function module.Binder(arg1) -- Line 35
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: mouse_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1 = Util_upvr.Link:GetLink("PlayerData")
	local var13_upvr = arg1:GetAttribute("InputType") or "Slider"
	local Name_upvr = arg1.Name
	if var13_upvr == "Boolean" then
		any_new_result1_upvr.OnClick = arg1.Value.Boolean.MouseButton1Down:Connect(function() -- Line 54
			--[[ Upvalues[3]:
				[1]: Util_upvr (copied, readonly)
				[2]: Name_upvr (readonly)
				[3]: arg1 (readonly)
			]]
			Util_upvr.Network:Fire("SetSetting", Name_upvr, tostring(not arg1.Value.Boolean.Title.Visible))
		end)
	elseif var13_upvr == "Slider" then
		local Bar_upvr = arg1.Value.Bar
		local Ball_upvr = Bar_upvr.Ball
		any_new_result1_upvr.OnHold = Ball_upvr.MouseButton1Down:Connect(function() -- Line 60
			--[[ Upvalues[6]:
				[1]: any_new_result1_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: mouse_upvr (copied, readonly)
				[4]: Bar_upvr (readonly)
				[5]: Name_upvr (readonly)
				[6]: Ball_upvr (readonly)
			]]
			function any_new_result1_upvr.UpdateValue() -- Line 61
				--[[ Upvalues[4]:
					[1]: Util_upvr (copied, readonly)
					[2]: mouse_upvr (copied, readonly)
					[3]: Bar_upvr (copied, readonly)
					[4]: Name_upvr (copied, readonly)
				]]
				Util_upvr.Network:Fire("SetSetting", Name_upvr, Util_upvr.ValueConvertor:GetPercentageFromNumbers(mouse_upvr.X, Bar_upvr.AbsolutePosition.X, Bar_upvr.AbsolutePosition.X + Bar_upvr.AbsoluteSize.X))
			end
			local os_clock_result1_upvw = os.clock()
			any_new_result1_upvr.UpdateSlider = Util_upvr.Thread.Loop(function() -- Line 66
				--[[ Upvalues[6]:
					[1]: Util_upvr (copied, readonly)
					[2]: mouse_upvr (copied, readonly)
					[3]: Bar_upvr (copied, readonly)
					[4]: Ball_upvr (copied, readonly)
					[5]: os_clock_result1_upvw (read and write)
					[6]: any_new_result1_upvr (copied, readonly)
				]]
				Ball_upvr.Position = UDim2.new(Util_upvr.ValueConvertor:GetPercentageFromNumbers(mouse_upvr.X, Bar_upvr.AbsolutePosition.X, Bar_upvr.AbsolutePosition.X + Bar_upvr.AbsoluteSize.X), 0, 0.5, 0)
				if 0.35 < os.clock() - os_clock_result1_upvw then
					os_clock_result1_upvw = os.clock()
					any_new_result1_upvr.UpdateValue()
				end
			end)
			any_new_result1_upvr.OnRelease = Util_upvr.Input.Actions.Click.Deactivated:Connect(function(arg1_3) -- Line 74
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (copied, readonly)
				]]
				any_new_result1_upvr.OnRelease = nil
				any_new_result1_upvr.UpdateSlider = nil
				any_new_result1_upvr.UpdateValue = nil
			end)
		end)
	end
	Ball_upvr = any_GetLink_result1.UserSettings
	Bar_upvr = Ball_upvr[arg1.Name]
	if var13_upvr == "Boolean" then
		local Boolean_2 = arg1.Value.Boolean
		Ball_upvr = Boolean_2.Title
		if Bar_upvr ~= "true" then
			Boolean_2 = false
		else
			Boolean_2 = true
		end
		Ball_upvr.Visible = Boolean_2
	elseif var13_upvr == "Slider" then
		Ball_upvr = arg1.Value.Bar.Ball
		Ball_upvr.Position = UDim2.new(Bar_upvr, 0, 0.5, 0)
	end
	Ball_upvr = tbl_upvr[Name_upvr]
	local var26 = Ball_upvr
	if not var26 then
	else
		var26(Bar_upvr)
	end
	var26 = any_GetLink_result1.UserSettings
	Bar_upvr = var26.Changed:On(arg1.Name, function(arg1_2) -- Line 44, Named "UpdateFrame"
		--[[ Upvalues[4]:
			[1]: var13_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: Name_upvr (readonly)
			[4]: tbl_upvr (copied, readonly)
		]]
		if var13_upvr == "Boolean" then
			local Boolean = arg1.Value.Boolean
			if arg1_2 ~= "true" then
				Boolean = false
			else
				Boolean = true
			end
			Boolean.Title.Visible = Boolean
		elseif var13_upvr == "Slider" then
			arg1.Value.Bar.Ball.Position = UDim2.new(arg1_2, 0, 0.5, 0)
		end
		local var16 = tbl_upvr[Name_upvr]
		if not var16 then
		else
			var16(arg1_2)
		end
	end)
	any_new_result1_upvr.SettingChanged = Bar_upvr
	return any_new_result1_upvr
end
return module