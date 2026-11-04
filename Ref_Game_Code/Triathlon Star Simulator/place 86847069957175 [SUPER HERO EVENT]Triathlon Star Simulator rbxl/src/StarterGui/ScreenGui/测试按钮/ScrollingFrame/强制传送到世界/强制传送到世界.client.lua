-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:56
-- Luau version 6, Types version 3
-- Time taken: 0.000468 seconds

local _____________upvr = game:GetService("ReplicatedStorage")["测试消息"]["特殊处理"]
local ______ID_upvr = script.Parent.Parent.Parent["背包系统"]["道具ID"]
script.Parent.MouseButton1Click:Connect(function() -- Line 7
	--[[ Upvalues[2]:
		[1]: _____________upvr (readonly)
		[2]: ______ID_upvr (readonly)
	]]
	require(game.ReplicatedStorage.Tool.SoundModule):PlaySoundLocal("按钮点击")
	_____________upvr:FireServer("强制传送到世界", ______ID_upvr.Text)
end)