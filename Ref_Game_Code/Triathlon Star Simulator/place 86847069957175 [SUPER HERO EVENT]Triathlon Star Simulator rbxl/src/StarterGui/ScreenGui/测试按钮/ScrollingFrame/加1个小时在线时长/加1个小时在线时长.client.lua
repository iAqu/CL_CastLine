-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:02
-- Luau version 6, Types version 3
-- Time taken: 0.000479 seconds

local _____________upvr = game:GetService("ReplicatedStorage")["测试消息"]["特殊处理"]
script.Parent.MouseButton1Click:Connect(function() -- Line 6
	--[[ Upvalues[1]:
		[1]: _____________upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	_____________upvr:FireServer("加1个小时在线时长")
end)