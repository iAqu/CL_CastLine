-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:48
-- Luau version 6, Types version 3
-- Time taken: 0.004475 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
Util_upvr.MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(...) -- Line 6
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	Util_upvr.Windows.State:RemoveState(6)
end)
local tbl_upvr = {
	["41830155"] = 1269167822;
	["41830171"] = 1269167844;
	["41830202"] = 1269167921;
	["41830261"] = 1269167955;
	["41830288"] = 1269168011;
	["41830310"] = 1269168042;
	["41830354"] = 1269168097;
	["41830680"] = 1269168140;
	["42724063"] = 1269168167;
	["47225987"] = 1269168208;
	["47226075"] = 1269168260;
	["55416490"] = 1277340622;
}
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 28
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	any_new_result1_upvr.Active = true
	task.spawn(function() -- Line 31
		--[[ Upvalues[5]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: arg1 (readonly)
			[4]: tbl_upvr (copied, readonly)
			[5]: LocalPlayer_upvr (copied, readonly)
		]]
		repeat
			task.wait()
		until Util_upvr.GiftSelection
		if not any_new_result1_upvr.Active then
		else
			local any_GetLink_result1_upvr_2 = Util_upvr.Link:GetLink("PlayerData")
			local any_GetProductInfo_result1_upvr = Util_upvr.MarketplaceService:GetProductInfo(arg1.Name, Enum.InfoType.GamePass)
			arg1.Content.Title.Text = any_GetProductInfo_result1_upvr.Name
			arg1.Content.Description.DescText.Text = any_GetProductInfo_result1_upvr.Description
			arg1.Content.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(any_GetProductInfo_result1_upvr.PriceInRobux)
			arg1.Content.ItemIcon.Image = "rbxassetid://"..any_GetProductInfo_result1_upvr.IconImageAssetId
			arg1.LayoutOrder = -any_GetProductInfo_result1_upvr.PriceInRobux
			any_new_result1_upvr.MouseDown = arg1.MouseButton1Down:Connect(function() -- Line 43
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: any_new_result1_upvr (copied, readonly)
				]]
				arg1.Content:TweenSize(UDim2.new(0.85, 0, 0.85, 0), nil, nil, 0.2, true)
				function any_new_result1_upvr.Unclick() -- Line 45
					--[[ Upvalues[1]:
						[1]: arg1 (copied, readonly)
					]]
					arg1.Content:TweenSize(UDim2.new(1, 0, 1, 0), nil, nil, 0.2, true)
				end
			end)
			local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("ServerData")
			any_new_result1_upvr.PromptBuy = arg1.MouseButton1Click:Connect(function() -- Line 51
				--[[ Upvalues[7]:
					[1]: any_GetLink_result1_upvr (readonly)
					[2]: tbl_upvr (copied, readonly)
					[3]: arg1 (copied, readonly)
					[4]: Util_upvr (copied, readonly)
					[5]: any_GetProductInfo_result1_upvr (readonly)
					[6]: LocalPlayer_upvr (copied, readonly)
					[7]: any_GetLink_result1_upvr_2 (readonly)
				]]
				local GiftingTo = any_GetLink_result1_upvr.GiftingTo
				if GiftingTo then
					if not GiftingTo.Parent then
					else
						local var16_upvr = tbl_upvr[arg1.Name]
						if not var16_upvr then return end
						Util_upvr.Windows:PromptNotification({
							Sound = "windowswitch";
							Text = "Do you really want to gift <font color=\"#FF89FF\">"..any_GetProductInfo_result1_upvr.Name.."</font> to <font color=\"#ff0000\">@"..GiftingTo.Name.."</font>?";
							Text1 = "No";
							Text2 = "Gift";
							Option2 = function() -- Line 64, Named "Option2"
								--[[ Upvalues[3]:
									[1]: Util_upvr (copied, readonly)
									[2]: LocalPlayer_upvr (copied, readonly)
									[3]: var16_upvr (readonly)
								]]
								Util_upvr.MarketplaceService:PromptProductPurchase(LocalPlayer_upvr, var16_upvr)
								Util_upvr.Sounds:Play("Pop")
								Util_upvr.Windows.State:AddState(6, false, function() -- Line 67
									--[[ Upvalues[1]:
										[1]: Util_upvr (copied, readonly)
									]]
									Util_upvr.Loader:SetLoading()
									return function() -- Line 69
										--[[ Upvalues[1]:
											[1]: Util_upvr (copied, readonly)
										]]
										Util_upvr.Loader:DisableLoading()
									end
								end)
							end;
						})
					end
				end
				var16_upvr = any_GetLink_result1_upvr_2.GamePass[arg1.Name]
				if not var16_upvr then
					var16_upvr = Util_upvr.MarketplaceService:PromptGamePassPurchase
					var16_upvr(LocalPlayer_upvr, arg1.Name)
					var16_upvr = Util_upvr.Sounds:Play
					var16_upvr("Pop")
					var16_upvr = Util_upvr.Windows.State
					var16_upvr = var16_upvr:AddState
					var16_upvr(6, false, function() -- Line 78
						--[[ Upvalues[1]:
							[1]: Util_upvr (copied, readonly)
						]]
						Util_upvr.Loader:SetLoading()
						return function() -- Line 80
							--[[ Upvalues[1]:
								[1]: Util_upvr (copied, readonly)
							]]
							Util_upvr.Loader:DisableLoading()
						end
					end)
				end
			end)
			any_new_result1_upvr.MouseUp = arg1.MouseButton1Up:Connect(function() -- Line 86
				--[[ Upvalues[4]:
					[1]: any_GetLink_result1_upvr (readonly)
					[2]: any_GetLink_result1_upvr_2 (readonly)
					[3]: arg1 (copied, readonly)
					[4]: any_new_result1_upvr (copied, readonly)
				]]
				if not any_GetLink_result1_upvr.GiftingTo and any_GetLink_result1_upvr_2.GamePass[arg1.Name] then
				else
					any_new_result1_upvr.Unclick = nil
				end
			end)
			any_new_result1_upvr.MouseEnter = arg1.MouseEnter:Connect(function() -- Line 91
				--[[ Upvalues[3]:
					[1]: any_GetLink_result1_upvr_2 (readonly)
					[2]: arg1 (copied, readonly)
					[3]: any_new_result1_upvr (copied, readonly)
				]]
				if any_GetLink_result1_upvr_2.GamePass[arg1.Name] then
				else
					arg1.Content.Description.DescText:TweenPosition(UDim2.new(0.5, 0, 0, 0), nil, nil, 0.2, true)
					function any_new_result1_upvr.Unhover() -- Line 94
						--[[ Upvalues[1]:
							[1]: arg1 (copied, readonly)
						]]
						arg1.Content.Description.DescText:TweenPosition(UDim2.new(0.5, 0, 1, 0), nil, nil, 0.2, true)
					end
				end
			end)
			any_new_result1_upvr.MouseLeave = arg1.MouseLeave:Connect(function() -- Line 98
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (copied, readonly)
				]]
				any_new_result1_upvr.Unclick = nil
				any_new_result1_upvr.Unhover = nil
			end)
			local function UpdateOwned(arg1_2) -- Line 103
				--[[ Upvalues[4]:
					[1]: any_GetLink_result1_upvr_2 (readonly)
					[2]: arg1 (copied, readonly)
					[3]: Util_upvr (copied, readonly)
					[4]: any_GetProductInfo_result1_upvr (readonly)
				]]
				if not arg1_2 and any_GetLink_result1_upvr_2.GamePass[arg1.Name] then
					arg1.Content.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
					arg1.Content.ItemIcon.ImageTransparency = 0.7
					arg1.Content.Price.AmountText.Text = "Owned!"
					arg1.Content.Glow.Visible = false
					arg1.Content.Price.Icon.Visible = false
				else
					arg1.Content.BackgroundColor3 = Color3.fromRGB(48, 184, 255)
					arg1.Content.ItemIcon.ImageTransparency = 0
					arg1.Content.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(any_GetProductInfo_result1_upvr.PriceInRobux)
					arg1.Content.Glow.Visible = true
					arg1.Content.Price.Icon.Visible = true
				end
			end
			UpdateOwned(any_GetLink_result1_upvr.GiftingTo)
			any_new_result1_upvr.GiftSelectionChanged = any_GetLink_result1_upvr.Changed:On("GiftingTo", UpdateOwned)
			any_new_result1_upvr.UpdateOwned = any_GetLink_result1_upvr_2.GamePass.Changed:On(arg1.Name, UpdateOwned)
		end
	end)
	return any_new_result1_upvr
end
return module