-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:57
-- Luau version 6, Types version 3
-- Time taken: 0.005089 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_upvr = {
	DefaultText = function(arg1, arg2, arg3) -- Line 9, Named "DefaultText"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		local Text = arg2.Text
		if not Text then
			Text = arg1.ContentText
		end
		arg1.Size = UDim2.new(1, 0, 0, Util_upvr.TextService:GetTextSize(Text, arg1.TextSize, arg1.Font, Vector2.new(arg3, math.huge)).Y)
		local Text_2 = arg2.Text
		if not Text_2 then
			Text_2 = arg1.Text
		end
		arg1.Text = Text_2
	end;
	ProgressBar = function(arg1, arg2) -- Line 14, Named "ProgressBar"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		arg1.SubText.Text = arg2.Text
		arg1.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(arg2.Percentage, 0.025)
	end;
	BubbleText = function(arg1, arg2, arg3) -- Line 18, Named "BubbleText"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		local any_GetTextSize_result1 = Util_upvr.TextService:GetTextSize(arg2.Text, arg1.SubText.TextSize, arg1.SubText.Font, Vector2.new(arg3 - 10, math.huge))
		arg1.SubText.Text = arg2.Text
		arg1.Size = UDim2.new(any_GetTextSize_result1.X / arg1.AbsoluteSize.X + 0.125, 0, 0, any_GetTextSize_result1.Y + 4)
	end;
	EnchantmentText = function(arg1, arg2, arg3) -- Line 23, Named "EnchantmentText"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		arg1.SubText.Text = ' '..arg2.Text
		arg1.Icon.Image = Util_upvr.Icons[arg2.FrameIcon or "EnchantmentTier0"]
		arg1.Icon.SubIcon.Image = arg2.Icon or "rbxassetid://9557580777"
		arg1.SubText.Size = UDim2.new(0, Util_upvr.TextService:GetTextSize(arg2.Text, arg1.SubText.TextSize, arg1.SubText.Font, Vector2.new(arg3 - 10, math.huge)).X, arg1.SubText.Size.Y.Scale, arg1.SubText.Size.Y.Offset)
	end;
}
local function _(arg1, arg2, arg3) -- Line 33, Named "SetAppearance"
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local var7 = tbl_upvr[arg2.ActionType]
	if var7 then
		return var7(arg1, arg2, arg3)
	end
end
local CurrentCamera_upvr = workspace.CurrentCamera
local tbl_upvr_2 = {}
local RunService_upvr = game:GetService("RunService")
local mouse_upvr = game:GetService("Players").LocalPlayer:GetMouse()
function module.Show(arg1, arg2) -- Line 44
	--[[ Upvalues[6]:
		[1]: tbl_upvr_2 (readonly)
		[2]: Util_upvr (readonly)
		[3]: tbl_upvr (readonly)
		[4]: RunService_upvr (readonly)
		[5]: CurrentCamera_upvr (readonly)
		[6]: mouse_upvr (readonly)
	]]
	for i_upvr, v in pairs(tbl_upvr_2) do
		if arg2.CornerRarityColor and (not v.Maid.UIStrokeGradient or v.Maid.UIStrokeGradient.Name ~= arg2.CornerRarityColor) then
			local any_GetAsset_result1 = Util_upvr.Assets:GetAsset("Colors", arg2.CornerRarityColor)
			any_GetAsset_result1.Parent = i_upvr.Container.UIStroke
			v.Maid.UIStrokeGradient = any_GetAsset_result1
		end
		for i_2 = 1, math.max(#arg2, #v.Content._tasks) do
			local var19 = arg2[i_2]
			if not var19 then
				v.Content["Frame_"..i_2] = nil
			else
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				local var20 = v.Content["Frame_"..i_2]
				if not var20 or var20.Name ~= var19.ActionType then
					local SOME = i_upvr.Container.Assets:FindFirstChild(var19.ActionType)
					if not SOME then
						warn("Invalid given ActionType:", var19.ActionType)
						return
					end
					local any_Create_result1 = Util_upvr.Create(SOME, var19.Property)
					any_Create_result1.Parent = i_upvr.Container.Scroll
					v.Content[i_2] = any_Create_result1
					any_Create_result1.Visible = true
				end
				if tbl_upvr[var19.ActionType] then
				end
			end
		end
		if next(v.Content._tasks) then
			if v.Maid.Active then return end
			i_upvr.Enabled = true
			v.Maid.Clear = v.Content
			v.Maid.Active = function() -- Line 79
				--[[ Upvalues[1]:
					[1]: i_upvr (readonly)
				]]
				i_upvr.Enabled = false
			end
			v.Maid.Rendering = RunService_upvr.Heartbeat:Connect(function() -- Line 82
				--[[ Upvalues[3]:
					[1]: CurrentCamera_upvr (copied, readonly)
					[2]: i_upvr (readonly)
					[3]: mouse_upvr (copied, readonly)
				]]
				local ViewportSize = CurrentCamera_upvr.ViewportSize
				i_upvr.Container.Position = UDim2.new(0, math.clamp(mouse_upvr.X, 40, ViewportSize.X - i_upvr.Container.AbsoluteSize.X - 40), 0, math.clamp(mouse_upvr.Y, 40, ViewportSize.Y - i_upvr.Container.AbsoluteSize.Y - 40))
			end)
		elseif v.Maid.Active then
			v.Maid:Destroy()
		end
	end
end
function module.Clear(arg1) -- Line 92
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	for _, v_2 in pairs(tbl_upvr_2) do
		v_2.Maid:Destroy()
	end
end
function module.Binder(arg1) -- Line 99
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
		[3]: CurrentCamera_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local any_new_result1_2 = Util_upvr.Maid.new()
	tbl_upvr_2[arg1] = {
		Content = Util_upvr.Maid.new();
		Maid = any_new_result1_2;
	}
	any_new_result1.UIListLayoutChanged = arg1.Container.Scroll.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line 107, Named "UpdateFrameSize"
		--[[ Upvalues[2]:
			[1]: CurrentCamera_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		arg1.Container.Size = UDim2.new(0, CurrentCamera_upvr.ViewportSize.X * 0.25, 0, math.min(CurrentCamera_upvr.ViewportSize.Y * 0.5, arg1.Container.Scroll.UIListLayout.AbsoluteContentSize.Y + 10))
	end)
	arg1.Container.Size = UDim2.new(0, CurrentCamera_upvr.ViewportSize.X * 0.25, 0, math.min(CurrentCamera_upvr.ViewportSize.Y * 0.5, arg1.Container.Scroll.UIListLayout.AbsoluteContentSize.Y + 10))
	any_new_result1.ContentMaid = any_new_result1_2
	any_new_result1:GiveTask(function() -- Line 116
		--[[ Upvalues[2]:
			[1]: tbl_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr_2[arg1] = nil
	end)
	return any_new_result1
end
Util_upvr.FocusFrame = module
return module