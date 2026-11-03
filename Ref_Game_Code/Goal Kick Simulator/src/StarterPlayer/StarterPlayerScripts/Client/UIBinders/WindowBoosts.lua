-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:04
-- Luau version 6, Types version 3
-- Time taken: 0.004894 seconds

local module = {}
local tbl_3_upvr = {
	DGoldB = {
		Icon = "rbxassetid://9552349211";
		Description = "Double your Coins income!\nSource: Money Boost";
	};
	DExpB = {
		Icon = "rbxassetid://9520375093";
		Description = "Double your Ball XP!\nSource: Bapp XP Boost";
	};
	TripleChest = {
		Icon = "rbxassetid://9569356603";
		Description = "Triple Chest\nSource: Triple Chest Game Pass";
	};
	LegendaryLuck = {
		Icon = "rbxassetid://9571810375";
		Description = "+12 Luck\nSource: Legendary Luck Game Pass";
	};
	SuperLuck = {
		Icon = "rbxassetid://9571810085";
		Description = "+3 Luck\nSource: Super Luck Game Pass";
	};
	Luck = {
		Icon = "rbxassetid://9571810248";
		Description = "+1 Luck\nSource: Luck Game Pass";
	};
	InfLuck = {
		Icon = "rbxassetid://10020652859";
		Description = "+10,000 Luck\nSource: INFINITY Luck Boost";
	};
	Luck1B = {
		Icon = "rbxassetid://9571637099";
		Description = "+3 Luck\nSource: Better Luck Boost";
	};
	Luck2B = {
		Icon = "rbxassetid://9571636832";
		Description = "+5 Luck\nSource: ULTRA Luck Boost";
	};
	VIP = {
		Icon = "rbxassetid://9571806295";
		Description = "Gain 50% more EXP!\nSource: VIP Game Pass";
	};
	LowerPowerUp = {
		Icon = "rbxassetid://9571836145";
		Description = "Increases Power Up Areas Spawn Rate!\nSource: Power Up Area Boost (Lower Cooldown) Game Pass";
	};
}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 54
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_3_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local function AdjustBoost(arg1_2) -- Line 61
		--[[ Upvalues[5]:
			[1]: any_GetLink_result1_upvr (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: tbl_3_upvr (copied, readonly)
			[5]: arg1 (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var20_upvr = any_GetLink_result1_upvr.Boosts[arg1_2]
		local var21_upvr
		if not var20_upvr then
			var21_upvr = any_new_result1_upvr
			var21_upvr[arg1_2] = nil
		else
			var21_upvr = any_new_result1_upvr[arg1_2]
			if not var21_upvr then
				var21_upvr = Util_upvr.Maid.new()
			end
			if not any_new_result1_upvr[arg1_2] then
				any_new_result1_upvr[arg1_2] = var21_upvr
			end
			local var22_upvr = tbl_3_upvr[arg1_2]
			local var23 = any_new_result1_upvr[arg1_2]
			if var23 then
				var23 = any_new_result1_upvr[arg1_2].Frame
			end
			if not var23 then
				local clone_upvw = arg1.Assets.BoostFrame:Clone()
				clone_upvw.Visible = true
				var21_upvr.Enter = clone_upvw.MouseEnter:Connect(function() -- Line 75
					--[[ Upvalues[4]:
						[1]: Util_upvr (copied, readonly)
						[2]: var22_upvr (readonly)
						[3]: arg1_2 (readonly)
						[4]: var21_upvr (readonly)
					]]
					local tbl = {}
					local tbl_2 = {
						ActionType = "DefaultText";
					}
					local tbl_4 = {}
					local var29
					local function INLINED() -- Internal function, doesn't exist in bytecode
						var29 = var22_upvr.Description
						return var29
					end
					if not var22_upvr or not INLINED() then
						var29 = "Missing Icon: "..arg1_2
					end
					tbl_4.Text = var29
					tbl_2.Property = tbl_4
					tbl[1] = tbl_2
					Util_upvr.FocusFrame:Show(tbl)
					function var21_upvr.LeaveFocus() -- Line 84
						--[[ Upvalues[1]:
							[1]: Util_upvr (copied, readonly)
						]]
						Util_upvr.FocusFrame:Clear()
					end
				end)
				var21_upvr.Leave = clone_upvw.MouseLeave:Connect(function() -- Line 88
					--[[ Upvalues[1]:
						[1]: var21_upvr (readonly)
					]]
					var21_upvr.LeaveFocus = nil
				end)
				clone_upvw.Parent = arg1
			end
			local function UpdateTimer() -- Line 94
				--[[ Upvalues[3]:
					[1]: clone_upvw (read and write)
					[2]: var20_upvr (readonly)
					[3]: Util_upvr (copied, readonly)
				]]
				local var32
				if not clone_upvw.Parent then
				else
					if var20_upvr.Infinite then
						var32 = 1000000
					else
						var32 = var20_upvr.Value
						if not var32 then
							var32 = 0
						end
					end
					clone_upvw.LayoutOrder = var32
					var32 = clone_upvw
					if var20_upvr.Infinite then
						var32 = "∞"
					else
						local function INLINED_2() -- Internal function, doesn't exist in bytecode
							var32 = Util_upvr.ValueConvertor:FormatShortTime(var20_upvr.Value)
							return var32
						end
						if not var20_upvr.Value or not INLINED_2() then
							var32 = '-'
						end
					end
					var32.Label.Text = var32
				end
			end
			var21_upvr.ValueChanged1 = var20_upvr.Changed:On("Value", UpdateTimer)
			var21_upvr.ValueChanged2 = var20_upvr.Changed:On("Infinite", UpdateTimer)
			var21_upvr.Frame = clone_upvw
			if not clone_upvw.Parent then
				-- KONSTANTWARNING: GOTO [130] #98
			end
			if var20_upvr.Infinite then
				local _ = 1000000
			elseif not var20_upvr.Value then
			end
			clone_upvw.LayoutOrder = 0
			if var20_upvr.Infinite then
				local _ = "∞"
			elseif not var20_upvr.Value or not Util_upvr.ValueConvertor:FormatShortTime(var20_upvr.Value) then
			end
			clone_upvw.Label.Text = '-'
			if not clone_upvw.Parent then return end
			if not var22_upvr or not var22_upvr.Icon then
			end
			clone_upvw.Content.ImageIcon.Image = Util_upvr.Icons.default_missing
		end
	end
	for i in pairs(Util_upvr.Link:GetRawLink("PlayerData").Boosts) do
		AdjustBoost(i)
	end
	any_new_result1_upvr:GiveTask(any_GetLink_result1_upvr.Boosts.Changed:Connect(AdjustBoost))
	return any_new_result1_upvr
end
return module