-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:02
-- Luau version 6, Types version 3
-- Time taken: 0.004416 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local any_GetRawLink_result1_upvr = Util_upvr.Link:GetRawLink("PlayerData")
	local Content_upvr = arg1.Container:WaitForChild("Content")
	local Fill_upvr = Content_upvr.Fill.Assets.Fill
	local function UpdateFillCells_upvr() -- Line 19, Named "UpdateFillCells"
		--[[ Upvalues[3]:
			[1]: Content_upvr (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: Fill_upvr (readonly)
		]]
		local maximum = math.max(math.ceil((#Content_upvr.Contents:GetChildren() - 2) / 6), 3)
		for i = 1, maximum * 6 do
			if not any_new_result1_upvr["Fill"..i] then
				local clone = Fill_upvr:Clone()
				clone.Visible = true
				clone.Parent = Content_upvr.Fill
				any_new_result1_upvr["Fill"..i] = clone
			end
		end
		for i_2 = maximum * 6 + 1, #Content_upvr.Fill:GetChildren() - 2 do
			if any_new_result1_upvr["Fill"..i_2] then
				any_new_result1_upvr["Fill"..i_2] = nil
			end
		end
	end
	repeat
		task.wait()
	until Util_upvr.Windows
	local var17_upvw
	local function SetEquipped_upvr(arg1_2) -- Line 40, Named "SetEquipped"
		--[[ Upvalues[4]:
			[1]: var17_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		var17_upvw = arg1_2
		if arg1_2 then
			arg1.Select:SetAttribute("UI_ButtonColor")
			any_new_result1_upvr.PromptToEnchant = arg1.Select.MouseButton1Click:Connect(function() -- Line 44
				--[[ Upvalues[2]:
					[1]: Util_upvr (copied, readonly)
					[2]: arg1_2 (readonly)
				]]
				Util_upvr.Network:Fire("EnchantItem", arg1_2)
			end)
		else
			arg1.Select:SetAttribute("UI_ButtonColor", Color3.fromRGB(50, 50, 50))
			any_new_result1_upvr.PromptToEnchant = nil
		end
	end
	SetEquipped_upvr()
	for i_3 in pairs(any_GetRawLink_result1_upvr.Inventory) do
		(function(arg1_3) -- Line 54, Named "UpdateContent"
			--[[ Upvalues[8]:
				[1]: any_GetLink_result1_upvr (readonly)
				[2]: any_GetRawLink_result1_upvr (readonly)
				[3]: any_new_result1_upvr (readonly)
				[4]: Util_upvr (copied, readonly)
				[5]: var17_upvw (read and write)
				[6]: SetEquipped_upvr (readonly)
				[7]: Content_upvr (readonly)
				[8]: UpdateFillCells_upvr (readonly)
			]]
			local var19 = "Item_"..arg1_3
			if any_GetLink_result1_upvr.Inventory[arg1_3] and any_GetRawLink_result1_upvr.Inventory[arg1_3] then
				if any_new_result1_upvr[var19] then return end
				local any_CreateFrameItem_result1_upvr, any_CreateFrameItem_result2 = Util_upvr.BallFrameController:CreateFrameItem(arg1_3)
				any_CreateFrameItem_result1_upvr.Visible = true
				local function UpdateEquipped_upvr(arg1_4) -- Line 63, Named "UpdateEquipped"
					--[[ Upvalues[3]:
						[1]: Util_upvr (copied, readonly)
						[2]: any_CreateFrameItem_result1_upvr (readonly)
						[3]: any_GetLink_result1_upvr (copied, readonly)
					]]
					-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [73] 55. Error Block 15 start (CF ANALYSIS FAILED)
					local var22 = any_GetLink_result1_upvr.Stars[arg1_4]
					local var23 = var22
					if var23 then
						var23 = Util_upvr.Assets:GetAsset("Stars", var22.Name)
					end
					any_CreateFrameItem_result1_upvr.EquippedStar.Image = var23:GetAttribute("Icon") or "rbxassetid://9561109778"
					any_CreateFrameItem_result1_upvr.Equipped.Visible = false
					any_CreateFrameItem_result1_upvr.EquippedStar.Visible = true
					do
						return
					end
					-- KONSTANTERROR: [73] 55. Error Block 15 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [111] 82. Error Block 12 start (CF ANALYSIS FAILED)
					any_CreateFrameItem_result1_upvr.Equipped.Visible = false
					any_CreateFrameItem_result1_upvr.EquippedStar.Visible = false
					-- KONSTANTERROR: [111] 82. Error Block 12 end (CF ANALYSIS FAILED)
				end
				any_CreateFrameItem_result2.ToggleEquip = any_CreateFrameItem_result1_upvr.MouseButton1Click:Connect(function() -- Line 87
					--[[ Upvalues[6]:
						[1]: Util_upvr (copied, readonly)
						[2]: var17_upvw (copied, read and write)
						[3]: arg1_3 (readonly)
						[4]: UpdateEquipped_upvr (readonly)
						[5]: SetEquipped_upvr (copied, readonly)
						[6]: any_new_result1_upvr (copied, readonly)
					]]
					Util_upvr.Sounds:Play("ChestPopInfo")
					if var17_upvw ~= arg1_3 then
						UpdateEquipped_upvr(true)
						SetEquipped_upvr(arg1_3)
						function any_new_result1_upvr.ResetEquipped() -- Line 92
							--[[ Upvalues[1]:
								[1]: UpdateEquipped_upvr (copied, readonly)
							]]
							UpdateEquipped_upvr(false)
						end
					elseif any_new_result1_upvr.ResetEquipped then
						SetEquipped_upvr()
						any_new_result1_upvr.ResetEquipped = nil
					end
				end)
				UpdateEquipped_upvr(false)
				any_CreateFrameItem_result1_upvr.Parent = Content_upvr.Contents
				any_new_result1_upvr[var19] = any_CreateFrameItem_result2
			else
				any_CreateFrameItem_result1_upvr = any_new_result1_upvr[var19]
				if any_CreateFrameItem_result1_upvr then
					any_CreateFrameItem_result1_upvr = any_new_result1_upvr
					any_CreateFrameItem_result1_upvr[var19] = nil
				end
			end
			any_CreateFrameItem_result1_upvr = UpdateFillCells_upvr
			any_CreateFrameItem_result1_upvr()
		end)(i_3)
		local var29
	end
	any_GetLink_result1_upvr.Inventory.Changed:Connect(var29)
	Content_upvr.Fill.UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line 118, Named "UpdateCanvasSize"
		--[[ Upvalues[1]:
			[1]: Content_upvr (readonly)
		]]
		Content_upvr.CanvasSize = UDim2.new(0, 0, 0, Content_upvr.Fill.UIGridLayout.AbsoluteContentSize.Y + 4)
	end)
	UpdateFillCells_upvr()
	Content_upvr.CanvasSize = UDim2.new(0, 0, 0, Content_upvr.Fill.UIGridLayout.AbsoluteContentSize.Y + 4)
	return any_new_result1_upvr
end
return module