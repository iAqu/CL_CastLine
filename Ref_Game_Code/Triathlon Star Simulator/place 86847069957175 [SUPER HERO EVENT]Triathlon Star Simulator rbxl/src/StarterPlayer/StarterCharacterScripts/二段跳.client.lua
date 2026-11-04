-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:31:10
-- Luau version 6, Types version 3
-- Time taken: 0.001287 seconds

local Humanoid_upvr = script.Parent:WaitForChild("Humanoid")
local var2_upvw = false
local tick_result1_upvw = tick()
Humanoid_upvr.UseJumpPower = false
local AnimationModule_upvr = require(game.ReplicatedStorage.Tool.AnimationModule)
local Animator_upvr = Humanoid_upvr:FindFirstChild("Animator")
local function _() -- Line 21, Named "jumpRequest"
	--[[ Upvalues[5]:
		[1]: tick_result1_upvw (read and write)
		[2]: Humanoid_upvr (readonly)
		[3]: var2_upvw (read and write)
		[4]: AnimationModule_upvr (readonly)
		[5]: Animator_upvr (readonly)
	]]
	if 0.2 < tick() - tick_result1_upvw and Humanoid_upvr:GetState() == Enum.HumanoidStateType.Freefall and not var2_upvw then
		var2_upvw = true
		Humanoid_upvr:ChangeState(Enum.HumanoidStateType.Jumping)
		AnimationModule_upvr.PlayAnim(Animator_upvr, "DoubleJump")
	end
end
local SoundModule_upvr = require(game.ReplicatedStorage.Tool.SoundModule)
Humanoid_upvr.StateChanged:Connect(function(arg1, arg2) -- Line 37
	--[[ Upvalues[3]:
		[1]: var2_upvw (read and write)
		[2]: tick_result1_upvw (read and write)
		[3]: SoundModule_upvr (readonly)
	]]
	if arg2 == Enum.HumanoidStateType.Landed then
		var2_upvw = false
	end
	if arg2 == Enum.HumanoidStateType.Jumping then
		tick_result1_upvw = tick()
		if var2_upvw then return end
		SoundModule_upvr:PlaySoundLocal({
			SoundName = "音效-跳跃1";
		})
	end
end)
local TrainEquipment_upvr = game.Players.LocalPlayer:WaitForChild("TrainEquipment", math.huge)
local RemoteEvent_upvr = game.ReplicatedStorage.Msg.RemoteEvent
game:GetService("UserInputService").InputBegan:Connect(function(arg1) -- Line 63
	--[[ Upvalues[2]:
		[1]: TrainEquipment_upvr (readonly)
		[2]: RemoteEvent_upvr (readonly)
	]]
	if arg1.KeyCode == Enum.KeyCode.Space or arg1.KeyCode == Enum.KeyCode.ButtonB then
		if 0 < TrainEquipment_upvr.Value then
			RemoteEvent_upvr:FireServer("退出训练")
		end
	end
end)