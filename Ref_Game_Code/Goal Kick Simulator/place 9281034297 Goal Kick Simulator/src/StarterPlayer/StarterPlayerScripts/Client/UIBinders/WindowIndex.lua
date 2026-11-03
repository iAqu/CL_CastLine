-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:05
-- Luau version 6, Types version 3
-- Time taken: 0.003818 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local module = {}
local Util_upvr = require(ReplicatedStorage_upvr.Util)
function module.Binder(arg1) -- Line 7
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	local any_GetLink_result1 = Util_upvr.Link:GetLink("PlayerData")
	local any_GetRawLink_result1_upvr = Util_upvr.Link:GetRawLink("PlayerData")
	if not any_GetLink_result1 or not any_GetRawLink_result1_upvr then return end
	for _, v_upvr in pairs(ReplicatedStorage_upvr.Assets.Chests:GetChildren()) do
		if not v_upvr:GetAttribute("Ignore") then
			local var18 = -(v_upvr:GetAttribute("Order") or 1) * 2
			local clone_2_upvr = arg1.Assets.HeaderTitle:Clone()
			clone_2_upvr.LayoutOrder = var18 - 1
			clone_2_upvr.Text = v_upvr.Name
			clone_2_upvr.Parent = arg1.Container.Content
			local clone_3_upvr = arg1.Assets.Container:Clone()
			clone_3_upvr.LayoutOrder = var18
			clone_3_upvr.Parent = arg1.Container.Content
			local tbl_2_upvr = {}
			for _, v_2 in pairs(v_upvr:GetChildren()) do
				local clone = arg1.Assets.ItemFrame:Clone()
				clone.Visible = true
				clone.Parent = clone_3_upvr
				clone.Content.Title.Text = "???"
				clone.Content.Power.Text = "???"
				clone.Content.Icon.ImageColor3 = Color3.new(0.1, 0.1, 0.1)
				clone.Content.Icon.ImageTransparency = 0.7
				local var27
				local function INLINED() -- Internal function, doesn't exist in bytecode
					var27 = Util_upvr.Assets:GetAsset("Balls", v_2.Name):GetAttribute("Icon")
					return var27
				end
				if not Util_upvr.Assets:GetAsset("Balls", v_2.Name) or not INLINED() then
					var27 = ""
				end
				clone.Content.Icon.Image = var27
				var27 = Color3.new(0.4, 0.4, 0.4)
				clone.Content.BackgroundColor3 = var27
				clone.LayoutOrder = 1
				tbl_2_upvr[v_2.Name] = clone
			end
			local function SetVisible_upvr(arg1_2, arg2) -- Line 49, Named "SetVisible"
				--[[ Upvalues[2]:
					[1]: tbl_2_upvr (readonly)
					[2]: Util_upvr (copied, readonly)
				]]
				-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
				local var36 = tbl_2_upvr[arg1_2]
				if not var36 then
					do
						return
					end
					local var37
				end
				if arg2 then
					local any_GetAsset_result1_2 = Util_upvr.Assets:GetAsset("Balls", arg1_2)
					if not any_GetAsset_result1_2 or not any_GetAsset_result1_2:GetAttribute("Rarity") then
					end
					var36.Content.Title.Text = arg1_2
					local function INLINED_2() -- Internal function, doesn't exist in bytecode
						var37 = any_GetAsset_result1_2:GetAttribute("PowerYield")
						return var37
					end
					if not any_GetAsset_result1_2 or not INLINED_2() then
						var37 = 1
					end
					var36.Content.Power.Text = Util_upvr.ValueConvertor:ShrinkNumber(var37)
					local function INLINED_3() -- Internal function, doesn't exist in bytecode
						var37 = "PowerYield"
						return any_GetAsset_result1_2:GetAttribute(var37)
					end
					if not any_GetAsset_result1_2 or not INLINED_3() then
					end
					var36.LayoutOrder = -1
					var37 = 1
					var36.Content.Icon.ImageColor3 = Color3.new(1, var37, 1)
					var36.Content.Icon.ImageTransparency = 0
					var37 = 184
					var36.Content.BackgroundColor3 = Color3.fromRGB(48, var37, 255)
					local tbl = {}
					var37 = var36
					tbl[1] = var37
					tbl[2] = var36.Content.UIStroke
					for _, v_3 in pairs(tbl) do
						local any_GetAsset_result1 = Util_upvr.Assets:GetAsset("Colors", "Common".."Gradient")
						if any_GetAsset_result1 then
							any_GetAsset_result1.Parent = v_3
						end
					end
				end
			end
			local function UpdateVisibility(arg1_3) -- Line 71
				--[[ Upvalues[5]:
					[1]: v_upvr (readonly)
					[2]: SetVisible_upvr (readonly)
					[3]: clone_2_upvr (readonly)
					[4]: clone_3_upvr (readonly)
					[5]: any_GetRawLink_result1_upvr (readonly)
				]]
				if arg1_3 then
					if v_upvr:FindFirstChild(arg1_3) then
						SetVisible_upvr(arg1_3, true)
						clone_2_upvr.Visible = true
						clone_3_upvr.Visible = true
					else
						SetVisible_upvr(arg1_3)
					end
				end
				for i_4 in pairs(any_GetRawLink_result1_upvr.BallIndex) do
					if v_upvr:FindFirstChild(i_4) then
						SetVisible_upvr(i_4, true)
						clone_2_upvr.Visible = true
						clone_3_upvr.Visible = true
					else
						SetVisible_upvr(i_4)
					end
				end
			end
			UpdateVisibility()
			Util_upvr.Maid.new():GiveTask(any_GetLink_result1.BallIndex.Changed:Connect(UpdateVisibility))
		end
	end
	return Util_upvr.Maid.new()
end
return module