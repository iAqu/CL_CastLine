-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:23
-- Luau version 6, Types version 3
-- Time taken: 0.001028 seconds

local Parent_upvr = script.Parent
local udim2_upvr = UDim2.new(0, 5000, 0, 5000)
local function Show_upvr() -- Line 10, Named "Show"
	--[[ Upvalues[2]:
		[1]: Parent_upvr (readonly)
		[2]: udim2_upvr (readonly)
	]]
	if Parent_upvr.Visible then
	else
		Parent_upvr.Rotation = 0
		Parent_upvr.Size = UDim2.new(0, 1, 0, 1)
		Parent_upvr.Visible = true
		local any_Create_result1_upvw = game.TweenService:Create(Parent_upvr, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = udim2_upvr;
			Rotation = 180;
		})
		local any_Create_result1_upvw_2 = game.TweenService:Create(Parent_upvr, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 1, 0, 1);
			Rotation = 0;
		})
		local var8_upvw
		var8_upvw = any_Create_result1_upvw_2.Completed:Connect(function() -- Line 23
			--[[ Upvalues[3]:
				[1]: var8_upvw (read and write)
				[2]: any_Create_result1_upvw_2 (read and write)
				[3]: Parent_upvr (copied, readonly)
			]]
			var8_upvw:Disconnect()
			var8_upvw = nil
			any_Create_result1_upvw_2:Destroy()
			any_Create_result1_upvw_2 = nil
			Parent_upvr.Visible = false
		end)
		local var10_upvw
		var10_upvw = any_Create_result1_upvw.Completed:Connect(function() -- Line 34
			--[[ Upvalues[3]:
				[1]: var10_upvw (read and write)
				[2]: any_Create_result1_upvw (read and write)
				[3]: any_Create_result1_upvw_2 (read and write)
			]]
			var10_upvw:Disconnect()
			var10_upvw = nil
			any_Create_result1_upvw:Destroy()
			any_Create_result1_upvw = nil
			wait(1)
			any_Create_result1_upvw_2:Play()
		end)
		any_Create_result1_upvw:Play()
	end
end
game.ReplicatedStorage.Msg["转场"].OnClientEvent:Connect(function() -- Line 49
	--[[ Upvalues[1]:
		[1]: Show_upvr (readonly)
	]]
	Show_upvr()
end)