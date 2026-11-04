-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:17
-- Luau version 6, Types version 3
-- Time taken: 0.000535 seconds

local GM_______upvr = game:GetService("ReplicatedStorage")["测试消息"]["GM邮件"]
script.Parent.MouseButton1Click:Connect(function() -- Line 9
	--[[ Upvalues[1]:
		[1]: GM_______upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	GM_______upvr:InvokeServer("查询buff")
end)