-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:40
-- Luau version 6, Types version 3
-- Time taken: 0.004561 seconds

local module_2_upvr = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
Util_upvr.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
local TweenService_upvr = game:GetService("TweenService")
function module_2_upvr.Fade(arg1, arg2) -- Line 11
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: TweenService_upvr (readonly)
	]]
	local module = {}
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 100
	ScreenGui.Parent = LocalPlayer_upvr.PlayerGui
	local Frame_upvr = Instance.new("Frame")
	Frame_upvr.BorderSizePixel = 0
	Frame_upvr.Size = UDim2.new(1, 0, 0, -36)
	Frame_upvr.Position = UDim2.new(0, 0, 0, -game:GetService("GuiService"):GetGuiInset().Y)
	Frame_upvr.BackgroundColor3 = Color3.new(0.17254901960784313, 0.1843137254901961, 0.2)
	Frame_upvr.Parent = ScreenGui
	local clone_upvr = Frame_upvr:Clone()
	local var10 = arg2
	if not var10 then
		var10 = Color3.new(0.1, 0.1, 0.1)
	end
	clone_upvr.BackgroundColor3 = var10
	clone_upvr.ZIndex = 1
	clone_upvr.Parent = ScreenGui
	any_new_result1_upvr:GiveTask(ScreenGui)
	any_new_result1_upvr:GiveTask(clone_upvr)
	any_new_result1_upvr:GiveTask(Frame_upvr)
	function module.Start(arg1_2) -- Line 36
		--[[ Upvalues[2]:
			[1]: TweenService_upvr (copied, readonly)
			[2]: Frame_upvr (readonly)
		]]
		TweenService_upvr:Create(Frame_upvr, TweenInfo.new(arg1_2), {
			Size = UDim2.new(1, 0, 1, game:GetService("GuiService"):GetGuiInset().Y);
		}):Play()
		task.wait(arg1_2)
	end
	function module.End(arg1_3, arg2_2) -- Line 40
		--[[ Upvalues[3]:
			[1]: TweenService_upvr (copied, readonly)
			[2]: clone_upvr (readonly)
			[3]: Frame_upvr (readonly)
		]]
		TweenService_upvr:Create(clone_upvr, TweenInfo.new(arg1_3 / 2), {
			Size = UDim2.new(1, 0, 1, game:GetService("GuiService"):GetGuiInset().Y);
		}):Play()
		task.wait(arg1_3 / 2 + (arg2_2 or 0))
		Frame_upvr.Size = UDim2.new(0, 0, 0, 0)
		TweenService_upvr:Create(clone_upvr, TweenInfo.new(arg1_3 / 2), {
			BackgroundTransparency = 1;
		}):Play()
		task.wait(arg1_3 / 2)
	end
	function module.Destroy() -- Line 48
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Destroy()
	end
	return module
end
function module_2_upvr.GetScreenGui(arg1, arg2) -- Line 54
	--[[ Upvalues[2]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: Util_upvr (readonly)
	]]
	for _, v in pairs(LocalPlayer_upvr.PlayerGui:GetChildren()) do
		if v:IsA("ScreenGui") and v.Name == arg2 then
			return v
		end
	end
	Util_upvr.Debug.warncontext("Tried to find ScreenGui but was not available yet.", debug.traceback())
	while task.wait(1) do
		for _, v_2 in pairs(LocalPlayer_upvr.PlayerGui:GetChildren()) do
			if v_2:IsA("ScreenGui") and v_2.Name == arg2 then
				Util_upvr.Debug.printcontext("Found:", v_2:GetFullName())
				return v_2
			end
		end
	end
end
Util_upvr.Network.Events.QuickFade = function(arg1, arg2) -- Line 71
	--[[ Upvalues[2]:
		[1]: module_2_upvr (readonly)
		[2]: Util_upvr (readonly)
	]]
	local var25_upvw = arg1 or 1
	local any_Fade_result1_upvr = module_2_upvr:Fade(arg2)
	any_Fade_result1_upvr.Start(var25_upvw / 3)
	Util_upvr.Thread.Delay(var25_upvw / 2, function() -- Line 76
		--[[ Upvalues[2]:
			[1]: any_Fade_result1_upvr (readonly)
			[2]: var25_upvw (read and write)
		]]
		any_Fade_result1_upvr.End(var25_upvw / 2)
		task.wait(var25_upvw / 2)
		any_Fade_result1_upvr:Destroy()
	end)
end
function module_2_upvr.PostRun(arg1) -- Line 83
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: module_2_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
	]]
	local var31_upvw
	var31_upvw = Util_upvr.Binder.new("UI_Asset", function(arg1_4) -- Line 86
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: var31_upvw (read and write)
		]]
		if Util_upvr.Assets:Check("UI", arg1_4.Name) == nil then
			arg1_4.Parent = Util_upvr.Assets:GetAsset("UI")
		else
			arg1_4:Destroy()
		end
		var31_upvw:UnbindClient(arg1_4)
	end)
	var31_upvw:Start()
	repeat
		task.wait()
	until Util_upvr.GameMath
	for _, v_3 in pairs(script.Parent.Parent.UIBinders:GetChildren()) do
		local v_3_2 = require(v_3)
		setmetatable(v_3_2, getmetatable(module_2_upvr))
		local Name_upvr = v_3.Name
		local Binder_upvr = v_3_2.Binder
		task.spawn(function() -- Line 104
			--[[ Upvalues[4]:
				[1]: Name_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: LocalPlayer_upvr (copied, readonly)
				[4]: Binder_upvr (readonly)
			]]
			local var39_upvr = "UIN__"..Name_upvr
			Util_upvr.Binder.new("UI_"..Name_upvr, function(arg1_5) -- Line 106
				--[[ Upvalues[3]:
					[1]: Util_upvr (copied, readonly)
					[2]: LocalPlayer_upvr (copied, readonly)
					[3]: var39_upvr (readonly)
				]]
				local any_new_result1_upvr_2 = Util_upvr.Maid.new()
				local function CheckParent() -- Line 108
					--[[ Upvalues[5]:
						[1]: any_new_result1_upvr_2 (readonly)
						[2]: arg1_5 (readonly)
						[3]: LocalPlayer_upvr (copied, readonly)
						[4]: Util_upvr (copied, readonly)
						[5]: var39_upvr (copied, readonly)
					]]
					if not any_new_result1_upvr_2.HasTag and (arg1_5:IsDescendantOf(workspace) or arg1_5:IsDescendantOf(LocalPlayer_upvr)) then
						Util_upvr.CollectionService:AddTag(arg1_5, var39_upvr)
						function any_new_result1_upvr_2.HasTag() -- Line 111
							--[[ Upvalues[3]:
								[1]: Util_upvr (copied, readonly)
								[2]: arg1_5 (copied, readonly)
								[3]: var39_upvr (copied, readonly)
							]]
							Util_upvr.CollectionService:RemoveTag(arg1_5, var39_upvr)
						end
					elseif any_new_result1_upvr_2.HasTag and not arg1_5:IsDescendantOf(workspace) and not arg1_5:IsDescendantOf(LocalPlayer_upvr) then
						any_new_result1_upvr_2.HasTag = nil
					end
				end
				any_new_result1_upvr_2:GiveTask(arg1_5.AncestryChanged:Connect(CheckParent))
				CheckParent()
				return any_new_result1_upvr_2
			end):Start()
			Util_upvr.Binder.new(var39_upvr, Binder_upvr):Start()
		end)
	end
end
Util_upvr.UI = module_2_upvr
return module_2_upvr