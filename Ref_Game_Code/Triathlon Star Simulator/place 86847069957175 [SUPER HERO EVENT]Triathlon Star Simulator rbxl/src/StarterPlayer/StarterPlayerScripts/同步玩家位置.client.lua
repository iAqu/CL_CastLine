-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:51
-- Luau version 6, Types version 3
-- Time taken: 0.002300 seconds

local Players_upvr = game:GetService("Players")
local AddListen_upvr = require(game:GetService("ReplicatedStorage").Tool.AddListen)
local tbl_upvr = {}
local function BindToSyn_upvr(arg1) -- Line 14, Named "BindToSyn"
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local PlayerCFrame = arg1:WaitForChild("PlayerCFrame", 10)
	if PlayerCFrame and not tbl_upvr[arg1.UserId] then
		local Character_4 = arg1.Character
		if Character_4 then
			if Character_4 and Character_4.PrimaryPart then
				Character_4.PrimaryPart.Anchored = true
			end
			Character_4:PivotTo(PlayerCFrame.Value)
		end
		tbl_upvr[arg1.UserId] = PlayerCFrame.Changed:Connect(function(arg1_2) -- Line 33
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			local Character = arg1.Character
			if Character then
				if Character and Character.PrimaryPart then
					Character.PrimaryPart.Anchored = true
				end
				Character:PivotTo(arg1_2)
			end
		end)
	end
end
local function _(arg1) -- Line 52, Named "UnbindToSyn"
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if tbl_upvr[arg1.UserId] then
		tbl_upvr[arg1.UserId]:Disconnect()
		tbl_upvr[arg1.UserId] = nil
	end
	local Character_6 = arg1.Character
	if Character_6 and Character_6 and Character_6.PrimaryPart then
		Character_6.PrimaryPart.Anchored = false
	end
end
game.Players.PlayerAdded:Connect(function(arg1) -- Line 70
	--[[ Upvalues[3]:
		[1]: AddListen_upvr (readonly)
		[2]: BindToSyn_upvr (readonly)
		[3]: tbl_upvr (readonly)
	]]
	local IsSynCFrame_3 = arg1:WaitForChild("IsSynCFrame", 10)
	if IsSynCFrame_3 then
		AddListen_upvr.NumValueAdd(IsSynCFrame_3, function(arg1_3) -- Line 75
			--[[ Upvalues[3]:
				[1]: BindToSyn_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: tbl_upvr (copied, readonly)
			]]
			if arg1_3 == true then
				BindToSyn_upvr(arg1)
			else
				local var16 = arg1
				if tbl_upvr[var16.UserId] then
					tbl_upvr[var16.UserId]:Disconnect()
					tbl_upvr[var16.UserId] = nil
				end
				local Character_5 = var16.Character
				if Character_5 and Character_5 and Character_5.PrimaryPart then
					Character_5.PrimaryPart.Anchored = false
				end
			end
		end)
	end
end)
for _, v_upvr in pairs(Players_upvr:GetPlayers()) do
	task.spawn(function() -- Line 92
		--[[ Upvalues[5]:
			[1]: v_upvr (readonly)
			[2]: Players_upvr (readonly)
			[3]: AddListen_upvr (readonly)
			[4]: BindToSyn_upvr (readonly)
			[5]: tbl_upvr (readonly)
		]]
		if v_upvr ~= Players_upvr.LocalPlayer then
			local IsSynCFrame_2 = v_upvr:WaitForChild("IsSynCFrame", 10)
			if IsSynCFrame_2 then
				AddListen_upvr.NumValueAdd(IsSynCFrame_2, function(arg1) -- Line 99
					--[[ Upvalues[3]:
						[1]: BindToSyn_upvr (copied, readonly)
						[2]: v_upvr (copied, readonly)
						[3]: tbl_upvr (copied, readonly)
					]]
					if arg1 == true then
						BindToSyn_upvr(v_upvr)
					else
						local var28 = v_upvr
						if tbl_upvr[var28.UserId] then
							tbl_upvr[var28.UserId]:Disconnect()
							tbl_upvr[var28.UserId] = nil
						end
						local Character_2 = var28.Character
						if Character_2 and Character_2 and Character_2.PrimaryPart then
							Character_2.PrimaryPart.Anchored = false
						end
					end
				end)
			end
		end
	end)
end