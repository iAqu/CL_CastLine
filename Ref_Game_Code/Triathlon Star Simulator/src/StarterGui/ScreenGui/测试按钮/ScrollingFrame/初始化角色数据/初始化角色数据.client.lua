-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:33
-- Luau version 6, Types version 3
-- Time taken: 0.000438 seconds

local ______________________upvr = game:GetService("ReplicatedStorage")["测试消息"]["初始化角色数据"]
script.Parent.MouseButton1Click:Connect(function() -- Line 7
	--[[ Upvalues[1]:
		[1]: ______________________upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	______________________upvr:FireServer()
end)